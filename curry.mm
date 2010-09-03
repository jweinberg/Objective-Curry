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

#import "curry.h"
#define CURRY(A, ...) return [[^(id A) { __VA_ARGS__ } copy] autorelease];

IDBlock2 curry(c2 block)
{
    CURRY(A, CURRY(B, block(A,B);));
}

IDBlock3 curry(c3 block)
{
    CURRY(A, CURRY(B, CURRY(C, block(A,B,C);)));
}

IDBlock4 curry(c4 block)
{
    CURRY(A, CURRY(B, CURRY(C, CURRY(D, block(A,B,C,D);))));
}    


c2 uncurry(IDBlock2 block)
{
    return [[^(id a, id b)
             {
             return block(a)(b);
             } copy] autorelease];
}


c3 uncurry(IDBlock3 block)  
{
    return [[^(id a, id b, id c)
             {
             return block(a)(b)(c);
             } copy] autorelease];
}

c4 uncurry(IDBlock4 block)
{
    return [[^(id a, id b, id c, id d)
             {
             return block(a)(b)(c)(d);
             } copy] autorelease];
}