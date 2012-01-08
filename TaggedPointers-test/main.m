//
//  main.m
//  test
//
//  Created by Nicolas Bouilleaud on 18/12/11.
//  Copyright (c) 2011 Visuamobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        printf("---int16s\n");
        for (short i = -3; i<15; i++) {
            NSNumber * obj1 = [NSNumber numberWithShort:i];
            NSNumber * obj2 = [NSNumber numberWithShort:i];
            if(obj1==obj2)
                printf("%3d : same address : %p (%d)\n",i,obj1,(int)obj1>>8);
            else
                printf("%3d : different addresses (%p and %p)\n",i,obj1, obj2);
        }
        printf("---int32s\n");
        for (long i = -3; i<15; i++) {
            NSNumber * obj1 = [NSNumber numberWithLong:i];
            NSNumber * obj2 = [NSNumber numberWithLong:i];
            if(obj1==obj2)
                printf("%3ld : same address : %p (%d)\n",i,obj1,(int)obj1>>8);
            else
                printf("%3ld : different addresses (%p and %p)\n",i,obj1, obj2);
        }
        printf("---int64s\n");
        for (long long i = -3; i<15; i++) {
            NSNumber * obj1 = [NSNumber numberWithLongLong:i];
            NSNumber * obj2 = [NSNumber numberWithLongLong:i];
            if(obj1==obj2)
                printf("%3lld : same address : %p (%d)\n",i,obj1,(int)obj1>>8);
            else
                printf("%3lld : different addresses (%p and %p)\n",i,obj1, obj2);
        }
        printf("---booleans\n");
        for (BOOL b = NO; b==NO||b==YES; b++) {
            NSNumber * obj1 = [NSNumber numberWithBool:b];
            NSNumber * obj2 = [NSNumber numberWithBool:b];
            if(obj1==obj2)
                printf("%3s : same address (%p)\n",b?"YES":" NO",obj1);
            else
                printf("%3s : different addresses (%p and %p)\n",b?"YES":" NO",obj1, obj2);
        }
        /*
        printf("---dates since reference\n");
        for (NSTimeInterval i = -10; i<=10; i++) {
            union doubleOrPointer {
                NSTimeInterval interval;
                void * p;
            } dop;
            dop.interval = i;
            
            NSDate * obj1 = [NSDate dateWithTimeIntervalSinceReferenceDate:dop.interval];
            NSDate * obj2 = [NSDate dateWithTimeIntervalSinceReferenceDate:dop.interval];

            if(obj1==obj2)
                printf("%3.0f : same address : %p (%p)\n",dop.interval, obj1, dop.p);
            else
                printf("%3.0f : different addresses (%p and %p) (%p)\n",dop.interval, obj1, obj2, dop.p);
        }
         */
/*        printf("---dates sicne 1970\n");
        for (long i = -5; i<5; i++) {
            NSDate * obj1 = [NSDate dateWithTimeIntervalSince1970:i];
            NSDate * obj2 = [NSDate dateWithTimeIntervalSince1970:i];
            if(obj1==obj2)
                printf("%3ld : same address : %p (%d)\n",i,obj1,(int)obj1>>8);
            else
                printf("%3ld : different addresses (%p and %p)\n",i,obj1, obj2);
        }
        
        printf("---distantFuture\n");
        {
            NSDate * obj1 = [NSDate distantFuture];
            NSDate * obj2 = [NSDate distantFuture];
            if(obj1==obj2)
                printf("same address : %p (%d)\n",obj1,(int)obj1>>8);
            else
                printf("different addresses (%p and %p)\n",obj1, obj2);
        }
        printf("---distantPast\n");
        {
            NSDate * obj1 = [NSDate distantPast];
            NSDate * obj2 = [NSDate distantPast];
            if(obj1==obj2)
                printf("same address : %p (%d)\n",obj1,(int)obj1>>8);
            else
                printf("different addresses (%p and %p)\n",obj1, obj2);
        }

        printf("---coredata\n");
        {
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
            [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:@"/Users/nicolas/Desktop/test.sqlite"] options:nil error:&error];
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

        */
        fflush(stdout);
    }
    return 0;
}

