//
//  MFTimer.h
//  ZMFBlogProject

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFTimer : NSObject

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END
