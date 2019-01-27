//
//  XYAdHelpr.h
//  Horoscope
//
//  Created by 郭连城 on 2018/11/2.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//要查看的内容类型
typedef NS_ENUM(NSUInteger, XYShowAdAds) {
    XYShowAdAdsHomeForTomorrow = 1,  //首页
    XYShowAdAdsHomeForWeek,  //首页
    XYShowAdAdsHomeForMonth,  //首页
    XYShowAdAdsHomeForYear,  //首页
    XYShowAdAdsPalmReading,//手相占卜答题查看答案按钮
    XYShowAdAdsTarot,//塔罗牌查看t结果
    XYShowAdAdsTodyPsychicTip, //首页cell每日名言cell
};


typedef NS_ENUM(NSUInteger, XYResultType) {
    XYResultTypeNotShowBtn = 1,  //不显示按钮
    XYResultTypeShowPlayVideoBtn,//显示查看视频按钮
    XYResultTypeShowPayBtn,//展示付费按钮
};


NS_ASSUME_NONNULL_BEGIN



@interface TTAdHelpr : NSObject
///记录程序启动次数
+ (void)recordTheNumberOfStarts;
/// 记录进入手相页面次数
+ (void)recordTheNumberOfPlamReadVc;
///记录进入塔罗牌界面次数
+ (void)recordTheNumberOfTarotListVc;
///今天看过视频后保存
+ (void)saveTodayWatchedVideo:(XYShowAdAds)type;
+ (void)saveTodayWatchedVideo:(XYShowAdAds)type tarotIndex:(NSInteger)index;

///每次点击每日tip，增加次数
+ (void)recordTheNumberOfTodyPsychicTip;

///启动判断进入支付界面
+ (BOOL)isNeedPushPayment;

+ (void)getTitleForType:(XYShowAdAds)ads WithComplete:(void(^)(XYResultType btnType))complete;

+ (void)getTitleForType:(XYShowAdAds)ads tarotIndex:(int)index WithComplete:(void(^)(XYResultType btnType))complete;

+ (void)payVip;
@end

NS_ASSUME_NONNULL_END
