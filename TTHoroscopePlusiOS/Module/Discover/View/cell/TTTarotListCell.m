//
//  XYTarotListCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotListCell.h"

@interface TTTarotListCell ()

@property (nonatomic, weak) UIImageView *iconImgV;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *contentL;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *btmLineView;

@end

@implementation TTTarotListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *baseView = [self createCellViewTitleStr:nil imageStr:nil content:nil];
    [self.contentView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.btmLineView];
    [self.btmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.offset(0.5*KHEIGHT);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}
- (void)topline{
    [self.contentView addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.offset(0.5*KHEIGHT);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setDicModel:(NSDictionary *)dicModel{
    _dicModel = dicModel;
    
    
   UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"%@_",dicModel[@"image"]]];
    
    [self.iconImgV setImage:image];
    self.titleLabel.text = dicModel[@"title"];
    self.contentL.text = dicModel[@"content"];
}

- (UIView *)createCellViewTitleStr:(NSString *)titleStr imageStr:(NSString *)imageStr content:(NSString *)content{
    UIView *baseView = [[UIView alloc]init];
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 5;
    //baseView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    UIImageView *iconImgV = [[UIImageView alloc]init];
    self.iconImgV = iconImgV;
    [baseView addSubview:iconImgV];
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baseView);
        make.left.equalTo(baseView).offset(20);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:15*KWIDTH];
    titleLabel.textColor = [UIColor blackColor];
    [baseView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView);
        make.left.equalTo(iconImgV.mas_right).offset(20*KWIDTH);
        //        make.right.lessThanOrEqualTo(baseView).offset(25*KWIDTH);
    }];
    
    UILabel *contentL = [[UILabel alloc]init];
    self.contentL = contentL;
//    contentL.text = content;
    contentL.font = kFontTitle_L_11;//[UIFont systemFontOfSize:11*KWIDTH];
    contentL.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    contentL.numberOfLines = 0;
    [baseView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5*KWIDTH);
        make.left.equalTo(titleLabel);
        make.right.lessThanOrEqualTo(baseView).offset(-25*KWIDTH);
        make.bottom.equalTo(baseView);
    }];
    
    return baseView;
}

- (void)setIsShowTopline:(BOOL)isShowTopline{
    _isShowTopline = isShowTopline;
    if (isShowTopline) {
        [self topline];
    }
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [UIView new];
        _topLineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    return _topLineView;
    
}

- (UIView *)btmLineView{
    if (!_btmLineView) {
        _btmLineView = [UIView new];
        _btmLineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    return _btmLineView;
}

@end
