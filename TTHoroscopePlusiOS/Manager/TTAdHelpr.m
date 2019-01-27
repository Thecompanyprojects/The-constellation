//
//  XYAdHelpr.m
//  Horoscope
//
//  Created by 郭连城 on 2018/11/2.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "TTAdHelpr.h"
#import "TTManager.h"

#import "NSDate+Extension.h"
@implementation TTAdHelpr

/*
 是vip 不显示按钮
 
 曾经开过vip 显示按钮文字为 看激励视频
 
 不是并且没有开过vip
  判断进入次数是否大于云配次数
   》显示为激励视频
  《=  显示为付费按钮
 
首页： 明天 周 月 年 如果今天看过激励视频，则隐藏按钮 显示内容。

 */

+ (void)getTitleForType:(XYShowAdAds)ads WithComplete:(void(^)(XYResultType btnType))complete{
    [self getTitleForType:ads tarotIndex:0 WithComplete:complete];
}


+ (void)getTitleForType:(XYShowAdAds)ads tarotIndex:(int)index WithComplete:(void(^)(XYResultType btnType))complete{
    
    BOOL beforeVip = [[NSUserDefaults standardUserDefaults]objectForKey:@"beforeVip"];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"][@"showPlayVideoCount"];
    
    NSInteger cloudHomeCount = 3; //云配启动天数
    NSInteger cloudPlamCount = 3;
    NSInteger cloudTarotCount = 3;
    NSInteger cloudTodyPsychicTipCount = 3;
    
    if (dict != nil){
        cloudHomeCount = ((NSNumber *)dict[@"home"]).integerValue;
        cloudPlamCount = ((NSNumber *)dict[@"palm"]).integerValue;
        cloudTarotCount = ((NSNumber *)dict[@"tarot"]).integerValue;
        cloudTodyPsychicTipCount = ((NSNumber *)dict[@"todyPsychicTip"]).integerValue;
    }
//    complete(XYResultTypeShowPlayVideoBtn);
//    return ;
    
    [[TTManager sharedInstance] checkVipStatusComplete:^(BOOL isVip) {
        if (isVip){
            complete(XYResultTypeNotShowBtn);
            return ;
        }
        switch (ads) {
            case XYShowAdAdsHomeForTomorrow:
            case XYShowAdAdsHomeForWeek:
            case XYShowAdAdsHomeForMonth:
            case XYShowAdAdsHomeForYear:{
                NSInteger localStartUpCount = [self getNumberOfStarts]; //启动天数
                NSInteger timeLimit = (localStartUpCount + cloudHomeCount * 24 * 60 * 60);
                
                if ([self checkIsWatchedVideo:ads tarotIndex:0]){
                    
                    complete(XYResultTypeNotShowBtn);
                }else if (beforeVip ||(timeLimit < [[NSDate date]timeIntervalSince1970])){
                    
                    complete(XYResultTypeShowPlayVideoBtn);
                }else{
                    complete(XYResultTypeShowPayBtn);
                }
            }break;
                
                
            case XYShowAdAdsPalmReading:{
                NSInteger localPlamReadVcCount = [self getNumberOfPlamReadVc]; //进入手相的次数
                if (beforeVip || (localPlamReadVcCount > cloudPlamCount)){
                    complete(XYResultTypeShowPlayVideoBtn);
                }else{
                    complete(XYResultTypeShowPayBtn);
                }
            }   break;
                
            case XYShowAdAdsTarot:{
                NSInteger localTarotListVcCount = [self getNumberOfTarotListVc]; //进入塔罗牌结果页次数
                if([self checkIsWatchedVideo:ads tarotIndex:index]){
                    complete(XYResultTypeNotShowBtn);
                }else if (beforeVip ||(localTarotListVcCount > cloudTarotCount)){
                    complete(XYResultTypeShowPlayVideoBtn);
                }else{
                    complete(XYResultTypeShowPayBtn);
                }
            }   break;
                
            case XYShowAdAdsTodyPsychicTip:{
                NSInteger count = [self getNumberOfTodyPsychicTip];
                
                if([self checkIsWatchedVideo:ads tarotIndex:0]){
                    complete(XYResultTypeNotShowBtn);
                }else if(count > cloudTodyPsychicTipCount){
                    complete(XYResultTypeShowPlayVideoBtn);
                }else{
                    complete(XYResultTypeShowPayBtn);
                }
            }break;
        }
    }];
}



//MARK:- 获取首页当日是佛看过视频


+(BOOL)checkIsWatchedVideo:(XYShowAdAds)type tarotIndex:(NSInteger)index{
    BOOL isTrue = false;
    
  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"todayWatchedVideo"];
    switch (type) {
        case XYShowAdAdsHomeForTomorrow:{
            NSNumber *date = dic[@"tomorrow"];
            isTrue = [[NSDate dateWithTimeIntervalSince1970:date.integerValue] isToday];
            }break;
        case XYShowAdAdsHomeForWeek:{
            NSNumber *date = dic[@"week"];
            isTrue = [[NSDate dateWithTimeIntervalSince1970:date.integerValue] isToday];
        }break;
        case XYShowAdAdsHomeForMonth:{
            NSNumber *date = dic[@"month"];
            isTrue = [[NSDate dateWithTimeIntervalSince1970:date.integerValue] isToday];
        }break;
        case XYShowAdAdsHomeForYear:{
            NSNumber *date = dic[@"year"];
            isTrue = [[NSDate dateWithTimeIntervalSince1970:date.integerValue] isToday];
        }break;
        case XYShowAdAdsTodyPsychicTip:{
            NSNumber *date = dic[@"todyPsychicTip"];
            isTrue = [[NSDate dateWithTimeIntervalSince1970:date.integerValue] isToday];
        }break;
        case XYShowAdAdsTarot:{
            NSString *key = [NSString stringWithFormat:@"tarot%ld",(long)index];
            NSNumber *date = dic[key];
            isTrue = [[NSDate dateWithTimeIntervalSince1970:date.integerValue] isToday];
        }break;
        default: break;
    }
    return isTrue;
}

