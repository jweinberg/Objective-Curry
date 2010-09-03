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

#import "OCArray.h"
#import "OCStream.h"

@interface OCArray ()

@property (nonatomic, retain) OCStream * stream;
@property (nonatomic, retain) OCStream * cachedReadStream;
@end


@implementation OCArray

@synthesize stream = _stream;;
@synthesize cachedReadStream = _cachedReadStream;

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
    [_stream release], _stream = nil;
    [_cachedReadStream release], _cachedReadStream = nil;
    [super dealloc];
}

- (void)setStream:(OCStream *)aStream;
{
    if (aStream != _stream)
    {
        self.cachedReadStream = nil;
        _cachedOffset = 0;
        [_stream release];
        _stream = [aStream retain];
    }
}

- (id)objectAtIndex:(NSUInteger)index;
{
    if (_cachedOffset > index)
        self.cachedReadStream = [self.stream drop:index];
    else
        self.cachedReadStream = [self.cachedReadStream drop:index - _cachedOffset];
    
    _cachedOffset = index;
    return [self.cachedReadStream head];
}

- (NSUInteger)count;
{
    return [self.stream length];
}

- (OCArray *)subarrayWithRange:(NSRange)range;
{
    return [OCArray arrayWithStream:[[self.stream drop:range.location] take:range.length]];
}

- (NSEnumerator *)objectEnumerator;
{
    return [self.stream enumerator];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;
{
    return [self.stream countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (OCArray *)filteredArrayUsingPredicate:(NSPredicate *)predicate;
{
    return [OCArray arrayWithStream:[self.stream filter:^(id arg1) {return [NSNumber numberWithBool:[predicate evaluateWithObject:arg1]];}]];
}

- (void)setValue:(id)value forKey:(NSString *)key;
{    
    self.stream = [self.stream map:^(id arg1) {[arg1 setValue:value forKey:key]; return arg1;}];
}

- (OCArray *)valueForKey:(NSString *)key;
{
    return [OCArray arrayWithStream:[self.stream map:^(id arg1) {return [arg1 valueForKey:key];}]];
}

@end
