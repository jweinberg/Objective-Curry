#import <Foundation/Foundation.h>
#import "curry.h"
#import "NSArray+Functional.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    IDBlock3 appendyThing = curry( ^(NSString* a, NSString* b, NSString* c) { 
        return [a stringByAppendingFormat:@"%@,%@", b, c];
    } );
    
    NSArray * stuff = [NSArray arrayWithObjects:@"This", @"is", @"a", @"stupid", @"test", nil];
    NSLog(@"%@", [stuff reduceLeft:uncurry(appendyThing(@"Wooo!"))]);
    [pool drain];
    return 0;
}
