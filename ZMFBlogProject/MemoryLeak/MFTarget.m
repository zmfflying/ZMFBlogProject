//
//  MFTarget.m
//  ZMFBlogProject

#import "MFTarget.h"

@implementation MFTarget

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)target:(id)target {
    return [[MFTarget alloc] initWithTarget:target];
}

//这里将selector 转发给_target 去响应
- (id)forwardingTargetForSelector:(SEL)selector {
    if ([_target respondsToSelector:selector]) {
        return _target;
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end
