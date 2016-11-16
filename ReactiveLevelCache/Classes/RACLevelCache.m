//
//  RACLevelCache.m
//  ReactiveLevelCache
//
//  Created by Hai Feng Kao on 2016/09/25.
//
//

#import "RACLevelCache.h"
#import "RACSignal.h"
#import "RACTuple.h"
#import "LevelDB.h"
#import "StandardPaths.h"
#import "RACCache.h"

#ifndef SAFE_CAST
#define SAFE_CAST(Object, Type) (Type *)safe_cast_helper(Object, [Type class])
static inline id safe_cast_helper(id x, Class c) {
    return [x isKindOfClass:c] ? x : nil;
}
#endif

@interface RACLevelItem : NSObject
@property (strong) NSDictionary* attributes;
@property (strong) NSData* data;
@end

@implementation RACLevelItem

#pragma mark - Archiving
static NSString *DataKey = @"data";
static NSString *AttributesKey = @"attributes";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _data = [aDecoder decodeObjectForKey:DataKey];
        _attributes = [aDecoder decodeObjectForKey:AttributesKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.attributes forKey:AttributesKey];
    [aCoder encodeObject:self.data forKey:DataKey];
}

@end

@interface RACLevelCache()
@property (nonatomic, strong) LevelDB* db;
@end


@implementation RACLevelCache

- (instancetype)initWithName:(NSString*) name
{
    // offline data path won't be synced to iCloud
    NSString* cachePath = [[[NSFileManager defaultManager] offlineDataPath] stringByAppendingPathComponent:name];
    
    if (cachePath == nil) {
        NSAssert(NO, @"bad argument");
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    LevelDBOptions options = [LevelDB makeOptions];
    options.createIfMissing = true;
    options.errorIfExists   = false;
    options.paranoidCheck   = false;
    options.compression     = true;
    options.filterPolicy    = 0;          // Size in bits per key, allocated for a bloom filter, used in testing presence of key
    options.cacheSize       = 65536;      // memory cache size in bytes, allocated for a LRU cache used for speeding up lookups
    
    // Then, you can provide it when initializing a db instance.
    _db = [[LevelDB alloc] initWithPath:cachePath name:name andOptions:options];
    
    return self;
}

- (void)dealloc
{
}

+ (NSError*)errorNotFound
{
    static NSError* notFound = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notFound = [NSError errorWithDomain:@"RACLevelCache" code:1 userInfo:@{NSLocalizedDescriptionKey:@"not in cache"}];
    });
    return notFound;
}

#pragma mark - Reactive Cache Protocol
- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key
{
    NSParameterAssert(object);
    NSParameterAssert(key);
    if (!key || !object) { return; } // nothing to do

    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    RACLevelItem* item = [[RACLevelItem alloc] init];
    item.attributes = @{NSFileModificationDate:[NSDate date], NSFileSize:@(data.length)};
    item.data = data;
    [self.db setObject:item forKey:key];
}

- (RACSignal*)objectForKey:(NSString*)key
{
    NSParameterAssert(key);
    if (!key) { return [RACSignal error:[[self class] errorNotFound]]; } // nothing to do

    RACLevelItem* item = (self.db)[key];
    if (!item) {
        return [RACSignal error:self.class.errorNotFound];
    } 
    id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:item.data];
    return [RACSignal return:object];
}

- (RACSignal*)objectForKeyEx:(NSString*)key
{
    NSParameterAssert(key);
    if (!key) { return [RACSignal error:[[self class] errorNotFound]]; } // nothing to do

    RACLevelItem* item = (self.db)[key];
    if (!item) {
        return [RACSignal error:self.class.errorNotFound];
    } 
    id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:item.data];
    return [RACSignal return:RACTuplePack(object, item.attributes)];
}

- (void)remove:(NSString *)key
{
    NSParameterAssert(key);
    if (!key) { return; } // nothing to do

    [self.db removeObjectForKey:key];
}

- (void)removeAll:(void(^)())completion
{
    [self.db removeAllObjects];
    if (completion) {
        completion();
    } 
} 
                     
- (double)cacheSize
{
    __block double size = 0.0f;
    [self.db enumerateKeysAndObjectsUsingBlock:^(LevelDBKey *key, id value, BOOL *stop) {
        RACLevelItem* item = SAFE_CAST(value, RACLevelItem);
        size += [item.data length];
    }];
    
    return size;;
}
@end
