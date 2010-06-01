//
//  NSArray+Functional.h
//  BlocksTest
//
//  Created by Josh Weinberg on 5/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Functional)

- (NSArray*)filter:(int(^)(id))block;
- (NSArray*)map:(id(^)(id))block;
- (id)foldLeft:(id)start withBlock:(id(^)(id,id))block;
- (id)foldRight:(id)start withBlock:(id(^)(id,id))block;
- (id)reduceLeft:(id(^)(id,id))block;
- (id)reduceRight:(id(^)(id,id))block;
- (BOOL)forall:(BOOL(^)(id))block;

@end
