//
//  MFTimer.m
//  ZMFBlogProject

#import "MFTimer.h"

@interface MFTimer ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation MFTimer

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    MFTimer *mfTimer = [[MFTimer alloc] init];
    mfTimer.timer = [NSTimer timerWithTimeInterval:ti target:mfTimer selector:@selector(timerAction:) userInfo:userInfo repeats:yesOrNo];
    mfTimer.target = aTarget;
    mfTimer.selector = aSelector;
    return mfTimer.timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    MFTimer *mfTimer = [[MFTimer alloc] init];
    mfTimer.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:mfTimer selector:@selector(timerAction:) userInfo:userInfo repeats:yesOrNo];
    mfTimer.target = aTarget;
    mfTimer.selector = aSelector;
    return mfTimer.timer;
}

- (void)timerAction:(NSTimer *)timer {
    if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //不判断是否响应,是为了不实现定时器的方法就报错
        [self.target performSelector:self.selector withObject:timer];
#pragma clang diagnostic pop
    }else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
