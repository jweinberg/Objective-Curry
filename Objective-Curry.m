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
#import "NSArray+Functional.h"
#import "OCStream.h"

OCStream * from(int n)
{
    return [OCStream streamWithValue:[NSNumber numberWithInt:n] 
                                 generator:^OCStream*(id generatorBlock, id val)
                                        {
                                            return [OCStream streamWithValue:[NSNumber numberWithInt:[val integerValue] + 1] generator:generatorBlock];
                                        }];
}

OCStream * seive(OCStream * s)
{
    return [[[OCStream alloc] initWithValue:[s head] 
                                  generator:^OCStream*(id generatorBlock, id val)
             {
                 return seive([[s tail] filter:^(id arg1)
                                                {
                                                    return [NSNumber numberWithBool:([arg1 integerValue] % [val integerValue]) != 0];
                                                }]);                 
             }] autorelease];
}


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        
    OCStream * stream = seive(from(2));
    [stream generate:100 performBlock:^(id arg1) {NSLog(@"Generated: %@", arg1);}];

    [pool drain];
    return 0;
}
