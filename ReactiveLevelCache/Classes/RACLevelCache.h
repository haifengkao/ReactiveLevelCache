//
//  RACLevelCache.h
//  Classes
//
//  Created by Hai Feng Kao on 2016/09/25.
//
//

#import <Foundation/Foundation.h>

@import ReactiveCache;
@class RACSignal;

@interface RACLevelCache : NSObject<RACCache>
- (instancetype)initWithName:(NSString*) name;

#pragma mark - Reactive Cache Protocol
// get the object from the cache
- (RACSignal*)objectForKey:(NSString *)key;
// put the object in the cache
- (void)setObject:(NSObject<NSCoding>*)object forKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll:(void(^)())completion;

// get a tuple (NSData*, NSDictinoary* object_attributes) from the cache
- (RACSignal*)objectForKeyExt:(NSString *)key;
// return the cache size in bytes
- (double)cacheSize;

@end
