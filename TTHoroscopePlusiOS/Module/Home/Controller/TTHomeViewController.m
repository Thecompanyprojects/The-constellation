//
//  XYHomeViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/23.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHomeViewController.h"
#import "TTHomePageView.h"
#import "TTNewZodiacSelectController.h"
#import "TTBaseNavigationController.h"
#import "SGPageContentView.h"
#import "SGPageTitleView.h"
#import "SGPageTitleViewConfigure.h"
#import "TTTodayViewController.h"
#import "TTDiscoverViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ViewDeck/ViewDeck.h>
#import "TTForecastViewController.h"
#import "TTManager.h"
#import "TTAdHelpr.h"
#import "TTVipPaymentController.h"
#import "XYHomeBootPageView.h"
#define ShrinkSize 0.9

@interface TTHomeViewController () <SGPageTitleViewDelegate, XYManagertodayDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* rightButton;
@property (nonatomic, strong) XYAdObject *interstitialAdObj;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer* panGesture;


@property (nonatomic, assign) NSInteger oldOriginalIndex;//记录之前的滑动
@property (nonatomic, assign) NSInteger oldTargetIndex;


@end

@implementation TTHomeViewController

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - XYManagerDelegate
- (void)zodiacDidChange:(TTZodiacItemModel *)model{
    NSLog(@"%@",model.zodiacName);
    //  [NSString stringWithFormat:@"%@ ",[XYManager sharedInstance].localDataManager.zodiacSignModels[b_int-1].zodiacName]
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:model.zodiacName attributes:@{NSFontAttributeName:kFontTitle_M_17,NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attr appendAttributedString:[TTBaseTools addImageWithString:@"图标 头 选星座 黑" x:0 y:0 width:16 height:10]];
    self.titleLabel.attributedText = attr;
    [self.titleLabel sizeToFit];
}

#pragma mark -

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [XYHomeBootPageView getView];

    if(self.tabBarController.tabBar.isHidden){
        [self.tabBarController.tabBar setHidden:NO];        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TTBaseNavigationController *nav = (TTBaseNavigationController *)self.navigationController;
    [nav navBlackTitleSet];
    
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            self.rightButton = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(rightButtonAction)  forControlEvents:UIControlEventTouchUpInside];
                [button setImage:[UIImage imageNamed:@"huangguan"] forState:UIControlStateNormal];
                button;
            });
            
            UIBarButtonItem *restore = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
            self.navigationItem.rightBarButtonItem = restore;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }];
}

- (void)rightButtonAction{
    self.tabBarController.selectedIndex = 2;
    
    if (self.tabBarController.childViewControllers.count < 3){
        TTVipPaymentController *vc = [[TTVipPaymentController alloc]init];
        vc.isFullScreen = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if(!isVip){
            [[XYAdBaseManager sharedInstance]loadAdWithKey:ios_horoscope_plus_select_date_interstitial scene:request_scene_select_date_interstitial];
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewSelectorFromBg:) name:ENTER_FOREGROUND_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewSelector) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYLogManager shareManager]uploadAllLog];
    });    
        
    TTZodiacItemModel *model = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].zodiacManager.zodiacIndex-1];
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:model.zodiacName attributes:@{NSFontAttributeName:kFontTitle_L_17,NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attr appendAttributedString:[TTBaseTools addImageWithString:@"图标 头 选星座 黑" x:0 y:0 width:16 height:10]];
    self.titleLabel.attributedText = attr;
    [self.titleLabel sizeToFit];
    
    [TTManager sharedInstance].homeDelegate = self;
    [TTManager sharedInstance].homeVC = self;
    [[TTManager sharedInstance]initializeData];
    
    
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if(!isVip && [TTAdHelpr isNeedPushPayment]){
            NSLog(@"需要弹出订阅-----------")
            TTVipPaymentController *vc = [TTVipPaymentController new];
            vc.isFullScreen = YES;
            vc.hidesBottomBarWhenPushed = YES;
            vc.isFullScreen = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentZodiacSelectionController)]];
        self.navigationItem.titleView = _titleLabel;
    }return _titleLabel;
}

