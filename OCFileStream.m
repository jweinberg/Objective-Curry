//
//  OCFileStream.m
//  Objective-Curry
//
//  Created by Josh Weinberg on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OCFileStream.h"


OCStream * byteStream(NSFileHandle * file)
{
    NSData * nextChar = [file readDataOfLength:1];
    if ([nextChar length] == 0)
        return nil;
    return [OCStream streamWithValue:[NSNumber numberWithChar:*((char*)[nextChar bytes])]
                           generator:^{return byteStream(file);}];
}

@implementation OCFileStream

+ (id)fileStreamWithFileHandle:(NSFileHandle*)aHandle;
{
    return [[[OCFileStream alloc] initWithFileHandle:aHandle] autorelease];
}

- (id)initWithFileHandle:(NSFileHandle*)aHandle;
{
    if ((self = [super initWithValue:[NSNumber numberWithChar:*((char*)[[aHandle readDataOfLength:1] bytes])] 
                           generator:^{return byteStream(aHandle);}]))
    {
        _file = [aHandle retain];
    }
    return self;
}

- (void)dealloc;
{
    [_file release];
    [super dealloc];
}

@end
