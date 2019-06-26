//
//  MFRootTableViewCell.m
//  ZMFBlogProject

#import "MFRootTableViewCell.h"
@interface MFRootTableViewCell ()
@property(nonatomic,strong) UILabel *titleLab;//标题
@end

@implementation MFRootTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化ui界面
- (void)initUI {
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.contentView addSubview:_titleLab];
}

#pragma mark - 接收数据刷新
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = title;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
