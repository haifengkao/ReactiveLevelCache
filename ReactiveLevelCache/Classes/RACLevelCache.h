//
//  RACLevelCache.h
//  Classes
//
//  Created by Hai Feng Kao on 2016/09/25.
//
//

#import <Foundation/Foundation.h>

@import ReactiveCache;
@import ReactiveObjC;

@interface RACLevelCache: NSObject<RACCache>
- (instancetype)initWithName:(NSString*) name cachePath:(NSString*)cachePath;
- (id<NSCoding>)objectForKeySync:(NSString*)key;

#pragma mark - Reactive Cache Protocol
// get the object from the cache
- (RACSignal*)objectForKey:(NSString *)key;
// put the object in the cache
- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll:(void(^)(void))completion;

// get a tuple (NSData*, NSDictinoary* object_attributes) from the cache
- (RACSignal<RACTuple*>*)objectForKeyEx:(NSString*)key;
// return the cache size in bytes
- (double)cacheSize;

@end
