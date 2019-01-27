//
//  XYCompZodiacView.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCompZodiacView.h"

@implementation TTCompZodiacView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.iconImageView = [UIImageView new];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    self.iconImageView.tintColor = RGBA(203, 58, 169, 1);
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.textColor = RGBA(171, 158, 179, 1);
    [self addSubview:self.dateLabel];
    
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview:self.nameLabel];
    
    self.backgroundColor = [UIColor whiteColor];

    self.iconImageView.frame = CGRectMake(0, self.frame.size.height*0.15, self.frame.size.width, self.frame.size.height*0.3);
    self.nameLabel.frame = CGRectMake(0, self.frame.size.height*0.5, self.xy_width, (self.xy_height*0.2)<17?17:(self.xy_height*0.2));
    self.dateLabel.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), self.xy_width, 0.2*self.xy_height);
    self.dateLabel.font = kFontTitle_L_11;//[UIFont systemFontOfSize:11*KWIDTH];
    self.nameLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)]];
    
    return self;
}

- (void)copyConfig{
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.hidden = YES;
    self.dateLabel.hidden = YES;
    
}

- (void)tapped:(UIGestureRecognizer *)reco{
    if (self.tapBlock) {
        __weak typeof(self)weakSelf = self;
        self.tapBlock(weakSelf);
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
//    if (isSelected) {
//        self.dateLabel.textColor = RGBA(203, 58, 169, 1);
//        self.nameLabel.textColor = RGBA(203, 58, 169, 1);
//    }else{
//        self.dateLabel.textColor = RGBA(171, 158, 179, 1);
//        self.nameLabel.textColor = [UIColor whiteColor];
//    }
}

@end
