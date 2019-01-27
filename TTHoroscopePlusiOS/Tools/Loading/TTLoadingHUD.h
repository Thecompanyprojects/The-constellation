//
//  XYLoadingHUD.h
//  VPN
//
//  Created by PanZhi on 2018/3/8.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLoadingHUD : UIView

+ (void)show;

+ (void)dismiss;

+ (UIView *)CreateLoadingViewWithFrame:(CGRect)frame;
+ (UIView *)CreateTarotLoadingViewWithFrame:(CGRect)frame;

@end
