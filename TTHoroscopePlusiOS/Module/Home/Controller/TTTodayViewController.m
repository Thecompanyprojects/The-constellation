//
//  XYTodayViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTodayViewController.h"
#import "TTodayView.h"
#import "TTForecastViewController.h"
#import "TTCharacteristicVC.h"
#import "TTWebViewController.h"
#import "TTHtmlTableViewController.h"
#import "TTTarotListVC.h"
#import "TTTabBarController.h"
#import "TTDiscoverViewController.h"
#import "TTVipPaymentController.h"
#import "TTPalmistryVC.h"
#import "TTPalmReadingVC.h"
#import "TTAdHelpr.h"


@interface TTTodayViewController ()<XYTodayViewDelegate,XYManagertodayDelegate,GADRewardBasedVideoAdDelegate>

@property (nonatomic, weak) TTodayView *todayView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isReward; /**< 看过奖励视频了 */
@property (nonatomic, assign) XYShowAdAds showAdAds; //通知过来记录是明天 周 月 年类型

@property (nonatomic, assign) BOOL rewardBasedVideoIsHomeCell; //区别是第一个cell还是每日名言cell
@end

@implementation TTTodayViewController

- (instancetype)initWithType:(NSInteger)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}


- (void)statusBarHeightChanged:(NSNotification *)notification{
    [super statusBarHeightChanged:notification];
    NSDictionary* dict = notification.userInfo;
    NSValue* newStatusBarRectValue = [dict objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    if (newStatusBarRectValue == nil) {
        return;
    }
    if (isIPhoneX) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.todayView.xy_height = KScreenHeight-NAV_HEIGHT-44-TABBAR_HEIGHT - ([newStatusBarRectValue CGRectValue].size.height - 20);
    }];
}


- (void)clickHomeCellVideoBtn:(NSNotification *)notification{
    
    NSNumber *a = notification.userInfo[@"videoType"];
    
     XYShowAdAds addss = a.integerValue;
    self.showAdAds = addss;
    if((addss == XYShowAdAdsHomeForTomorrow && [self.model.tabTitle isEqualToString:@"Tomorrow"]) ||
        (addss == XYShowAdAdsHomeForWeek && [self.model.tabTitle isEqualToString:@"Week"]) ||
        (addss == XYShowAdAdsHomeForMonth && [self.model.tabTitle isEqualToString:@"Month"]) ||
       (addss == XYShowAdAdsHomeForYear && [self.model.tabTitle isEqualToString:@"Year"])){
        
    }else{
        return;
    }
  
    
    if ([GADRewardBasedVideoAd sharedInstance].isReady) {
        [GADRewardBasedVideoAd sharedInstance].delegate = self;
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
        return;
    }
    
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [SVProgressHUD show];
    [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_button_reward scene:request_scene_reward];
    self.rewardBasedVideoIsHomeCell = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentSuccees:) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentFail:) name:PAYMENT_FAIL_NOTIFICATION object:nil];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickHomeCellVideoBtn:) name:NotifiClickHomeCellVideoBtn object:nil];
    
    [TTManager sharedInstance].todayDelegate = self;
    [self setupUI];
    
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if(!isVip){
            [[XYAdBaseManager sharedInstance]loadAdWithKey:ios_horoscope_plus_check_news_back_interstitial scene:request_scene_look_news_interstitial];
        }
    }];
}

- (void)setupUI{
    
    CGFloat height = KScreenHeight-kNavBarHeight-44-TABBAR_HEIGHT;
    
    TTodayView *todayView = [[TTodayView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, height) type:_type];
    todayView.delegate = self;
    self.todayView = todayView;
    [self.view addSubview:todayView];
}

