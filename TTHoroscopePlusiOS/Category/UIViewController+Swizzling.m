//
//  UIViewController+Swizzling.m
//  xk100
//
//  Created by xuyaguang on 2017/5/2.
//  Copyright © 2017年 xiaokang. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>



@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self yg_swizzlingInstanceMethod:@selector(viewWillAppear:) withMethod:@selector(swiz_viewWillAppear:)];
        [self yg_swizzlingInstanceMethod:@selector(viewWillDisappear:) withMethod:@selector(swiz_viewWillDisappear:)];
        [self yg_swizzlingInstanceMethod:@selector(viewDidAppear:) withMethod:@selector(swiz_viewDidAppear:)];
    });
}

- (void)swiz_viewWillAppear:(BOOL)animated {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    if(![str containsString:@"UI"] && ![str containsString:@"Navigation"] && ![str containsString:@"TabBar"]){
        
//        [[XYLogManager shareManager] addLogKey1:str.lowercaseString key2:@"enter" content:nil userInfo:nil upload:NO];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
        self.kEnterTimeStamp = [NSString stringWithFormat:@"%.0f", time];
        
    }
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    if(![str containsString:@"UI"] && ![str containsString:@"Navigation"] && ![str containsString:@"TabBar"]){
        
        // 针对一下页面自定义字段,立即上报;其他页面
        NSString *key_1 = str;
        
        // 是否需要统计该界面
        BOOL isLog = YES;
        
        // 需要统计的j页面
        if ([self isMemberOfClass:NSClassFromString(@"TTHomeViewController")] || [self isMemberOfClass:NSClassFromString(@"TTTodayViewController")]) {// 首页
            key_1 = @"home_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTForecastViewController")]) {// 运势详情页
            key_1 = @"forecast_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTCompResultViewController")]) {// 星座匹配结果
            key_1 = @"compatibility_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTTarotListVC")]) {// 塔罗牌列表页
            key_1 = @"tarot_list_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTTarotResultVC")]) {// 塔罗牌结果页
            key_1 = @"tarot_reading_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTVipPaymentController")]) {// 订阅简介页
            key_1 = @"premium_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTHtmlTableViewController")]) {// 新闻详情页
            key_1 = @"article_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTCharacteristicVC")]) {// 描述星座特点详情内容页面
            key_1 = @"characteristic_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTFortuneViewController")]) {// 幸运颜色/幸运数字详情内容页面
            key_1 = @"fortune_view";
        } else if ([self isMemberOfClass:NSClassFromString(@"TTHoroscopePlusiOS.XYPalmReadingResultVC")]) {//手相
            key_1 = @"plam_view";
        } else {
            isLog = NO;
        }
        
        if (isLog) {
            NSTimeInterval outTime = [[NSDate date] timeIntervalSince1970] * 1000;
            NSTimeInterval enterTime = self.kEnterTimeStamp.doubleValue;
            NSString *duration = [NSString stringWithFormat:@"%.0f",outTime - enterTime];
            
            NSLog(@"\n\n-----------用户在->:%@ 停留->:%@毫秒\n\n",str, duration);
            
            if (self.kTagString) {
                [[XYLogManager shareManager] addLogKey1:key_1 key2:@"duration" content:@{@"millisecond":duration, @"type":self.kTagString} userInfo:nil upload:YES];
            } else {
                [[XYLogManager shareManager] addLogKey1:key_1 key2:@"duration" content:@{@"millisecond":duration} userInfo:nil upload:YES];
            }
        }
    }
    [self swiz_viewWillDisappear:animated];
}


- (void)swiz_viewDidAppear:(BOOL)animated {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    if(![str containsString:@"UI"] && ![str containsString:@"Navigation"] && ![str containsString:@"TabBar"]){
        
    }
    [self swiz_viewDidAppear:animated];
}


@end

