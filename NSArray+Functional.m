//
//  NSArray+Functional.m
//  BlocksTest
//
//  Created by Josh Weinberg on 5/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

- (NSArray*)filter:(int(^)(id))block;
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (id item in self)
    {
        if (block(item))
            [temp addObject:item]; 
    }
    
    return temp;
}

- (NSArray*)map:(id(^)(id))block;
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (id item in self)
    {
        [temp addObject:block(item)]; 
    }
    
    return temp;
    
}

- (id)foldLeft:(id)start withBlock:(id(^)(id,id))block;
{
    id temp = start;
    for (id item in self)
    {
        temp = block(temp, item);
    }
    return temp;
}

- (id)foldRight:(id)start withBlock:(id(^)(id,id))block;
{
    id temp = start;
    for (id item in [self reverseObjectEnumerator])
    {
        temp = block(item, temp);
    }
    return temp;
}

- (id)reduceLeft:(id(^)(id,id))block;
{
    id temp = nil;
    for (id item in self)
    {
        if (temp)
            temp = block(temp, item);
        else
            temp = item;
    }
    return temp;   
}

- (id)reduceRight:(id(^)(id,id))block;
{
    id temp = nil;
    for (id item in [self reverseObjectEnumerator])
    {
        if (temp)
            temp = block(item, temp);
        else
            temp = item;
    }
    return temp;       
}

- (BOOL)forall:(BOOL(^)(id))block;
{
    for (id item in self)
    {
        if (!block(item))
            return NO;
    }
    return YES;
}
@end
