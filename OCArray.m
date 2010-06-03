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
        _stream = aStream;
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

@end
