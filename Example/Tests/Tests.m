//
//  ReactiveLevelCacheTests.m
//  ReactiveLevelCacheTests
//
//  Created by Hai Feng Kao on 09/25/2016.
//  Copyright (c) 2016 Hai Feng Kao. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

#import "RACLevelCache.h"
#import "RACTuple.h"
#import "RACSignal.h"

SPEC_BEGIN(InitialTests)

describe(@"RACLevelCache", ^{

    let(testee, ^{ // Occurs before each enclosed "it"
        return [[RACLevelCache alloc] initWithName:@"original"];
    });
    let(done, ^{ // Occurs before each enclosed "it"
        return @(0);
    });
    
    beforeAll(^{ // Occurs once
    });
    
    afterAll(^{ // Occurs once
    });
    
    beforeEach(^{ // Occurs before each enclosed "it"
        UIImage* img = [[UIImage alloc] init];
        [testee setObject:img forKey:@"img"];
    });
    
    afterEach(^{ // Occurs after each enclosed "it"
        [testee removeAll];
    });

    it(@"should not store object with nil key", ^{
        UIImage* img = [[UIImage alloc] init];
        [testee setObject:img forKey:nil];
        done = @(1);
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(2000.0)] beTrue];
    });

    it(@"should not store nil image to cache", ^{
        [testee setObject:nil forKey:@"img"];
        done = @(1);
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(2000.0)] beTrue];
    });
    
    it(@"should get the image from cache", ^{
        RACSignal* signal = [testee objectForKey:@"img"];
        [signal subscribeNext:^(UIImage* image) {
            [[image shouldNot] beNil];
            done = @(1);
        }];
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(2000.0)] beTrue];
    });

    it(@"should get file attributes from cache", ^{
        RACSignal* signal = [testee objectForKeyExt:@"img"];
        [signal subscribeNext:^(RACTuple* tuple) {
            RACTupleUnpack(UIImage* image, NSDictionary* attributes) = tuple;
            [[image shouldNot] beNil];
            [[attributes[NSFileModificationDate] shouldNot] beNil];
            done = @(1);
        }];
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(2000.0)] beTrue];
    });
    
    it(@"should remove the image from cache", ^{
        [testee remove:@"img"];
        RACSignal* signal = [testee objectForKey:@"img"];
        [signal subscribeNext:^(UIImage* image) {
            NSAssert(NO, @"should not return anything");
        } error:^(NSError* error) {
            done = @(1);
        }];
        [[expectFutureValue(done) shouldEventuallyBeforeTimingOutAfter(2000.0)] beTrue];
    });
});

SPEC_END

