#import "curry.h"

#define CURRY(A, ...) return [[^(id A) { __VA_ARGS__ } copy] autorelease];

IDBlock2 OC_OVERLOAD curry(c2 block)
{
    CURRY(A, CURRY(B, block(A,B);));
}

IDBlock3 OC_OVERLOAD curry(c3 block)
{
    CURRY(A, CURRY(B, CURRY(C, block(A,B,C);)));
}

IDBlock4 OC_OVERLOAD curry(c4 block)
{
    CURRY(A, CURRY(B, CURRY(C, CURRY(D, block(A,B,C,D);))));
}    


c2 OC_OVERLOAD uncurry(IDBlock2 block)
{
    return [[^(id a, id b)
             {
             return block(a)(b);
             } copy] autorelease];
}


c3 OC_OVERLOAD uncurry(IDBlock3 block)
{
    return [[^(id a, id b, id c)
             {
             return block(a)(b)(c);
             } copy] autorelease];
}

c4 OC_OVERLOAD uncurry(IDBlock4 block)
{
    return [[^(id a, id b, id c, id d)
             {
             return block(a)(b)(c)(d);
             } copy] autorelease];
}