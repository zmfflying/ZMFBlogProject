//
//  MFMemoryLeakView.h
//  ZMFBlogProject

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MFMemoryLeakViewDelegate <NSObject>

@end

@interface MFMemoryLeakView : UIView

@property (nonatomic, strong) UIImageView *imageV;
//代理的关键字不能为 strong
@property (nonatomic, weak) id<MFMemoryLeakViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

