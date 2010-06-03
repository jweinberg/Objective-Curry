//  Copyright (c) 2010, Josh Weinberg
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the <organization> nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "OCStream.h"

@implementation OCStreamEnumerator

- (id)initWithStream:(OCStream*)aStream;
{
    if ((self=[super init]))
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

- (id)nextObject;
{
    id val = [_stream head];
    _stream = [[_stream tail] retain];
    return val;
}

@end


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


- (NSEnumerator*)enumerator;
{
    if (_hasDefiniteLength)
        return [[[OCStreamEnumerator alloc] initWithStream:self] autorelease];
    else
        return nil;
}

- (id)head;
{
    if (_dirtyHead)
    {
        OCStream *tmpStream = _nextValue(_nextValue, _head);
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
    OCStream *retStream = [OCStream streamWithValue:[self head]
                           generator:^OCStream*(id generatorBlock, id val)
                                        {
                                            OCStream * stream = _nextValue(_nextValue,val);
                                            if (count <= 1)
                                                return nil;
                                             
                                            return [stream take:count-1];
                                        }];
    if (retStream)
    {
        retStream->_hasDefiniteLength = YES;
        retStream->_dirtyHead = _dirtyHead;
    }
    return retStream;
}

- (OCStream*)drop:(int)count;
{
    OCStream *retStream = [OCStream streamWithValue:[self head]
                                          generator:^OCStream*(id generatorBlock, id val)
                                                        {
                                                            OCStream * stream = self;
                                                            for (int i = 0; i < count; ++i)
                                                            {
                                                                stream = stream->_nextValue(stream->_nextValue, val);
                                                                if (!stream)
                                                                    return nil;
                                                                val = [stream head];
                                                            }
                                                            return stream;
                                                        }];
    if (retStream)
    {
        retStream->_dirtyHead = YES;
        retStream->_hasDefiniteLength = _hasDefiniteLength;
    }
    return retStream;
}

- (OCStream*)tail;
{
    OCStream *retStream = _nextValue(_nextValue, [self head]);
    if (retStream)
        retStream->_hasDefiniteLength = _hasDefiniteLength;
    return retStream;
}

- (OCStream*)filter:(id(^)(id))block;
{
    OCStream *retStream = [OCStream streamWithValue:[self head]
                                          generator:^OCStream*(id generatorBlock, id val)
                                            {   
                                                OCStream * stream = _nextValue(_nextValue, val);
                                                if (stream)
                                                    val = [stream head];
                                                else 
                                                    return nil;
                                                while(![block(val) boolValue])
                                                {
                                                        stream = stream->_nextValue(stream->_nextValue, val);
                                                        if (stream)
                                                            val = [stream head];
                                                        else 
                                                            return nil;
                                                } 
                                                return [stream filter:block];
                                            }];
    if (retStream)
    {
        if (![block([self head]) boolValue])
            retStream->_dirtyHead = YES;
    
        retStream->_hasDefiniteLength = _hasDefiniteLength;
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
        newStream = newStream->_nextValue(newStream->_nextValue, newValue);
        if (!newStream)
            break;
        newValue = [newStream head];
    }
    
    return newStream;
}

@end