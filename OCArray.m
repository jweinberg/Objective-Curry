//
//  OCArray.m
//  Objective-Curry
//
//  Created by Josh Weinberg on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OCArray.h"
#import "OCStream.h"

@implementation OCArray

+ (id)arrayWithStream:(OCStream*)aStream;
{
    return [[[OCArray alloc] initWithStream:aStream] autorelease];
}

- (id)initWithStream:(OCStream*)aStream;
{
    if ((self = [super init]))
    {
        _stream = [aStream retain];
    }
    return self;
}

- (void)dealloc;
{
    [_stream release];
    [super dealloc];
}

- (id)objectAtIndex:(NSUInteger)index;
{
    return [[_stream drop:index] head];
}

- (NSUInteger)count;
{
    return [_stream length];
}

- (NSArray *)subarrayWithRange:(NSRange)range;
{
    if (range.location + range.length > [self count])
        return nil;
    return [OCArray arrayWithStream:[[_stream drop:range.location] take:range.length]];
}

@end
