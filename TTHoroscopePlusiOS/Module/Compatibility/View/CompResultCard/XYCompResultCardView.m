//
//  XYCompResultCardView.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/1.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "XYCompResultCardView.h"
@implementation XYCompResultCardView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    //14
//    74 = 46 + 14*2
    //
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.container = [UIView new];
    [self addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.bottom.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@0);
        make.bottom.equalTo(@-15);
    }];
    self.container.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.container.layer.cornerRadius = 5;

    
    
    self.progressView = [[UAProgressView alloc]init];
    self.progressView.tintColor = [UIColor blackColor];
    self.progressView.lineWidth = 1;
    self.progressView.borderWidth = 0;
    [self.container addSubview:self.progressView];
    self.progressView.frame = CGRectMake(14, 14, 42*KWIDTH, 42*KWIDTH);
    UILabel* proLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    proLb.textColor = [UIColor blackColor];
    proLb.font = [UIFont boldSystemFontOfSize:14];
    proLb.textAlignment = NSTextAlignmentCenter;
    self.progressView.centralView = proLb;
    
    self.progressView.progressChangedBlock = ^(UAProgressView* progressView, CGFloat progress){
        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    };
    
    UAProgressView* temp = [UAProgressView new];
    temp.frame = self.progressView.frame;
    temp.tintColor = [UIColor colorWithWhite:0 alpha:0.3];
    temp.borderWidth = 0;
    temp.progress = 1;
    [self.container insertSubview:temp belowSubview:self.progressView];
    
    self.titleLb = [UILabel new];
    self.titleLb.textColor = kHexColor(0x333333);//[UIColor blackColor];
    [self.container addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.mas_equalTo(self.progressView.mas_right).with.offset(8);
        make.top.mas_equalTo(self.progressView).with.offset(0);
        make.height.mas_equalTo(self.progressView.mas_height).multipliedBy(0.4);
    }];
    self.titleLb.textAlignment = NSTextAlignmentLeft;
    self.titleLb.font = kFontRegular(14);//[UIFont systemFontOfSize:14];
    
    self.subTitleLb = [UILabel new];
    self.subTitleLb.textColor = kHexColor(0x333333);//[UIColor blackColor];
    [self.container addSubview:self.subTitleLb];
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.mas_equalTo(self.progressView.mas_right).with.offset(8);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.progressView.mas_bottom);
    }];
    
    self.subTitleLb.textAlignment = NSTextAlignmentLeft;
    self.subTitleLb.font = kFontRegular(16);//[UIFont boldSystemFontOfSize:16*KWIDTH];
    
    self.contentLb = [UILabel new];
    self.contentLb.numberOfLines = 0;
    self.contentLb.textColor = kHexColor(0x333333);
    self.contentLb.font = kFontRegular(14);//[UIFont systemFontOfSize:14];
    [self.container addSubview:self.contentLb];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.progressView.mas_left);
        make.right.mas_equalTo(self.container).with.offset(-15);
        make.bottom.mas_equalTo(self.container).with.offset(-10);
        make.top.mas_equalTo(self.progressView.mas_bottom).with.offset(10);
    }];
    
    return self;
}
@end
