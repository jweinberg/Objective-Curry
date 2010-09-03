//
//  OCFileStream.h
//  Objective-Curry
//
//  Created by Josh Weinberg on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OCStream.h"

@interface OCFileStream : OCStream {
    NSFileHandle * _file;
}

+ (id)fileStreamWithFileHandle:(NSFileHandle*)aHandle;
- (id)initWithFileHandle:(NSFileHandle*)aHandle;

@end
