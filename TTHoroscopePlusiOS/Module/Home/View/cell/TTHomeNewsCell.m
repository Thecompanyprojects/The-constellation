//
//  XYHomeNewsCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHomeNewsCell.h"

@interface TTHomeNewsCell ()
@property (nonatomic, weak) UIImageView *imageViewc;
@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) UILabel *titleL;
@end

@implementation TTHomeNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);//.offset(TOP_MARGIN);
        make.left.equalTo(self.contentView);//.offset(LEFT_MARGIN);
        make.right.equalTo(self.contentView);//.offset(-LEFT_MARGIN);
        make.bottom.equalTo(self.contentView);//.offset(-TOP_MARGIN);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    imageView.clipsToBounds = YES;
    [imageView setImage:[UIImage imageNamed:@"xinwen"]];
    self.imageViewc = imageView;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(10*KHEIGHT);
        make.left.equalTo(view).offset(10*KWIDTH);
        make.bottom.equalTo(view).offset(-10*KWIDTH);
        make.width.offset(150*KWIDTH);
        make.height.offset(100*KWIDTH);
    }];
    
    
    UILabel *titleL = [[UILabel alloc]init];
    self.titleL = titleL;
    titleL.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    titleL.textColor = [UIColor colorWithHex:0x333333];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.numberOfLines = 3;
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10*KWIDTH);
        make.top.equalTo(imageView).offset(5*KWIDTH);
        make.right.lessThanOrEqualTo(self).offset(-10*KWIDTH);
//        make.bottom.equalTo(timeL.mas_top).offset(-10*KWIDTH);
    }];
    
    UILabel *timeL = [[UILabel alloc]init];
    self.timeL = timeL;
    timeL.font = kFontTitle_L_11;//[UIFont systemFontOfSize:11*KWIDTH];
    timeL.numberOfLines = 1;
    timeL.text = @"2018-04-29 02:03:47";
    timeL.textColor = [UIColor grayColor];
    [view addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view).offset(-10*KWIDTH);
        make.left.equalTo(titleL);
//        make.right.lessThanOrEqualTo(imageView.mas_left).offset(-10*KWIDTH);
    }];
}

- (void)setModel:(TTNewsModel *)model{
    _model = model;
    self.timeL.text = model.article_date;
    self.titleL.text = model.title;
    __weak typeof(self) weakself = self;
    [self.imageViewc sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"xinwen"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakself.imageViewc setImage:image];
    }];
}

@end
