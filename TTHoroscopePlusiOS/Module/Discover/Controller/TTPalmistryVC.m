//
//  XYPalmistryVC.m
//  Horoscope
//
//  Created by 郭连城 on 2018/9/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTPalmistryVC.h"
#import <WebKit/WebKit.h>
#import "TTBaseNavigationController.h"
@interface TTPalmistryVC()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webview;

@end

@implementation TTPalmistryVC

//增加kvo监听，获得页面title
- (void)viewDidLoad{
    [super viewDidLoad];
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.webview];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"html" inDirectory:@"xingzuo"];
    NSURL*Url = [NSURL fileURLWithPath:path];
    [self.webview loadRequest:[NSURLRequest requestWithURL:Url]];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self clickPalm];
}

- (void)saveOnceShow{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"palmOnceShow"];
}


- (void)clickPalm{
    
    BOOL needShow = ![[NSUserDefaults standardUserDefaults]boolForKey:@"palmOnceShow"];
    
    if (needShow) { // 判断是否应该弹出广告
        XYAdObject *interstitialAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_plus_chirognomy_interstitial showScene:show_scene_plam_once_interstitial];
        
        [interstitialAdObj interstitialAdBlock:^(XYAdPlatform adPlatform, FBInterstitialAd *fbInterstitial, GADInterstitial *gadInterstitial, BOOL isClick, BOOL isLoadSuccess) {
            if (isLoadSuccess) {
                [self saveOnceShow];
                if (adPlatform == XYFacebookAdPlatform) {
                    [fbInterstitial showAdFromRootViewController:[UIViewController currentViewController]];
                    [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdInterstitialType placementId:fbInterstitial.placementID upload:NO];
                } else if (adPlatform == XYAdMobPlatform) {
                    [gadInterstitial presentFromRootViewController:[UIViewController currentViewController]];
                    [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdInterstitialType placementId:gadInterstitial.adUnitID upload:NO];
                }
            }
        }];
        
    }
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
//        NSLog(@"底部高度为%f",self.view.safeAreaInsets.bottom)
        self.webview.xy_height =  self.webview.xy_height - self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取网页title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.title.length) {
        self.title = title;
    }
    
}
//KVO 一定要移除，要不然会崩溃
//- (void)dealloc{
//    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.webview removeObserver:self forKeyPath:@"title"];
//}

#pragma mark KVO的监听代理
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//
//    //加载进度值
//    if ([keyPath isEqualToString:@"estimatedProgress"]){
//        if (object == self.webview){
////            self.mProgressView.alpha = 1;
////            [self.mProgressView setProgress:self.mWebView.estimatedProgress animated:YES];
////            if(self.webview.estimatedProgress >= 1.0f)
////            {
////                [UIView animateWithDuration:0.5 animations:^{
////                    self.mProgressView.alpha = 0;
////                } completion:^(BOOL finished) {
////                    [self.mProgressView setProgress:0.0f animated:NO];
////                }];
////            }
//        }else{
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }else if ([keyPath isEqualToString:@"title"]){//网页title
//        if (object == self.webview){
//            self.navigationItem.title = self.webview.title;
//        }else{
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

//MARK:- lazy
- (UIWebView *)webview{
    if (!_webview){

        _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-NAV_HEIGHT)];
        _webview.scrollView.bounces = false;
        _webview.delegate = self;
//        _webview.navigationDelegate = self;
    }
    return _webview;
}

@end