//MARK:- 看完激励视频后保存看过状态

+(void)saveTodayWatchedVideo:(XYShowAdAds)type tarotIndex:(NSInteger)index{
    if(type == XYShowAdAdsTarot){
        NSTimeInterval timer = [[NSDate date]timeIntervalSince1970];
        
        NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"todayWatchedVideo"] mutableCopy];
        if (dic == nil){
            dic = [NSMutableDictionary dictionary];
        }
        NSString *key = [NSString stringWithFormat:@"tarot%ld",(long)index];
        dic[key] = @(timer);
         [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"todayWatchedVideo"];
    }else{
        [self saveTodayWatchedVideo:type];
    }
}

+(void)saveTodayWatchedVideo:(XYShowAdAds)type{
    NSTimeInterval timer = [[NSDate date]timeIntervalSince1970];
    
    NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"todayWatchedVideo"] mutableCopy];
    if (dic == nil){
        dic = [NSMutableDictionary dictionary];
    }
    switch (type) {
        case XYShowAdAdsHomeForTomorrow:
            
            dic[@"tomorrow"] = @(timer);
            break;
        case XYShowAdAdsHomeForWeek:
            dic[@"week"] = @(timer);
            break;
        case XYShowAdAdsHomeForMonth:
            dic[@"month"] = @(timer);
            break;
        case XYShowAdAdsHomeForYear:
            dic[@"year"] = @(timer);
            break;
        case XYShowAdAdsTodyPsychicTip:
            dic[@"todyPsychicTip"] = @(timer);
            break;
        default: break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"todayWatchedVideo"];
}




//记录点击首页每日名言次数
+ (void)recordTheNumberOfTodyPsychicTip{
    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"recordTheNumberOfTodyPsychicTip"];
    count += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"recordTheNumberOfTodyPsychicTip"];
}

//获取点击首页每日名言次数
+ (NSInteger)getNumberOfTodyPsychicTip{
    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"recordTheNumberOfTodyPsychicTip"];
    return count;
}


//记录进入塔罗牌结果页次数
+ (void)recordTheNumberOfTarotListVc{
    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"recordTheNumberOfTarotListVc"];
    count += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"recordTheNumberOfTarotListVc"];
}

//获取进入塔罗牌结果页次数
+ (NSInteger)getNumberOfTarotListVc{
    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"recordTheNumberOfTarotListVc"];
    return count;
}



//记录进入手相界面次数
+ (void)recordTheNumberOfPlamReadVc{
    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"recordTheNumberOfPlamReadVc"];
    count += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"recordTheNumberOfPlamReadVc"];
}

//获取进入手相界面次数
+ (NSInteger)getNumberOfPlamReadVc{
    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"recordTheNumberOfPlamReadVc"];
    return count;
}


//MARK:- 记录初次安装时间和每天启动次数
+ (void)recordTheNumberOfStarts{
    NSString *firstOfStarts = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstOfStarts"];
    if(firstOfStarts == nil){
        firstOfStarts = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
        [[NSUserDefaults standardUserDefaults] setObject:firstOfStarts forKey:@"firstOfStarts"];
    }
    
    NSMutableDictionary *numberCountDic = ((NSDictionary *)[[NSUserDefaults standardUserDefaults]objectForKey:@"recordTheNumberOfStartsDic"]).mutableCopy;
    if(numberCountDic == nil){
        numberCountDic = [[NSMutableDictionary alloc]init];
    }
    NSDate *date = [NSDate date];
    NSString *nowDayKey = [NSString stringWithFormat:@"%ld%ld%ld",(long)date.year,(long)date.month,(long)date.day];
    
    NSNumber *count = numberCountDic[nowDayKey];
    
    if (count){
        count = @(count.integerValue + 1);
    }else{
        count = @(1);
    }
    [numberCountDic setObject:count forKey:nowDayKey];
    [[NSUserDefaults standardUserDefaults]setObject:numberCountDic forKey:@"recordTheNumberOfStartsDic"];
}


+ (BOOL)isNeedPushPayment{
    NSMutableDictionary *numberCountDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"recordTheNumberOfStartsDic"];
    if(numberCountDic == nil){
        numberCountDic = [NSMutableDictionary dictionary];
    }
    
    NSDate *date = [NSDate date];
    NSString *nowDayKey = [NSString stringWithFormat:@"%ld%ld%ld",(long)date.year,(long)date.month,(long)date.day];
    
    NSNumber *count = numberCountDic[nowDayKey];
    
    
     NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"][@"showPayment"];
    
    NSInteger isNeedPush = 1;
    NSInteger pushCount = 1;
    if(dict){
        isNeedPush = ((NSNumber *)dict[@"isNeedPush"]).integerValue;
        pushCount = ((NSNumber *)dict[@"pushCount"]).integerValue;
    }
    
    if(isNeedPush>0){
        if(pushCount > count.integerValue){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

//MARK:- 获取初次安装时间
+ (NSInteger)getNumberOfStarts{
    NSString *count = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstOfStarts"];
    
    return count.integerValue;
}

+ (void)payVip{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"beforeVip"];
}

@end
