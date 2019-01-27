//
//  XYTabBarController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/23.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTabBarController : UITabBarController
@property (nonatomic, strong) UIView *redDotView;
@property (nonatomic, copy) void (^selectBlock_tabbar)(NSDictionary* info);

@property (nonatomic, assign)NSInteger oldSelectIndex;
@end
