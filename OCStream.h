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

#import <Foundation/Foundation.h>
#import "curry.h"

@class OCStream;

typedef OCStream* (^GeneratorBlock)(id,id);

@interface OCStreamEnumerator : NSEnumerator
{
@private
    OCStream *_stream;
}

- (id)initWithStream:(OCStream*)aStream;

@end


@interface OCStream : NSObject <NSFastEnumeration> {
@private
    BOOL _dirtyHead;
    BOOL _hasDefiniteLength;
    NSObject * _head;
    GeneratorBlock _nextValue;
}

+ (id)streamWithValue:(id)value generator:(GeneratorBlock)nextValue;
- (id)initWithValue:(id)value generator:(GeneratorBlock)nextValue;
- (id)generate:(int)count performBlock:(void(^)(id))block;

- (NSEnumerator*)enumerator;

- (OCStream*)take:(int)count;
- (OCStream*)drop:(int)count;
- (OCStream*)tail;
- (OCStream*)filter:(id(^)(id))block;

- (id)head;
@end
