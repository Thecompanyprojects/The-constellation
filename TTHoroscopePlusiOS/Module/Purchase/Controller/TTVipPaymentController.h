//
//  VipPaymentController.h
//  XToolWhiteNoiseIOS
//
//  Created by KevinXu on 2018/9/6.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTVipPaymentController : TTBaseViewController

@property (nonatomic, assign) BOOL isFullScreen;


////如果是从引导流程跳过来的，为Ture
@property (nonatomic, assign) BOOL isBootProcess;


// 是否是TabBarItem
@property (nonatomic, assign) BOOL isTabBarItem;

@end
