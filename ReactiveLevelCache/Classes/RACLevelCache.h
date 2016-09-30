//
//  RACLevelCache.h
//  Classes
//
//  Created by Hai Feng Kao on 2016/09/25.
//
//

#import <Foundation/Foundation.h>
#import "RACCache.h"

@interface RACLevelCache : NSObject<RACCache>
// get the object from the cache
- (RACSignal*)objectForKey:(NSString *)key;
// put the object in the cache
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (void)remove:(NSString*)key;
- (void)removeAll;

// get the tuple (NSData, object attributes) from the cache
- (RACSignal*)objectForKeyExt:(NSString *)key;
// return the cache size in bytes
- (double)cacheSize;

// return tuple (NSData, properties)
- (RACSignal*)objectForKeyExt:(NSString *)key;
@end
