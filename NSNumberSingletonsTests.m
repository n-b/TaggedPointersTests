//
//  NSNumberSingletonsTests.m
//  NSNumberSingletonsTests
//
//  Created by Nicolas Bouilleaud on 08/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface NSNumberSingletonsTests : SenTestCase
@end

@implementation NSNumberSingletonsTests

- (void) testNSNumberSingletons
{
    for (int i = -1000; i<=1000; i++) {
        // NSNumber between -1 and 12 are singletons
        if(i>=-1 && i<=12)
            STAssertTrue( [NSNumber numberWithInt:i] == [NSNumber numberWithInt:i],
                         @"both objects should be the same for value %d",i);
        else
            STAssertFalse( [NSNumber numberWithInt:i] == [NSNumber numberWithInt:i],
                          @"both objects should not be the same for value %d",i);
    }
}

@end
