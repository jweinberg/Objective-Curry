//
//  test.cpp
//  Objective-Curry
//
//  Created by Josh Weinberg on 6/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include "test.h"
#include <tr1/memory>

/* Full specialization for zero argument */
template <typename T>
int count() 
{
    return 1;
};
