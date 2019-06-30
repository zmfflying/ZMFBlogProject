//
//  MFRootViewController.m
//  ZMFBlogProject

#import "MFRootViewController.h"
#import "MFMemoryLeakViewController.h"
#import "MFRootTableViewCell.h"

#define cellId @"MFRootTableViewCell" //cell复用id

@interface MFRootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"主页";
    //初始化数据
    [self initDataArr];
    //创建tableView
    [self createTableView];
}

#pragma mark - 数据相关
- (void)initDataArr {
    _dataArr = [NSMutableArray array];
    //内存泄漏
    [_dataArr addObject:@"内存泄漏"];
}

#pragma mark - tableview相关
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MFRootTableViewCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MFRootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *title = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
    cell.title = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MFMemoryLeakViewController *memoryVC = [[MFMemoryLeakViewController alloc] init];
        [self.navigationController pushViewController:memoryVC animated:YES];
    }
}


@end
