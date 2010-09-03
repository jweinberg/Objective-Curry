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

typedef id(^IDBlock)(id);
typedef IDBlock (^IDBlock2)(id);
typedef IDBlock2 (^IDBlock3)(id);
typedef IDBlock3 (^IDBlock4)(id);

typedef id (^c2)(id,id);
typedef id (^c3)(id,id,id);
typedef id (^c4)(id,id,id,id);

IDBlock2 curry(c2 block);
IDBlock3 curry(c3 block);
IDBlock4 curry(c4 block);

c2 uncurry(IDBlock2 block);
c3 uncurry(IDBlock3 block);
c4 uncurry(IDBlock4 block);

template<typename T, typename X, typename Y>
T (^(^curry(T (^block)(X,Y)))(Y))(X)
{
    return [[^(X a){
		return [[^(Y b){
			return block(a,b);
		} copy] autorelease];
    } copy] autorelease];
};

template<typename T, typename X, typename Y, typename Z>
T (^(^(^curry(T (^block)(X,Y,Z)))(Z))(Y))(X)
{
	return [[^(X a){		   
		return [[^(Y b){
			return [[^(Z c){
				return block(a,b,c);
			} copy] autorelease];
		} copy] autorelease];
    } copy] autorelease];
}

template<typename T, typename X, typename Y>
T (^uncurry(T (^(^block)(X))(Y)))(X a, Y b)
{
    return [[^(X a, Y b)
             {
				 return block(a)(b);
             } copy] autorelease];
}


template<typename T, typename X, typename Y, typename Z>
T (^uncurry(T (^(^(^block)(X))(Y))(Z)))(X a, Y b, Z c)
{
    return [[^(X a, Y b, Z c)
             {
				 return block(a)(b)(c);
             } copy] autorelease];
}