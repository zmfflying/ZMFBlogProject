//
//  MFMemoryLeakView.m
//  ZMFBlogProject

#import "MFMemoryLeakView.h"

@implementation MFMemoryLeakView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //创建个图片视图
        [self createImageView];
    }
    return self;
}

#pragma mark - 创建ui
- (void)createImageView {
    _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImage *image = [UIImage imageNamed:@"MemoryLeakTip.jpeg"];
    _imageV.image = image;
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageV];
}
@end
