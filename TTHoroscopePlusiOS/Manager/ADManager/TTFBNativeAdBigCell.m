//
//  XTFBNativeAdBigCell.m
//  Horoscope
//
//  Created by KevinXu on 2018/9/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTFBNativeAdBigCell.h"
#import "UIView+Indicator.h"

@interface TTFBNativeAdBigCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) FBMediaView *adMediaView;
@property (nonatomic, strong) FBAdChoicesView *adChoicesView;
@property (nonatomic, strong) FBAdIconView *adIconView;
@property (nonatomic, strong) UILabel *adTitleLabel;
@property (nonatomic, strong) UILabel *adBodyLabel;
@property (nonatomic, strong) UIButton *adActionButton;

@end
@implementation TTFBNativeAdBigCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}



- (void)initSubviews {
    self.bgView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view;
    });
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(TOP_MARGIN);
        make.left.equalTo(self.contentView).offset(LEFT_MARGIN);
        make.right.equalTo(self.contentView).offset(-LEFT_MARGIN);
        make.bottom.equalTo(self.contentView).offset(-TOP_MARGIN);
    }];
    
    self.adView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    [self.bgView addSubview:self.adView];
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10*KWIDTH);
        make.left.equalTo(self.bgView).offset(10*KWIDTH);
        make.right.equalTo(self.bgView).offset(-10*KWIDTH);
        make.bottom.equalTo(self.bgView).offset(-10*KWIDTH);
    }];
    
    self.adMediaView = [[FBMediaView alloc] init];
    [self.adView addSubview:self.adMediaView];
    [self.adMediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView);
        make.right.equalTo(self.adView);
        make.left.equalTo(self.adView);
        make.height.mas_equalTo(self.adMediaView.mas_width).multipliedBy(0.5);
    }];
    
    self.adChoicesView = [[FBAdChoicesView alloc] init];
    [self.adView addSubview:self.adChoicesView];
    [self.adChoicesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.adView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.adIconView = [[FBAdIconView alloc] init];
    [self.adView addSubview:self.adIconView];
    [self.adIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.adMediaView.mas_bottom).offset(10*KWIDTH);
    }];
    
    self.adActionButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:kHexColor(0x10D699)];
        button.titleLabel.font = kFontTitle_L_12;
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button;
    });
    [self.adView addSubview:self.adActionButton];
    [self.adActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80*KWIDTH, 32*KWIDTH));
        make.centerY.mas_equalTo(self.adIconView);
        make.right.mas_equalTo(self.adMediaView);
    }];
    
    self.adBodyLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontTitle_L_11;
        label.textColor = kHexColor(0x333333);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        label;
    });
    [self.adView addSubview:self.adBodyLabel];
    [self.adBodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adIconView.mas_right).offset(8*KWIDTH);
        make.bottom.equalTo(self.adIconView);
        make.right.lessThanOrEqualTo(self.adActionButton.mas_left).offset(-10*KWIDTH);
    }];
    
    self.adTitleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontTitle_L_13;
        label.textColor = kHexColor(0x333333);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        label;
    });
    [self.adView addSubview:self.adTitleLabel];
    [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.adIconView.mas_right).offset(8*KWIDTH);
        make.top.mas_equalTo(self.adIconView);
        make.right.lessThanOrEqualTo(self.adActionButton.mas_left).offset(-10*KWIDTH);
    }];
    
    self.adView.hidden = YES;
}


- (void)setNativeAd:(FBNativeAd *)nativeAd {
    _nativeAd = nativeAd;
    if (nativeAd.isAdValid) {
        self.adView.hidden = NO;
        
        [nativeAd registerViewForInteraction:self.adView mediaView:self.adMediaView iconView:self.adIconView viewController:[UIViewController currentViewController] clickableViews:@[self.adView, self.adActionButton]];
        self.adTitleLabel.text = nativeAd.advertiserName;
        self.adBodyLabel.text = nativeAd.bodyText;
        self.adChoicesView.nativeAd = nativeAd;
        [self.adActionButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    } else {
        
    }
}

- (void)setAdModel:(TTBaseModel *)adModel {
    self.bgView.userInteractionEnabled = adModel.isAdCanClick;
    _adModel = adModel;
    if (adModel.nativeAd) {
        self.nativeAd = adModel.nativeAd;
        return;
    }
    
    if (adModel.gadBanner) {
        self.adView.hidden = YES;
        adModel.gadBanner.layer.cornerRadius = 5;
        adModel.gadBanner.layer.masksToBounds = YES;
        [self.contentView addSubview:adModel.gadBanner];
        [adModel.gadBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(10*KWIDTH);
            make.left.equalTo(self.bgView).offset(10*KWIDTH);
            make.right.equalTo(self.bgView).offset(-10*KWIDTH);
            make.bottom.equalTo(self.bgView).offset(-10*KWIDTH);
        }];
        
    }
}

@end
