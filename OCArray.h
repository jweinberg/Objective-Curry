//
//  OCArray.h
//  Objective-Curry
//
//  Created by Josh Weinberg on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class OCStream;

@interface OCArray : NSArray {
    OCStream * _stream;
    OCStream * _cachedReadStream;
    NSUInteger _cachedOffset;
}

+ (id)arrayWithStream:(OCStream*)aStream;
- (id)initWithStream:(OCStream*)aStream;

- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;
- (NSArray *)subarrayWithRange:(NSRange)range;
- (NSEnumerator *)objectEnumerator;
@end
