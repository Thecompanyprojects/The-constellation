//
//  HomeAdView.m
//  NbtCollage
//
//  Created by KevinXu on 2018/6/15.
//  Copyright © 2018年 nbt. All rights reserved.
//

#import "TTFBNativeAdView.h"
#import "UIView+YGNib.h"

@interface TTFBNativeAdView ()
@property (nonatomic, strong) UIViewController *controller;
@end

@implementation TTFBNativeAdView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.adActionButton setBackgroundColor:kHexColor(0x10D699)];
    self.adActionButton.layer.cornerRadius = 4;
    self.adBodyLabel.textColor = kHexColor(0x333333);
    self.adTitleLabel.textColor = kHexColor(0x333333);
}

+ (instancetype)nativeAdViewWithNativeAD:(FBNativeAd *)nativeAd inController:(UIViewController *)controller {
    TTFBNativeAdView *adView = [TTFBNativeAdView yg_loadViewFromNib];
    adView.controller = controller;
    if (nativeAd) {
        [nativeAd registerViewForInteraction:adView mediaView:adView.adMediaView iconView:adView.adIconView viewController:controller];
        adView.adTitleLabel.text = nativeAd.advertiserName;
        adView.adBodyLabel.text = nativeAd.bodyText;
        adView.adChoicesView.nativeAd = nativeAd;
        [adView.adActionButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    }
    return adView;
}

- (void)setNativeAd:(FBNativeAd *)nativeAd {
    _nativeAd = nativeAd;
    self.adTitleLabel.hidden = NO;
    self.adBodyLabel.hidden = NO;
    self.adActionButton.hidden = NO;
    [nativeAd registerViewForInteraction:self mediaView:self.adMediaView iconView:self.adIconView viewController:self.controller];
    self.adTitleLabel.text = nativeAd.advertiserName;
    self.adBodyLabel.text = nativeAd.bodyText;
    self.adChoicesView.nativeAd = nativeAd;
    [self.adActionButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
}


@end
