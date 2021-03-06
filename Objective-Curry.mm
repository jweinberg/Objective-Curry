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
#import <Foundation/Foundation.h>
#import "OCStream.h"
#import "OCArray.h"
#import "OCFileStream.h"
#import "curry.h"

OCStream * dictStream()
{
    return [OCStream streamWithValue:[NSMutableDictionary dictionaryWithObject:@"Test" forKey:@"Test"] 
                           generator:^{return dictStream();}];
}

OCStream * from(int n)
{
    return [OCStream streamWithValue:[NSNumber numberWithInt:n] 
                           generator:^{return from(n+1);}];
}

OCStream * seive(OCStream * s)
{
    return [OCStream streamWithValue:[s head] 
                            generator:^
             {
                 return seive([[s tail] filter:^id(id arg1)
                                                {
                                                    return [NSNumber numberWithBool:([arg1 integerValue] % [[s head] integerValue]) != 0];
                                                }]);                 
             }];
}

OCStream * fib(unsigned long long num1, unsigned long long num2)
{
    return [OCStream streamWithValue:[NSNumber numberWithUnsignedLongLong:num1 + num2] 
                           generator:^
                    {
                        return fib(num2, num1 + num2); 
                    }];
}

OCStream * rleDecoder(int count, OCStream * inputStream)
{
    if (count <= 0)
    {
        count = [[inputStream head] charValue];
        inputStream = [inputStream tail];
    }
    
    return [OCStream streamWithValue:[inputStream head]
                           generator:^
            {
                OCStream * tmpStream = inputStream;
                if (count == 1)
                    tmpStream = [tmpStream tail];
                    
                return rleDecoder(count - 1, tmpStream); 
            }];
}

int main (int argc, const char * argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    OCStream * stream = [[[fib(1,1) filter:^id(id arg1) {return [NSNumber numberWithFloat:[arg1 longLongValue] % 2 == 0];}]  map:^(id arg1) {return [NSString stringWithFormat:@"WOO:%@", arg1];}] map:^id(id arg1) {return [arg1 lowercaseString];}];
    
    for (id val in [stream take:5])
    {
        NSLog(@"%@", val);        
    }
    
    NSArray * array = [OCArray arrayWithStream:[dictStream() take:5]];
    
    [array setValue:@"Really?" forKey:@"valueTest"];
    for(NSNumber * num in [from(0) take:100])
        NSLog(@"enumerated: %@", num);
    
    [pool drain];
    return 0;
}
