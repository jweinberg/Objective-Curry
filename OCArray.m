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

- (NSArray *)filteredArrayUsingPredicate:(NSPredicate *)predicate;
{
    return [OCArray arrayWithStream:[_stream filter:^(id arg1) {return [NSNumber numberWithBool:[predicate evaluateWithObject:arg1]];}]];
}

- (void)setValue:(id)value forKey:(NSString *)key;
{
    //this invalidates the cached search
    [_cachedReadStream release];
    _cachedReadStream = nil;
    _cachedOffset = 0;
    
    OCStream * newStream = [_stream map:^(id arg1) {[arg1 setValue:value forKey:key]; return arg1;}];
    [_stream release];
    _stream = [newStream retain];
}

@end
