/*
 Copyright (c) 2010, Josh Weinberg
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of Objective-Curry nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY Josh Weinberg ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL Josh Weinberg BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OCStream.h"
#import "OCStreamEnumerator.h"

@implementation OCStream


+ (id)streamWithValue:(id)value generator:(GeneratorBlock)nextValue;
{
    return [[[OCStream alloc] initWithValue:value generator:nextValue] autorelease];
}

- (id)initWithValue:(id)value generator:(GeneratorBlock)nextValue;
{
    if ((self = [super init]))
    {
        _head = [value retain];
        _nextValue = [nextValue copy];
    }
    return self;
}

- (void)dealloc;
{
    [_head release], _head = nil;
    [_nextValue release], _nextValue = nil;
    [super dealloc];
}

- (NSUInteger)length;
{
    OCStream * stream = self;
    NSUInteger count = 0;
    while (stream)
    {
        count++;
        if (count == UINT_MAX)
            return count;
        stream = [stream tail];
    }
    return count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    NSEnumerator *enumerator = nil;
    if (state->state == 0)
        enumerator = [self enumerator];
    else
        enumerator = (NSEnumerator*)state->state;
    
    NSUInteger batchCount = 0;
    id object = nil;
    while (batchCount < len && (object = [enumerator nextObject]))
    {
        stackbuf[batchCount++] = object;
    }
    
    state->state = (unsigned long)enumerator;
    state->itemsPtr = stackbuf;
    state->mutationsPtr = (unsigned long *)self;
    
    return batchCount;
}

- (NSEnumerator*)enumerator;
{
    return [[[OCStreamEnumerator alloc] initWithStream:self] autorelease];
}

- (NSString*) description;
{
    return [NSString stringWithFormat:@"(%@ ... ?)", [self head]];
}

- (id)head;
{

    if (_dirtyHead)
    {
        OCStream *tmpStream = _nextValue();
        [_head release];
        [_nextValue release];
        
        _head = [tmpStream->_head retain];
        _nextValue = [tmpStream->_nextValue retain];
        
        _dirtyHead = NO;
    }
    return _head;
}

- (OCStream*)take:(int)count;
{
    if ([self head] == nil)
        return nil;
    
    OCStream *retStream = [OCStream streamWithValue:[self head]
                                          generator:^OCStream*(void)
                           {
                               OCStream * stream = [self tail];
                               if (count <= 1)
                                   return nil;
                               
                               return [stream take:count-1];
                           }];
    if (retStream)
    {
        retStream->_dirtyHead = _dirtyHead;
    }
    return retStream;
}

- (OCStream*)drop:(int)count;
{
    if ([self head] == nil)
        return nil;
    
    OCStream *retStream = [OCStream streamWithValue:[self head]
                                          generator:^OCStream*(void)
                           {
                               OCStream * stream = self;
                               for (int i = 0; i < count; ++i)
                               {
                                   stream = [stream tail];
                                   if (!stream)
                                       return nil;
                               }
                               return stream;
                           }];
    if (retStream)
    {
        retStream->_dirtyHead = YES;
    }
    return retStream;
}

- (OCStream*)tail;
{
    OCStream *retStream = _nextValue();
    return retStream;
}

- (OCStream*)filter:(id(^)(id))block;
{
    if ([self head] == nil)
        return nil;
    
    OCStream *retStream = [OCStream streamWithValue:[self head]
                                          generator:^OCStream*(void)
                           {   
                               OCStream * stream = [self tail];
                               id val = [stream head];

                               while(![block(val) boolValue])
                               {
                                   stream = [stream tail];
                                   if (!stream)
                                       return nil;
                                   val = [stream head];
                               } 
                               return [stream filter:block];
                           }];
    if (retStream)
    {
        if (![block([self head]) boolValue])
            retStream->_dirtyHead = YES;
    }
    return retStream;
}

- (OCStream*)map:(id(^)(id))block;
{
    if ([self head] == nil)
        return nil;
    
    OCStream *retStream = [OCStream streamWithValue:block([self head])
                                          generator:^OCStream*
                           {   
                               return [[self tail] map:block];
                           }];
    if (retStream)
    {
        retStream->_dirtyHead = NO;
    }
    return retStream;    
}

- (OCStream*)zip:(OCStream*)aStream;
{
    if ([self head] == nil)
        return nil;
    
    OCStream *retStream = [OCStream streamWithValue:[NSArray arrayWithObjects:[self head], [aStream head], nil]
                                          generator:^OCStream*
                           {   
                               return [[self tail] zip:[aStream tail]];
                           }];
    if (retStream)
    {
        retStream->_dirtyHead = _dirtyHead;
    }
    return retStream;
}

- (OCStream*)generate:(int)count performBlock:(void (^)(id))block;
{
    OCStream * newStream = self;
    id newValue = [newStream head];
    for (int i = 0; i < count; ++i)
    {
        block(newValue);
        newStream = [newStream tail];
        if (!newStream)
            break;
        newValue = [newStream head];
    }
    
    return newStream;
}

@end
