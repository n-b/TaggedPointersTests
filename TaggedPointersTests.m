//
//  TaggedPointersTests.m
//  TaggedPointersTests
//
//  Created by Nicolas Bouilleaud on 08/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

/****************************************************************************/
#pragma mark Platform checks

@interface TaggedPointersTests : SenTestCase 
@end
@implementation TaggedPointersTests

- (void) setUp
{
    [super setUp];
#if ! defined(__x86_64__)
    STFail(@"These tests are only valid in 64-bit");
#endif
}
@end

/****************************************************************************/
#pragma mark NSNumber Tests

@interface TaggedPointersTests_NSNumber : TaggedPointersTests
@end
@implementation TaggedPointersTests_NSNumber

- (void) testSanity
{
    NSNumber * obj1 = [NSNumber numberWithInt:42];
    NSNumber * obj2 = [NSNumber numberWithInt:42];
    STAssertEqualObjects(obj1, obj2, @"both objects are equal");
}

- (void) testPointerEquality
{
    NSNumber * obj1 = [NSNumber numberWithInt:42];
    NSNumber * obj2 = [NSNumber numberWithInt:42];
    STAssertEquals(obj1, obj2, @"both objects are **the same**");
}

- (void) testPointerValue
{
    NSNumber * object = [NSNumber numberWithInt:42];
    // shifting the last byte reveals the value
    STAssertEquals(42, (int)((long)object>>8), @"the value is in the pointer");
}

- (void) testMonkey
{
    for (int i=0; i<1000; i++) {
        int value = (int)random();
        NSNumber * object = [NSNumber numberWithInt:value];
        STAssertEquals(value, (int)((long)object>>8), @"the value is in the pointer");
    }
}

@end

/****************************************************************************/
#pragma mark NSDate tests

@interface TaggedPointersTests_NSDate : TaggedPointersTests
@end

@implementation TaggedPointersTests_NSDate

typedef union _DoupleOrPointer {
    NSTimeInterval interval;
    void * p;
} DoupleOrPointer;

- (void) testPointerValue
{
    DoupleOrPointer dop = {.interval = 42.0};
    NSDate * object = [NSDate dateWithTimeIntervalSinceReferenceDate:dop.interval];
    // Masking out the last byte gives the passed interval
    STAssertEquals(dop.p, (void*)((long)object&0xFFFFFFFFFFFFFF00), @"the pointer is the value");
}

- (void) testMonkey
{
    for (int i=0; i<1000; i++) {
        DoupleOrPointer dop = {.interval = (double)random()};
        NSDate * object = [NSDate dateWithTimeIntervalSinceReferenceDate:dop.interval];
        // Masking out the last byte gives the passed interval
        STAssertEquals(dop.p, (void*)((long)object&0xFFFFFFFFFFFFFF00), @"the pointer is the value");
    }
}
@end
