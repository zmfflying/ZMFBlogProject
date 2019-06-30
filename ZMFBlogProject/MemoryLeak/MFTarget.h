//
//  MFTarget.h
//  ZMFBlogProject

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFTarget : NSProxy

@property (nonatomic, weak) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)target:(id)target;

@end

NS_ASSUME_NONNULL_END