- (void)setupUI{
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    //    configure.indicatorAdditionalWidth = 10;
    configure.indicatorFixedWidth = 30*KWIDTH;
    configure.titleColor = [UIColor colorWithHex:0x666666];//未选中颜色
    configure.titleFont = kFontTitle_L_14;//[UIFont systemFontOfSize:14];
    configure.titleSelectedColor = [UIColor blackColor]; //选中title
    configure.indicatorColor = [UIColor blackColor]; //选中底部条
    configure.indicatorScrollStyle = SGIndicatorScrollStyleDefault;
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.bottomSeparatorColor = [UIColor whiteColor];
    CGFloat offsetX = 5;
    if(KScreenWidth == 375){
        offsetX = 3;
    }else if(KScreenWidth == 414){
        offsetX = 4;
    }
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(offsetX, kNavBarHeight, self.view.frame.size.width, 44) delegate:self titleNames:[TTManager sharedInstance].titleArr configure:configure];
    _pageTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageTitleView];
    
    CGFloat stantardScale = ShrinkSize;
    CGFloat originWidth = KScreenWidth;
    CGFloat originHeight = self.pageContentView.frame.size.height;
    CGFloat height = originHeight*stantardScale;
    CGFloat width = originWidth*stantardScale;
    CGRect originFrame = CGRectMake(0.5*(originWidth-width), 0.5*(originHeight-height), width, height);
    
    NSMutableArray *VCMuArr = [NSMutableArray array];
    TTTodayViewController* vc1 = [[TTTodayViewController alloc]initWithType:0];
    vc1.view.frame = originFrame;
    vc1.model = [TTManager sharedInstance].todayModel;
    [VCMuArr addObject:vc1];
    
    TTTodayViewController* vc2 = [[TTTodayViewController alloc]initWithType:1];
    vc2.view.frame = originFrame;
    vc2.model = [TTManager sharedInstance].tomorrowModel;
    [VCMuArr addObject:vc2];
    
    TTTodayViewController* vc3 = [[TTTodayViewController alloc]initWithType:1];
    vc3.view.frame = originFrame;
    vc3.model = [TTManager sharedInstance].weekModel;
    [VCMuArr addObject:vc3];
    
    TTTodayViewController* vc4 = [[TTTodayViewController alloc]initWithType:1];
    vc4.view.frame = originFrame;
    vc4.model = [TTManager sharedInstance].monthModel;
    [VCMuArr addObject:vc4];
    
    TTTodayViewController* vc5 = [[TTTodayViewController alloc]initWithType:1];
    vc5.view.frame = originFrame;
    vc5.model = [TTManager sharedInstance].yearModel;
    [VCMuArr addObject:vc5];
    
    //    for (int i=0; i<[XYManager sharedInstance].titleArr.count-1; i++) {
    //        XYForecastViewController *vc = [[XYForecastViewController alloc]initWithType:1];
    //        vc.view.frame = originFrame;
    //        [VCMuArr addObject:vc];
    //    }
    
    CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:VCMuArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:self.pageContentView];
    self.panGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(additionalGesutre:)];
    self.panGesture.edges = UIRectEdgeLeft;
    self.panGesture.delegate = self;
    [self.pageContentView.collectionView addGestureRecognizer:self.panGesture];
}

- (void)additionalGesutre:(UIGestureRecognizer *)ges{
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan: {
            [self.tabBarController.viewDeckController beginTransitionGesture:ges otherView:self.view];
        } break;
        case UIGestureRecognizerStateChanged: {
            [self.tabBarController.viewDeckController updateTransitionGesture:ges otherView:self.view];
        } break;
        case UIGestureRecognizerStateCancelled: {
            [self.tabBarController.viewDeckController endTransition:ges otherView:self.view];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.tabBarController.viewDeckController endTransition:ges otherView:self.view];
        } break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
            break;
    }
    
}

