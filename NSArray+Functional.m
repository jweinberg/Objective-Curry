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

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

- (NSArray*)filter:(id(^)(id))block;
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (id item in self)
    {
        if ([block(item) boolValue])
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

- (BOOL)forall:(id(^)(id))block;
{
    for (id item in self)
    {
        if (![block(item) boolValue])
            return NO;
    }
    return YES;
}
@end
