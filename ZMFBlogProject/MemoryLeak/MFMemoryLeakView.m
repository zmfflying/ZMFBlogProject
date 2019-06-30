//
//  MFMemoryLeakView.m
//  ZMFBlogProject

#import "MFMemoryLeakView.h"
#import "MFMemoryLeakObject.h"

@implementation MFMemoryLeakView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //创建个图片视图
        [self createImageView];
        [self viewKvoMemoryLeak];
    }
    return self;
}

#pragma mark - 6.KVO造成的内存泄漏
- (void)viewKvoMemoryLeak {
    [[MFMemoryLeakObject sharedInstance] addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        NSLog(@"[MFMemoryLeakObject sharedInstance].title = %@",[MFMemoryLeakObject sharedInstance].title);
    }
}

#pragma mark - 创建ui
- (void)createImageView {
    _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImage *image = [UIImage imageNamed:@"MemoryLeakTip.jpeg"];
    _imageV.image = image;
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageV];
}

- (void)dealloc {
    [[MFMemoryLeakObject sharedInstance] removeObserver:self forKeyPath:@"title"];
    NSLog(@"hi,我MFMemoryLeakView dealloc 了啊");
}
@end
