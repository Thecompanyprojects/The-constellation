//
//  XYDiscoverViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//


#import "TTHoroscopePlusiOS-Swift.h"

#import "TTDiscoverViewController.h"
#import "TTCharacteristicVC.h"
#import "TTCompatibilityViewController.h"
#import "TTFortuneViewController.h"
#import "TTTarotListVC.h"
#import "TTTabBarController.h"
#import "TTFBNativeAdView.h"
#import "TTBaseNavigationController.h"
#import "TTPalmistryVC.h"

#import "TTPaymentManager.h"

#define margin 20.0
#define space 15.0
#define itemW ((KScreenWidth-margin*2-space*2)/3-0.01)

//@class XYTabBarController;

@interface TTDiscoverViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XYAdObjectDelegate,XYCircleMenuDelegate>


@property (nonatomic, strong) XYCircleMenu *bottomView;
@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UIButton  *rightButton;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) TTFBNativeAdView *adView;
@property (nonatomic, strong) GADBannerView *gadBanner;

@property (nonatomic, strong) UIView *adContentView;

@end

@implementation TTDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCustom;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewSelector) name:ENTER_FOREGROUND_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentSuccees) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    
    self.index = [TTManager sharedInstance].zodiacManager.zodiacIndex;
    
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            [self loadFBNativeAd];
            
            // 预置请求
//            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_benefactor_banner scene:request_scene_benefactor_pre_banner];
//            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_lucky_color_banner scene:request_scene_lucky_color_pre_banner];
//            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_lucky_number_banner scene:request_scene_lucky_number_pre_banner];
             [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_chirognomy_interstitial scene:request_scene_plam_once_interstitial];
        }
    }];
    
     [self setupUI];
//
//    self.rightButton = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button addTarget:self action:@selector(rightButtonAction)  forControlEvents:UIControlEventTouchUpInside];
//        [button setImage:[UIImage imageNamed:@"huangguan"] forState:UIControlStateNormal];
//        button;
//    });
    
//    UIBarButtonItem *restore = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
//    self.navigationItem.rightBarButtonItem = restore;
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    
}

- (void)rightButtonAction{
    self.tabBarController.selectedIndex = 2;
    self.tabBarController.tabBar.hidden = NO;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.view insertSubview:self.bottomView atIndex:0];
    
    [self.view addSubview:self.bottomView];
    [self.view insertSubview:self.closeBtn aboveSubview:self.bottomView];

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    
    [self.bottomView beginAnimate];
  
}

- (void)circleMenuClickBtnWithIndex:(NSInteger)index{
    /****/
    
    NSDictionary *dic = self.titleArr[index];
    NSString *key_2 = dic[@"title"];
    key_2 = [key_2 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [[XYLogManager shareManager] addLogKey1:@"discover" key2:key_2.lowercaseString content:nil userInfo:nil upload:YES];
    
    if (index == 1) {
        TTCharacteristicVC *VC = [[TTCharacteristicVC alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 0){
        TTCompatibilityViewController* comp = [TTCompatibilityViewController new];
        comp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:comp animated:YES];
    }else if(index == 2){
        [self pushToTarotListVC];
    }else if(index == 3){
        TTPalmistryVC* comp = [TTPalmistryVC new];
        comp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:comp animated:YES];
    }
}

- (void)loadData{
    [self addLoadingViewToSelf];
    
    self.closeBtn.hidden = YES;
    self.bottomView.hidden = YES;
    self.adContentView.hidden = YES;
    

    [[TTManager sharedInstance]loadLuckyDataComplete:^(BOOL isSuccess) {
        [self removeLoadingView];
        if (isSuccess) {
            self.index = [TTManager sharedInstance].zodiacManager.zodiacIndex;
            [self setReloadViewHidden:YES];
        }else{
            [self setReloadViewHidden:NO];
        }
    }];
}

#pragma mark - 购买成功的通知
- (void)observerPaymentSuccees {
    [TTAdHelpr payVip];
    [self.adContentView removeFromSuperview];
    self.adContentView = nil;
}

#pragma mark loadAd
- (void)loadFBNativeAd {
    
    XYAdObject *discoverNativeAdObj = [[TTAdManager sharedInstance] adObjectWithKey:ios_horoscope_discover_native];
    if (!discoverNativeAdObj) {
        [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_discover_native scene:request_scene_discover_native];
        discoverNativeAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_discover_native showScene:show_scene_discover_native];
    }

    discoverNativeAdObj.delegate = self;
    [discoverNativeAdObj nativeAdBlock:^(XYAdPlatform adPlatform, FBNativeAd *fbNative, GADBannerView *gadBanner, BOOL isClick, BOOL isLoadSuccess) {
        if (isLoadSuccess) {
            [[TTAdManager sharedInstance] saveAdObject:discoverNativeAdObj adKey:ios_horoscope_discover_native];
            self.adContentView.hidden = NO;
            if (adPlatform == XYFacebookAdPlatform) {
                if (self.adView) {
                    self.adView.nativeAd = fbNative;
                } else {
                    TTFBNativeAdView *adView = [TTFBNativeAdView nativeAdViewWithNativeAD:fbNative inController:self];
                    adView.backgroundColor = [UIColor clearColor];
                    self.adView = adView;
                    [self.adContentView addSubview:adView];
                    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
                    }];
                }
                [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdNativeType placementId:fbNative.placementID upload:NO];
            } else if (adPlatform == XYAdMobPlatform) {
                self.gadBanner = gadBanner;
                gadBanner.rootViewController = self;
                gadBanner.adSize = GADAdSizeFromCGSize(CGSizeMake(KScreenWidth-margin*2 - 20, (KScreenWidth-margin*2)* 0.75 - 20));
                gadBanner.frame = CGRectMake(10, 10, KScreenWidth-margin*2 - 20, (KScreenWidth-margin*2)* 0.75 - 20);
                gadBanner.layer.cornerRadius = 5;
                gadBanner.layer.masksToBounds = YES;
                gadBanner.userInteractionEnabled = isClick;
                [self.adContentView addSubview:gadBanner];
                
                
                [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdNativeType placementId:gadBanner.adUnitID upload:NO];
            }
            self.adContentView.userInteractionEnabled = isClick;
        }
    }];
    
}