- (void)todayViewDidClickModel:(TTBaseModel *)model{
    if (model.cardType.integerValue == 8){
         [TTAdHelpr recordTheNumberOfTodyPsychicTip];
        [TTAdHelpr getTitleForType:XYShowAdAdsTodyPsychicTip WithComplete:^(XYResultType btnType) {
            switch (btnType) {
                case XYResultTypeNotShowBtn:
                    break;
                case XYResultTypeShowPlayVideoBtn:{
                    
                    NSLog(@"展示激励视频");
                    self.showAdAds = XYShowAdAdsTodyPsychicTip;
                    if ([GADRewardBasedVideoAd sharedInstance].isReady) {
                        [GADRewardBasedVideoAd sharedInstance].delegate = self;
                        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
                        return;
                    }
                    
                    [GADRewardBasedVideoAd sharedInstance].delegate = self;
                    [SVProgressHUD show];
                    [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_button_reward scene:request_scene_reward];
                    self.rewardBasedVideoIsHomeCell = NO;
                }break;
                case XYResultTypeShowPayBtn:
                    [self todayViewDidClickPayVipCardWithModel:model];
                    break;
            }
        }];

    }else if (model.cardType.integerValue == 500001){
        NSString *key_1 = @"unknown";
        if ([self.model.tabTitle isEqualToString:@"Today"]) {
            key_1 = @"horoscope_today";
        } else if ([self.model.tabTitle isEqualToString:@"Tomorrow"]) {
            key_1 = @"horoscope_tomorrow";
        }
        [[XYLogManager shareManager] addLogKey1:key_1 key2:@"palm" content:nil userInfo:nil upload:YES];
        // 看手相
        TTPalmReadingVC * vc = [TTPalmReadingVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (void)todayViewDidClickPayVipCardWithModel:(TTBaseModel *)model{
    
    /****/
    NSString *key_1 = @"unknown";
    if ([self.model.tabTitle isEqualToString:@"Today"]) {
        key_1 = @"horoscope_today";
    } else if ([self.model.tabTitle isEqualToString:@"Tomorrow"]) {
        key_1 = @"horoscope_tomorrow";
    } else if ([self.model.tabTitle isEqualToString:@"Week"]) {
        key_1 = @"horoscope_week";
    } else if ([self.model.tabTitle isEqualToString:@"Month"]) {
        key_1 = @"horoscope_month";
    } else if ([self.model.tabTitle isEqualToString:@"Year"]) {
        key_1 = @"horoscope_year";
    }
    [[XYLogManager shareManager] addLogKey1:key_1 key2:@"premium" content:nil userInfo:nil upload:YES];
    
    [TTManager sharedInstance].paySource = key_1;
    
    TTVipPaymentController *puVC = [TTVipPaymentController new];
    puVC.isFullScreen = YES;
    puVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:puVC animated:YES];
}

- (void)todayViewDidClickMoreBtnWithModel:(TTHoroscopeModel *)model{
    TTForecastViewController *vc = [[TTForecastViewController alloc]initWithType:0 model:model];
    vc.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    /****/
    if ([self.model.tabTitle isEqualToString:@"Today"]) {
        [[XYLogManager shareManager] addLogKey1:@"horoscope_today" key2:@"more" content:nil userInfo:nil upload:YES];
    }
}

- (void)todayPushWebViewWithModel:(TTNewsModel *)model{
    if (model.cardType.integerValue == 300001) {

        [[XYLogManager shareManager] addLogKey1:@"horoscope_today" key2:@"tarot" content:nil userInfo:nil upload:YES];
        TTTarotListVC *VC = [[TTTarotListVC alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    /****/
    if ([self.model.tabTitle isEqualToString:@"Today"]) {
        [[XYLogManager shareManager] addLogKey1:@"horoscope_today" key2:@"news" content:nil userInfo:nil upload:YES];
    } else if ([self.model.tabTitle isEqualToString:@"Tomorrow"]) {
        [[XYLogManager shareManager] addLogKey1:@"horoscope_tomorrow" key2:@"news" content:nil userInfo:nil upload:YES];
    }
    
    

    TTHtmlTableViewController* vc = [[TTHtmlTableViewController alloc]initWithModel:model];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setModel:(XYDayModel *)model{
    _model = model;
    self.todayView.model = model;
}

- (void)managerMacthDidClickWithType:(NSInteger)type{
    
    NSString *key_2 = @"none";
    if (type == 0) {
        key_2 = @"love";
    }else if (type == 1){
        key_2 = @"friendship";
    }else if (type == 2){
        key_2 = @"career";
    }
    
    [[XYLogManager shareManager] addLogKey1:@"horoscope_today" key2:key_2 content:nil userInfo:nil upload:YES];
    
    
    TTCharacteristicVC *vc=  [[TTCharacteristicVC alloc]initWithBestMacthType:type];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)notNetworkNotification:(NSNotification *)notification{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setReloadViewHidden:NO];
    
}

- (void)observerPaymentSuccees:(NSNotification *)notification{
    [self.todayView dayViewRefreshVipStatus];
}

- (void)observerPaymentFail:(NSNotification *)notification{
}




#pragma mark - GADRewardBasedVideoAdDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"^^^^^^^^:激励视频广告:完成奖励");
    
    self.isReward = YES;
    if(self.rewardBasedVideoIsHomeCell){
        [TTAdHelpr saveTodayWatchedVideo:self.showAdAds];
        [self.todayView dayViewRefreshVipStatus];
    }else{
        [TTAdHelpr saveTodayWatchedVideo:self.showAdAds];
         [self.todayView dayViewRefreshVipStatus];
    }
    
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"reward",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"^^^^^^^^:激励视频广告:加载成功");
    [SVProgressHUD dismiss];
    [rewardBasedVideoAd presentFromRootViewController:self];
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"loaded",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"^^^^^^^^:激励视频广告加载失败:%@",error.localizedDescription);
    [SVProgressHUD dismiss];
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"video ad load failed!", nil)];
    
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"failed",@"type":@"reward", @"code":@(error.code), @"message":error.localizedDescription} userInfo:nil upload:NO];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
    
}


- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:关闭");
    
    if (!self.isReward) {
        [SVProgressHUD showInfoWithStatus:@"sorry, you shut down the ad video without receiving a reward"];
        return;
    }
    
    [GADRewardBasedVideoAd sharedInstance].delegate = nil;
    [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_button_reward scene:request_scene_reward];
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"close",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:打开");
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"open",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:播放");
}


- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:播放完成");
}


- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:消除");
}



- (void)dealloc{

}

@end
