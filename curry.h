#import <Foundation/Foundation.h>

typedef id(^IDBlock)(id);
typedef IDBlock (^IDBlock2)(id);
typedef IDBlock2 (^IDBlock3)(id);
typedef IDBlock3 (^IDBlock4)(id);

typedef id (^c2)(id,id);
typedef id (^c3)(id,id,id);
typedef id (^c4)(id,id,id,id);

IDBlock2 OC_OVERLOAD curry(c2 block);
IDBlock3 OC_OVERLOAD curry(c3 block);
IDBlock4 OC_OVERLOAD curry(c4 block);

c2 OC_OVERLOAD uncurry(IDBlock2 block);
c3 OC_OVERLOAD uncurry(IDBlock3 block);
c4 OC_OVERLOAD uncurry(IDBlock4 block);