//
//  XYNetWorkReloadView.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/2.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTNetWorkReloadView.h"

@implementation TTNetWorkReloadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [UIImageView new];
    self.label = [UILabel new];
    self.subLabel = [UILabel new];
    self.reloadButton = [UIButton new];
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    [self addSubview:self.subLabel];
    [self addSubview:self.reloadButton];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.font = kFontTitle_L_17;//[UIFont systemFontOfSize:17];
    self.label.text = @"Network Error!";
    
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    self.subLabel.numberOfLines = 0;
    self.subLabel.font = kFontTitle_L_14;//[UIFont systemFontOfSize:14];
    self.subLabel.textColor = [UIColor blackColor];
    self.subLabel.text = @"The Internet connection appears to be offline.";
    
    self.imageView.image = [[UIImage imageNamed:@"weilianwang"] imageWithTintColor:[UIColor blackColor] blendMode:kCGBlendModeOverlay];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.reloadButton.layer.cornerRadius = 5;
    self.reloadButton.layer.masksToBounds = true;
//    self.reloadButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self.reloadButton setBackgroundImage:[UIImage imageNamed:@"bt_fangxing"] forState:UIControlStateNormal];
    [self.reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    self.reloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(100*KHEIGHT);
        make.width.mas_equalTo(230*KWIDTH);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker* make){
        make.bottom.mas_equalTo(self.subLabel.mas_top).with.offset(-20);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.mas_centerX).offset(30*KHEIGHT);
        make.bottom.mas_equalTo(self.label.mas_top).with.offset(-40*KHEIGHT);
//        make.width.height.equalTo(@(100*KWIDTH));
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.mas_centerX);
    make.top.mas_equalTo(self.subLabel.mas_bottom).with.offset(40*KHEIGHT);
        make.width.mas_equalTo(KScreenWidth-92);
        make.height.mas_equalTo(61);
    }];
    [self.reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)reload{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadViewSelector)]) {
        [self.delegate reloadViewSelector];
    }
}

@end
