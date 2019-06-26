//
//  MFMemoryLeakViewController.m
//  ZMFBlogProject

#import "MFMemoryLeakViewController.h"
#import "MFMemoryLeakView.h"
#import "MFTarget.h"
#import "MFTimer.h"

@interface MFMemoryLeakViewController ()<MFMemoryLeakViewDelegate>
@property (nonatomic, assign) NSInteger timerCount;
@end

@implementation MFMemoryLeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"内存泄漏";
    
    //ARC下的内存泄漏 主要是下面几种场景
    // 1.代理关键字造成的内存泄漏
//    MFMemoryLeakView *view = [[MFMemoryLeakView alloc] initWithFrame:self.view.bounds];
//    view.delegate = self;
//    [self.view addSubview:view];
    
    // 2.CoreGraphics框架里申请的内存忘记释放
//    UIImage *newImage = [self coreGraphicsMemoryLeak];
//    if (newImage) {
//        view.imageV.image = newImage;
//    }
    
    // 3.CoreFoundation框架里申请的内存忘记释放
//    NSString *uuid = [self coreFoundationMemoryLeak];
//    NSLog(@"uuid = %@",uuid);
    
    
    // 4.NSTimer未释放
    self.timerCount = 5;
    [self timerMemoryLeak];
    
}

#pragma mark - 2.CoreGraphics框架
- (UIImage *)coreGraphicsMemoryLeak{
    CGRect myImageRect = self.view.bounds;
    CGImageRef imageRef = [UIImage imageNamed:@"MemoryLeakTip.jpeg"].CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(myImageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
//    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 3.CoreFoundation框架
- (NSString *)coreFoundationMemoryLeak{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
//    NSString *uuid = (__bridge NSString *)uuid_string_ref;
    NSString *uuid = (__bridge_transfer NSString *)uuid_string_ref;
    CFRelease(uuid_ref);
//    CFRelease(uuid_string_ref);
    return uuid;
}

#pragma mark - 4.NSTimer
- (void)timerMemoryLeak{
    // 4.1 NSTimer重复设置为NO 不会内存泄漏
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    
    // 4.2 NSTimer重复设置为YES 有执行invalidate就不会内存泄漏 没有执行invalidate就会内存泄漏
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    // 4.3 不执行invalidate 中间target 控制器可以释放
//    [NSTimer scheduledTimerWithTimeInterval:1 target:[MFTarget target:self] selector:@selector(timerActionOtherTarget:) userInfo:nil repeats:YES];
    
    // 4.4 自定义NSTimer 控制器可以释放 外部不用执行invalidate
    [MFTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionOtherTarget:) userInfo:@{@"title":@"1111"} repeats:YES];
    
    // 4.5 使用block创建NSTimer 需要正确使用block 要执行invalidate
    
}

- (void)timerAction:(NSTimer *)timer{
    NSLog(@"11111");
    _timerCount --;
    if (_timerCount == 0) {
        [timer invalidate];
    }
}

- (void)timerActionOtherTarget:(NSTimer *)timer{
    NSLog(@"11111%@",timer.userInfo);
}


- (void)dealloc {
    NSLog(@"hi,我 dealloc 了啊");
}

@end
