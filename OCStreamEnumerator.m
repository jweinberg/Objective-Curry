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

#import "OCStreamEnumerator.h"
#import "OCStream.h"
#import "OCArray.h"

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
    [_stream release];
    _stream = [[_stream tail] retain];
    return val;
}


- (NSArray*)allObjects;
{
    OCArray *retStream = [OCArray arrayWithStream:_stream];
    [_stream release];
    _stream = nil;
    return retStream;
}

@end
