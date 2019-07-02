//
//  MFMemoryLeakViewController.m
//  ZMFBlogProject

#import "MFMemoryLeakViewController.h"
#import "MFMemoryLeakView.h"
#import "MFTarget.h"
#import "MFTimer.h"
#import "MFMemoryLeakObject.h"
#import <WebKit/WebKit.h>

typedef void (^BlockType)(void);

@interface MFMemoryLeakViewController ()<MFMemoryLeakViewDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) id observer;
@property (nonatomic, assign) NSInteger timerCount;
@property (nonatomic, copy) BlockType block;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
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
//    MFMemoryLeakView *view = [[MFMemoryLeakView alloc] initWithFrame:self.view.bounds];
//    UIImage *newImage = [self coreGraphicsMemoryLeak];
//    if (newImage) {
//        view.imageV.image = newImage;
//    }
    
    // 3.CoreFoundation框架里申请的内存忘记释放
//    NSString *uuid = [self coreFoundationMemoryLeak];
//    NSLog(@"uuid = %@",uuid);
    
    
    // 4.NSTimer未释放
//    self.timerCount = 5;
//    [self timerMemoryLeak];
    
    // 5.通知造成的内存泄漏
//    [self notiMemoryLeak];
    
    // 6.KVO造成的内存泄漏
//    [self kvoMemoryLeak];
    
    // 7.block造成的内存泄漏
//    [self blockMemoryLeak];
    
    // 8.NSThread造成的内存泄漏
//    [self threadMemoryLeak];
    
    // 9.webview造成的内存泄漏
    [self webviewMemoryLeak];
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

#pragma mark - 5.通知造成的内存泄漏
- (void)notiMemoryLeak {
    
    // 5.1 ios9以后一般的通知不再需要手动移除
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiAction) name:@"notiMemoryLeak" object:nil];
    
    // 5.2 block方式监听的通知需要进行移除
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"notiMemoryLeak" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"11111");
    }];
    //发个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notiMemoryLeak" object:nil];
    
}

- (void)notiAction {
    NSLog(@"11111");
}

#pragma mark - 6.KVO造成的内存泄漏
- (void)kvoMemoryLeak {
    //6.1 现在一般的使用kvo，就算不移除观察者，也不会有问题了
//    MFMemoryLeakView *view = [[MFMemoryLeakView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
//    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//    //调用这两句主动激发kvo  具体的原理会有后期的kvo详解中解释
//    [view willChangeValueForKey:@"frame"];
//    [view didChangeValueForKey:@"frame"];
    
    //6.2 在MFMemoryLeakView监听一个单例对象
    MFMemoryLeakView *view = [[MFMemoryLeakView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    [MFMemoryLeakObject sharedInstance].title = @"2";

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
        [MFMemoryLeakObject sharedInstance].title = @"3";
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        NSLog(@"view = %@",object);
    }
}

#pragma mark - 7.block 造成的内存泄漏
- (void)blockMemoryLeak {
    // 7.1 正常block循环引用
//    __weak typeof(self) weakSelf = self;
//    self.block = ^(){
//        //建议加一下强引用，避免weakSelf被释放掉
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        NSLog(@"MFMemoryLeakViewController = %@",strongSelf);
//        NSLog(@"MFMemoryLeakViewController = %zd",strongSelf->_timerCount);
//    };
//    self.block();
    
    // 7.2 NSTimer使用block创建的时候，要注意循环引用
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"MFMemoryLeakViewController = %@",weakSelf);
    }];
    
}

#pragma mark - 8.NSThread 造成的内存泄漏
- (void)threadMemoryLeak {
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun) object:nil];
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }];
    [thread start];
    
}

- (void)threadRun {
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

#pragma mark - 9.webview 造成的内存泄漏
- (void)webviewMemoryLeak {
    // 9.1 UIWebView
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    webView.backgroundColor = [UIColor whiteColor];
//    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [webView loadRequest:requset];
//    [self.view addSubview:webView];
//    self.webView = webView;
    
    // 9.2 WKWebView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"WKWebViewHandler"];
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _wkWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_wkWebView];
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [_wkWebView loadRequest:requset];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"WKWebViewHandler"];
}


- (void)dealloc {
//    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
//    [_webView loadRequest:requset];
    [_timer invalidate];
//    [[NSNotificationCenter defaultCenter] removeObserver:self.observer name:@"notiMemoryLeak" object:nil];
    NSLog(@"hi,我MFMemoryLeakViewController dealloc 了啊");
}

@end
