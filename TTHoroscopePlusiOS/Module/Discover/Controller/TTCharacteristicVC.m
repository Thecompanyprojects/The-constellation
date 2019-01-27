//
//  XYCharacteristicVC.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCharacteristicVC.h"
#import "TTCharacteristicView.h"
#import "TTHoroscopeModel.h"
#import "TTBaseNavigationController.h"
@interface TTCharacteristicVC ()

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, assign) NSInteger bestMacthType;

@property (nonatomic, strong) XYAdObject *interstitialAdObj; /**< 插屏广告对象 */

@end

@implementation TTCharacteristicVC

- (instancetype)initWithBestMacthType:(NSInteger)bestMacthtype{
    self = [self init];
    if (self) {
        _bestMacthType = bestMacthtype;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _bestMacthType = -1;
    }
    return self;
}
- (void)dealloc{
    
    [[XYLogManager shareManager] uploadAllLog];
    
    if ([TTPaymentManager shareInstance].isVip) {
        return;
    }
    
    if ([[TTAdManager sharedInstance] isShouldShowInterstitialAd]) { // 判断是否应该弹出广告
        XYAdObject *interstitialAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_discover_interstitial showScene:show_scene_discover_interstitial];
        self.interstitialAdObj = interstitialAdObj;
        [interstitialAdObj interstitialAdBlock:^(XYAdPlatform adPlatform, FBInterstitialAd *fbInterstitial, GADInterstitial *gadInterstitial, BOOL isClick, BOOL isLoadSuccess) {
            if (isLoadSuccess) {
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TTBaseNavigationController *nav = (TTBaseNavigationController *)self.navigationController;
    [nav navBlackTitleSet];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* type;
    switch (self.bestMacthType) {
        case 0:
            type = @"Love";
            break;
        case 1:
            type = @"FriendShip";
            break;
        case 2:
            type = @"career";
            break;
        default:
            type = @"none";
            break;
    }
    
    
    [self loadData];
    [self setupUI];
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = self.dataArr.count;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:0.8];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [self.view addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker* make){
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-0.15*KScreenHeight+40+30);
            make.height.mas_equalTo(40);
        }];
        
    }
    return _pageControl;
}

- (void)setupUI{
    __weak typeof(self) weakself = self;
    self.title = @"Characteristic";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    TTCharacteristicView *charaterView = [[TTCharacteristicView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:charaterView];
    charaterView.dataArray = self.dataArr;
    
    charaterView.pageChanged = ^(NSInteger page){
        weakself.pageControl.currentPage = page;
    };
    charaterView.bestMacthType = self.bestMacthType;
    [self pageControl];
}

- (void)loadData{
    NSArray *arr = [TTManager sharedInstance].characterArr;
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        TTHoroscopeModel *model = [TTHoroscopeModel new];
        if (self.bestMacthType != (-1)) {
            model.cardType = @(3);
        }
        [model setValuesForKeysWithDictionary:dic];
        [muArr addObject:model];
    }
    self.dataArr = muArr;
}

- (void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