- (void)presentZodiacSelectionController {
    
    [[XYLogManager shareManager] addLogKey1:@"home" key2:@"showZodiacSelection" content:nil userInfo:nil upload:NO];
    
    TTNewZodiacSelectController* zodiacSelection = [[TTNewZodiacSelectController alloc]init];
    TTBaseNavigationController* nav = [[TTBaseNavigationController alloc]initWithRootViewController:zodiacSelection];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - SGPageViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    
    if(progress != 1){return;};
    
    if(originalIndex == self.oldOriginalIndex && targetIndex == self.oldTargetIndex){
        return;
    }else{
        self.oldOriginalIndex = originalIndex;
        self.oldTargetIndex = targetIndex;
    }
    
    if(targetIndex < originalIndex){
        return;
    }
    
    NSString *show_scene = @"";
    if(targetIndex == 1){
        show_scene = show_scene_select_date_interstitial_today_to_tomorrow;
    }else if(targetIndex == 2){
        show_scene = show_scene_select_date_interstitial_tomorrow_to_week;
    }else if(targetIndex == 3){
        show_scene = show_scene_select_date_interstitial_week_to_month;
    }else if(targetIndex == 4){
        show_scene = show_scene_select_date_interstitial_month_to_year;
    }
    
        self.interstitialAdObj =  [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_plus_select_date_interstitial showScene:show_scene];
        
        [self.interstitialAdObj interstitialAdBlock:^(XYAdPlatform adPlatform, FBInterstitialAd *fbInterstitial, GADInterstitial *gadInterstitial, BOOL isClick, BOOL isLoadSuccess) {
            if ([TTPaymentManager shareInstance].isVip){
                
            }else if (isLoadSuccess) {
                if (adPlatform == XYFacebookAdPlatform) {
                    [fbInterstitial showAdFromRootViewController:self];
                    [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdInterstitialType placementId:fbInterstitial.placementID upload:NO];
                } else if (adPlatform == XYAdMobPlatform) {
                    [gadInterstitial presentFromRootViewController:self];
                    [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdInterstitialType placementId:gadInterstitial.adUnitID upload:NO];
                }
            }
        }];
        [[XYAdBaseManager sharedInstance]loadAdWithKey:ios_horoscope_plus_select_date_interstitial scene:request_scene_select_date_interstitial];
}

- (void)pageContentView:(SGPageContentView *)pageContentView offsetX:(CGFloat)offsetX{
    self.panGesture.enabled = offsetX == 0;
}

- (void)refreshHomeData{
    for (UIView *view in self.view.subviews) {
        if (view.tag != bgImgVTag) {
            [view removeFromSuperview];
        }
    }
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    [self setupUI];
}

- (void)managerMacthDidClickWithType:(NSInteger)type {
    
}

- (void)observerNotNetworkNotification:(NSNotification *)notification{
    [self setReloadViewHidden:NO];
}

- (void)observerLoadSuccessNotification:(NSNotification *)notification{
    // [self setReloadViewHidden:YES];
}

- (void)setReloadViewHidden:(BOOL)hidden{
    if (hidden) {
        
    }else{
        for (UIView *view in self.view.subviews) {
            if (view.tag != bgImgVTag) {
                [view removeFromSuperview];
            }
        }
        for (UIViewController *vc in self.childViewControllers) {
            [vc removeFromParentViewController];
        }
    }
    [super setReloadViewHidden:hidden];
}


#pragma mark - 后台进入前台进行数据刷新
- (void)reloadViewSelectorFromBg:(NSNotification *)notification {
    // 时间间隔判断
    NSNumber *time_intervel = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"][@"refresh_time_interval"];
    if (!time_intervel) {
        time_intervel = @(10);// 默认30分钟
    }
    
    // 获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *current_time_str = [formatter stringFromDate:[NSDate date]];
    
    // 获取进入后台的时间
    NSString *time_enter_bg = [[NSUserDefaults standardUserDefaults] stringForKey:@"kAppEnterBackgroundTimeKey"];
    if (!time_enter_bg) {
        time_enter_bg = current_time_str;
    }
    
    if (current_time_str.integerValue > time_enter_bg.integerValue + time_intervel.integerValue) {
        [self reloadViewSelector];
    }
}

#pragma mark -
- (void)reloadViewSelector {
    [super reloadViewSelector];
    [[TTManager sharedInstance] loadHomeData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
