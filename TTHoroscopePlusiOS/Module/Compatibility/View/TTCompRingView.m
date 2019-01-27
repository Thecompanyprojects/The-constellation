//
//  XYCompRingView.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCompRingView.h"
#define DISABLED_COLOR [UIColor colorWithWhite:0.6 alpha:0.4]
#define DISABLED_COLOR_BORDER [UIColor colorWithWhite:0.8 alpha:0.4]
@interface TTCompRingView()
@property (nonatomic, strong)UIView* cover;
@property (nonatomic, strong)UIView* imageCover;
@end

@implementation TTCompRingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.ringView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    [self addSubview:self.ringView];
    
    self.imageView = [UIImageView new];
    [self.ringView addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.ringView.mas_centerX);
        make.centerY.mas_equalTo(self.ringView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    self.nameLb = [UILabel new];
    [self addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.mas_equalTo(self.ringView.mas_bottom).offset(8*KHEIGHT);
        make.centerX.mas_equalTo(self);
    }];
    self.nameLb.textColor = [UIColor whiteColor];
    self.nameLb.font = kFontTitle_L_15;//[UIFont systemFontOfSize:15];
    
    self.nameLb.textAlignment = NSTextAlignmentCenter;
    
    self.dateLb = [UILabel new];
    [self addSubview:self.dateLb];
    [self.dateLb mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.mas_equalTo(self.nameLb.mas_bottom).offset(0);
        make.height.mas_equalTo(13);
        make.centerX.mas_equalTo(self);
    }];
    self.dateLb.font = kFontTitle_L_10;//[UIFont systemFontOfSize:10*KWIDTH];
    self.dateLb.textAlignment = NSTextAlignmentCenter;
    self.dateLb.textColor = RGBA(164, 148, 174, 1);
    
    self.genderImageView = [UIImageView new];
    self.genderImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.genderImageView];
    self.genderImageView.userInteractionEnabled = YES;
    CGFloat radius = frame.size.width*0.5;
    CGFloat genderW = 30;
    self.genderImageView.layer.cornerRadius = genderW*0.5;
    self.genderImageView.layer.masksToBounds = YES;
    CGRect frame_gender = CGRectMake(radius+radius/1.414-genderW*0.5, radius+radius/1.414-genderW*0.5, genderW, genderW);
    self.genderImageView.frame = frame_gender;
    [self.genderImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderTapepd)]];
    
    self.ringView.userInteractionEnabled = YES;
    [self.ringView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped)]];
    
    return self;
}

- (void)genderTapepd{
    self.isFemale = !self.isFemale;
}

- (void)imageViewTapped{
    if ([self.delegate respondsToSelector:@selector(tapped_ring:)]) {
        [self.delegate tapped_ring:self];
    }
}

- (void)setRingColor:(UIColor *)ringColor{
    _ringColor = ringColor;
    self.ringView.layer.cornerRadius = self.ringView.xy_height*0.5;
    self.ringView.layer.masksToBounds = YES;
    self.ringView.layer.borderColor = ringColor.CGColor;
    self.ringView.layer.borderWidth = 1;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.ringView.backgroundColor = isSelected?RGBA(170, 170, 170, 0.3):[UIColor clearColor];
}

- (void)setIsFemale:(BOOL)isFemale{
    _isFemale = isFemale;
    self.genderImageView.image = isFemale? [UIImage imageNamed:@"gender_female"]: [UIImage imageNamed:@"gender_male"];
}

- (void)setIsDisabled:(BOOL)isDisabled{
    _isDisabled = isDisabled;
    self.ringView.alpha = isDisabled?0.5:1;
//    self.genderImageView.alpha = isDisabled?0.5:1;
    if (!isDisabled){
        [self.imageCover removeFromSuperview];
//        self.ringView.layer.borderColor = [UIColor whiteColor].CGColor;
        return;
    }
//    self.ringView.layer.borderColor = DISABLED_COLOR_BORDER.CGColor;
    if(self.imageCover.superview == nil){
//        [self.ringView addSubview:self.cover];
        [self.genderImageView addSubview:self.imageCover];
    }else{
//        [self.ringView bringSubviewToFront:self.cover];
        [self.genderImageView bringSubviewToFront:self.imageCover];
    }
}

- (UIView *)cover{
    if(_cover == nil){
        _cover = [[UIView alloc]initWithFrame:self.ringView.bounds];
        _cover.backgroundColor = DISABLED_COLOR;
    }return _cover;
}

- (UIView *)imageCover{
    if(!_imageCover){
        _imageCover = [[UIView alloc]initWithFrame:self.genderImageView.bounds];
        _imageCover.backgroundColor = DISABLED_COLOR;
    }return _imageCover;
}

@end