#pragma mark - XYAdObjectDelegate
- (void)adObjectDidClick:(XYAdObject *)adObject {
    [[TTAdManager sharedInstance] deleteAdObjectWithKey:ios_horoscope_discover_native];
    [self loadFBNativeAd];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = YES;
    
    TTBaseNavigationController *nav = (TTBaseNavigationController *)self.navigationController;
    [nav navWhiteTitleSet];
    
    // 加载数据
    if (([TTManager sharedInstance].zodiacManager.zodiacIndex != self.index) || (!self.isNotData)) {
        [self loadData];
    }
    
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            // 预加载插屏广告
            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_discover_interstitial scene:request_scene_discover_interstitial];
        } else {
            if (self.adContentView) {                
            [self.adContentView removeFromSuperview];
            self.adContentView = nil;
            }
        }
    }];
    
}


- (void)setupUI{

    self.backgroundImage = [UIImage new];
    self.backgroundImageCoverView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.tag = bgImgVTag;
    effectView.frame = kWindow.bounds;
    [self.view addSubview:effectView];
    
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [self.view addGestureRecognizer:closeTap];
    
    
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.adContentView];
    
    [self.closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    
    
    [self.adContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KScreenWidth-margin*2);
        make.height.mas_equalTo((KScreenWidth-margin*2)* 0.75);
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-40*KHEIGHT);
        //        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(20);
    }];
}

- (void)clickClose{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ENTER_FOREGROUND_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
        name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)pushToTarotListVC {
    TTTarotListVC *VC = [[TTTarotListVC alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    [TTDataHelper updateRedDot];

    TTTabBarController *tabVC = (TTTabBarController *)self.tabBarController;
    [tabVC.redDotView removeFromSuperview];
}


- (void)setReloadViewHidden:(BOOL)hidden{
    for (UIView *view in self.view.subviews) {
        if (view.tag != bgImgVTag) {
            [view removeFromSuperview];
        }
    }
    [super setReloadViewHidden:hidden];
    
    self.adContentView.hidden = !hidden;
    self.closeBtn.hidden = !hidden;
    self.bottomView.hidden = !hidden;
    
}

- (void)reloadViewSelector{
    [self loadData];
}


//MARK:- lazy
- (UIView *)adContentView {
    if (!_adContentView) {
        _adContentView = [[UIView alloc] init];
        _adContentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _adContentView.layer.cornerRadius = 4;
        _adContentView.layer.masksToBounds = YES;
        _adContentView.hidden = YES;
        _adContentView.tag = bgImgVTag;
    }
    return _adContentView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn){
        _closeBtn = [[UIButton alloc]init];
        _closeBtn.tag = bgImgVTag;
        [_closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
     
    }
    return _closeBtn;
}

- (XYCircleMenu *)bottomView{
    if (!_bottomView){
        _bottomView = [[XYCircleMenu alloc]initWithFrame:CGRectMake(0, KScreenHeight-300, KScreenWidth, 300) imageArr:@[@"pipei_icon",@"jieshao_icon",@"kapai_icon",@"shouxiang_icon"]];
        _bottomView.tag = bgImgVTag;
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[
                      @{@"title":@"Compatibility",@"image":@"图标 发现 配对"},
                      @{@"title":@"Characteristic",@"image":@"图标 发现 特征"},
                      @{@"title":@"Tarot Readings",@"image":@"图标 发现 塔罗牌"},
                      @{@"title":@"Palm",@"image":@"图标 发现 手相"}];
        
    }
    return _titleArr;
}

- (void)dealloc{
   NSLog(@"我已释放")
}

@end
