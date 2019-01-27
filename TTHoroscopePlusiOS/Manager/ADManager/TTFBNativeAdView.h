//
//  HomeAdView.h
//  NbtCollage
//
//  Created by KevinXu on 2018/6/15.
//  Copyright © 2018年 nbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@interface TTFBNativeAdView : UIView

@property (weak, nonatomic) IBOutlet FBMediaView *adMediaView;
@property (weak, nonatomic) IBOutlet FBAdChoicesView *adChoicesView;
@property (weak, nonatomic) IBOutlet FBAdIconView *adIconView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *adActionButton;

// 广告延迟加载时进行赋值显示广告
@property (nonatomic, strong) FBNativeAd *nativeAd;

+ (instancetype)nativeAdViewWithNativeAD:(FBNativeAd *)nativeAd inController:(UIViewController *)controller;

@end
