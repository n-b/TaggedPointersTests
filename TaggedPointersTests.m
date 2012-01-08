//
//  TaggedPointersTests.m
//  TaggedPointersTests
//
//  Created by Nicolas Bouilleaud on 08/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

/****************************************************************************/
#pragma mark NSNumber Tests

@interface TaggedPointersTests_NSNumber : SenTestCase
@end
@implementation TaggedPointersTests_NSNumber

- (void) testNSNumberInt16
{
    short value = (short)random();
    NSNumber * obj1 = [NSNumber numberWithShort:value];
    NSNumber * obj2 = [NSNumber numberWithShort:value];
    
    STAssertEqualObjects(obj1, obj2, @"both objects are equal");
    STAssertEquals(obj1, obj2, @"both objects are **the same**");
    STAssertEquals(value, (short)((long)obj1>>8), @"the pointer is the value");
}

- (void) testNSNumberInt32
{
    int value = (int)random();
    NSNumber * obj1 = [NSNumber numberWithInt:value];
    NSNumber * obj2 = [NSNumber numberWithInt:value];
    
    STAssertEqualObjects(obj1, obj2, @"both objects are equal");
    STAssertEquals(obj1, obj2, @"both objects are **the same**");
    STAssertEquals(value, (int)((long)obj1>>8), @"the pointer is the value");
}

- (void) testNSNumberInt64
{
    long value = random(); // long is the same as long long in 64-bit
    NSNumber * obj1 = [NSNumber numberWithLong:value];
    NSNumber * obj2 = [NSNumber numberWithLong:value];
    
    STAssertEqualObjects(obj1, obj2, @"both objects are equal");
    STAssertEquals(obj1, obj2, @"both objects are **the same**");
    STAssertEquals(value, (long)((long)obj1>>8), @"the pointer is the value");
}

@end

/****************************************************************************/
#pragma mark NSDate tests

@interface TaggedPointersTests_NSDate : SenTestCase
@end

@implementation TaggedPointersTests_NSDate

typedef union _DoupleOrPointer {
    NSTimeInterval interval;
    void * p;
} DoupleOrPointer;

- (void) testNSDateSinceReference
{
    DoupleOrPointer dop = {.interval = 0.0};
    
    NSDate * object = [NSDate dateWithTimeIntervalSinceReferenceDate:dop.interval];

    // Masking out the last 4 bits gives the passed interval
    STAssertEquals(dop.p, (void*)((long)object&0xFFFFFFFFFFFFFFF0), @"the pointer is the value");
}

@end



/****************************************************************************/
#pragma mark CoreData Tests

@interface TaggedPointersTests_NSManagedObjectID : SenTestCase
@end

@implementation TaggedPointersTests_NSManagedObjectID

- (void) testCoreData
{
    return;
    // It seems CoreData does not (yet) use, at least externally, tagged pointers for NSManagedObjectIDs
    // This code is left here for future reference.
    
    NSEntityDescription * entity = [NSEntityDescription new];
    entity.name = @"entity";
    NSAttributeDescription * attribute = [NSAttributeDescription new];
    attribute.attributeType = NSInteger64AttributeType;
    attribute.name = @"attribute";
    [entity setProperties:[NSArray arrayWithObject:attribute]];
    NSManagedObjectModel * model = [NSManagedObjectModel new];
    model.entities = [NSArray arrayWithObject:entity];
    NSPersistentStoreCoordinator * coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSError * error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:@"/tmp/test.sqlite"] options:nil error:&error];
    NSManagedObjectContext * context = [NSManagedObjectContext new];
    context.persistentStoreCoordinator = coordinator;
    
    
    NSFetchRequest * request = [NSFetchRequest new];
    request.entity = entity;
    NSArray * array = [context executeFetchRequest:request error:&error];
    for (NSManagedObject * object in array) {
        NSManagedObjectID * objectID = [object objectID];
        printf("objectID : %p (%d)\n",objectID,(int)objectID>>8);
    }
    
    
    for (int i=0; i<1000; i++) {
        NSManagedObject * object = [NSEntityDescription insertNewObjectForEntityForName:@"entity" inManagedObjectContext:context];
        [object setValue:[NSNumber numberWithInt:i] forKey:@"attribute"];
    }
    [context save:&error];
    
    request = [NSFetchRequest new];
    request.entity = entity;
    request.resultType = NSManagedObjectIDResultType;
    array = [context executeFetchRequest:request error:&error];
    for (NSManagedObjectID * objectID in array) {
        printf("objectID : %p (%d)\n",objectID,(int)objectID>>8);
    }
}


@end
