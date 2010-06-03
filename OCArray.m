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
    [_cachedReadStream release];
    [super dealloc];
}

- (id)objectAtIndex:(NSUInteger)index;
{
    if (_cachedOffset > index)
    {
        [_cachedReadStream release];
        _cachedReadStream = [[_stream drop:index] retain];
    }
    else
    {
        OCStream * newStream = [_cachedReadStream drop:index - _cachedOffset];
        [_cachedReadStream release];
        _cachedReadStream = [newStream retain];
    }
    
    _cachedOffset = index;
    return [_cachedReadStream head];
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

- (NSEnumerator *)objectEnumerator;
{
    return [_stream enumerator];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;
{
    return [_stream countByEnumeratingWithState:state objects:stackbuf count:len];
}


@end
