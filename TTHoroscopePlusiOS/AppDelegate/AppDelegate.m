//
//  AppDelegate.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "AppDelegate.h"
#import "TTInitViewController.h"
#import "TTAdHelpr.h"
#import "TTPaymentManager.h"
#import "TTRequestTool.h"

#import "TTNewZodiacSelectController.h"
#import "TTBaseNavigationController.h"
#import "TTViewDeckController.h"
#import "TTLeftViewController.h"
#import "TTTabBarController.h"
#import "TTPushManager.h"

#import "TTHoroscopePlusiOS-Swift.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[XYLogManager shareManager] configurationStatisticsUrl:StatisticsLogURL crashUrl:CrashLogURL];
    
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    // 捕获异常
    [[YGCrashHelper sharedInstance] ignoreMethod:@[@"loadProductWithParameters",@"setShowsStoreButton"]];
    [[YGCrashHelper sharedInstance] crashHandle:^(NSString *errorName, NSString *errorReason, NSString *errorLocation, NSArray *stackSymbols, NSException *exception) {
        [[XYLogManager shareManager] addCrashLog:@{@"errorName":errorName, @"errorReason":errorReason, @"errorLocation":errorLocation, @"stackSymbols":stackSymbols} upload:NO];
    }];
    
    
    // 第三方异常上报
    [Bugly startWithAppId:kBuglyApID];
    
    // SVHUD设置
    [self svPreferrenceConf];
    
    // 网络状态监听
    [self AFNReachability];
    
    // 注册远程通知
    [TTPushManager registerForRemoteNotification];
    
    // 广告加载
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            [[XYAdBaseManager sharedInstance] initializeAdconfigDataWithUrl:ios_horoscope_ad_config_url
                                                                     params:@{@"time":[TTAdManager sharedInstance].ad_timeString,
                                                                              @"app_version":[TTAdManager sharedInstance].ad_versionCode,
                                                                              @"country_code":[TTAdManager sharedInstance].ad_countryCode}];
        }
    }];
    
    [TTAdHelpr recordTheNumberOfStarts];
    
    // 上传日志
    [[XYLogManager shareManager] uploadAllLog];
    
    [TTDataHelper saveUUIDToKeyChain];

    [FIRApp configure];
    [FIRDynamicLinks performDiagnosticsWithCompletion:nil];

    // 初始化Window
    [self initWindow];
    
    [[XYDeepLinkTools sharedInstance] aliveLogOptions:launchOptions];
    [[XYDeepLinkTools sharedInstance] deepLinkFacebookSettingUrlBlock:^(NSString * _Nonnull url) {
        [[TTManager sharedInstance] deeplinkPushUrl:url];
    }];
    
    
    [self switchBootProcessNotification];
    return YES;
}


- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    TTInitViewController *vc = [TTInitViewController new];
    self.window.rootViewController = vc;
}

- (void)svPreferrenceConf {
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

//使用AFN框架来检测网络状态的改变
- (void)AFNReachability {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
        [TTManager sharedInstance].networkStatus = status;
    }];
    
    //3.开始监听
    [manager startMonitoring];
}

//接收订阅成功后切换控制器通知
- (void)switchBootProcessNotification{
    [[NSNotificationCenter defaultCenter] addObserverForName:XYNotification.switchRootViewController
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self switchRootViewController];
                                                  }];
}

- (void)switchRootViewController{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    //    4001005678
    if ([TTManager sharedInstance].zodiacManager.showZodiacSelection) { // 选择星座
        TTNewZodiacSelectController *zodiac = [TTNewZodiacSelectController new];
        TTBaseNavigationController* nav = [[TTBaseNavigationController alloc]initWithRootViewController:zodiac];
        window.rootViewController = nav;
    } else { // 主页面
        TTTabBarController *tabVC = [TTTabBarController new];
        TTLeftViewController* left = [TTLeftViewController new];
        left.selectBlock = tabVC.selectBlock_tabbar;
        TTViewDeckController* deck = [[TTViewDeckController alloc]initWithCenterViewController:tabVC leftViewController:left];

        window.rootViewController = deck;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 进入后台的时间,记录到分
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *current_time_str = [formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:current_time_str forKey:@"kAppEnterBackgroundTimeKey"];
    
    [[XYLogManager shareManager] addLogKey1:@"start" key2:@"background_out" content:@{@"net":[NSString getNetWorkStates]} userInfo:nil upload:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:ENTER_FOREGROUND_NOTIFICATION object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[XYLogManager shareManager] addLogKey1:@"start" key2:@"background_enter" content:@{@"net":[NSString getNetWorkStates]} userInfo:nil upload:YES];
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[XYLogManager shareManager] addLogKey1:@"start" key2:@"terminate" content:@{@"net":[NSString getNetWorkStates]} userInfo:nil upload:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [TTPushManager registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//MARK:- iOS10以下，应用在前台的时候，有推送来，会直接来到这个方法。但是通知栏不会有提示，角标也不会有。应用如果在后台或者在关闭状态，点击推送来的消息也会来到这个方法。在这里处理业务逻辑。（静默推送）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    /****/
    [[XYLogManager shareManager] addLogKey1:@"horoscope_notification" key2:@"arrival" content:nil userInfo:nil upload:YES];
    
    [TTPushManager handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    BOOL handled = [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                            completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                                                         NSError * _Nullable error) {
                                                                
                                                            }];
    if (@available(iOS 11.0, *)) {
        [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.referrerURL
                                                 completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                                              NSError * _Nullable error) {
                                                     
                                                 }];
    } else {
        
    }
    return handled;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    
        return [self application:app
                         openURL:url
               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[XYDeepLinkTools sharedInstance]deepLinkGoogleSettingWithUrl:url urlBlock:^(NSString * _Nonnull url) {
        [[TTManager sharedInstance] deeplinkPushUrl:url];
    }];
}


@end
