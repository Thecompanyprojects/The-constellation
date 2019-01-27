//
//  XYCompResultViewController.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/30.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCompResultViewController.h"
#import "TTCompRingView.h"
#import "XYCompResultCardView.h"
#import "TTCompResultViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface TTCompResultViewController ()<UIScrollViewDelegate, XYRequestToastProtocol>

@property (nonatomic, strong)UIScrollView* scrollView;

@property (nonatomic, strong)TTCompRingView* leftRingView;
@property (nonatomic, strong)TTCompRingView* rightRingView;

@property (nonatomic, assign)BOOL leftGender;
@property (nonatomic, assign)BOOL rightGender;
@property (nonatomic, strong)TTZodiacItemModel* leftModel;
@property (nonatomic, strong)TTZodiacItemModel* rightModel;
@property (nonatomic, strong)TTCompResultViewModel* viewModel;

@property (nonatomic, strong)UIImageView* topImageView;
@property (nonatomic, strong) XYAdObject *interstitialAdObj; /**< 插屏广告对象 */
@end

@implementation TTCompResultViewController

#pragma mark -

- (void)requestDidSuccessShowToast:(BOOL)showToast{
    [TTLoadingHUD dismiss];
}

- (void)requestDidStartShowToast:(BOOL)showToast{
    if (showToast) {
        [TTLoadingHUD show];
    }
}

- (void)requestDidFailWithErrorInfo:(NSString *)info showToast:(BOOL)showToast{
    [TTLoadingHUD dismiss];
    if (showToast) {
        [SVProgressHUD showErrorWithStatus:info?info:@""];
    }
}

- (void)dealloc{

    if ([TTPaymentManager shareInstance].isVip) {
        return;
    }
    
    XYAdObject *interstitialAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_match_interstitial showScene:show_scene_match_interstitial];
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


#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.navigationController.navigationBar.alpha = 1 - (scrollView.contentOffset.y / 60 > 1 ? 1 : scrollView.contentOffset.y / 60);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.alpha = 1 - (_scrollView.contentOffset.y / 60 > 1 ? 1 : _scrollView.contentOffset.y / 60);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.alpha = 1;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Compatibility";

    CGFloat originY = isIPhoneX?88:64;
    
    UIView *backImageView = [UIView new];
    [self.view addSubview:backImageView];
    backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    
    self.topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形3"]];
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(originY+10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.topImageView.mas_width).multipliedBy(134.0/355.0);
    }];
    
    self.leftRingView = [[TTCompRingView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5-70-41, originY + 30, 70, 70+13*KHEIGHT+32.8)];
    self.leftRingView.isFemale = self.leftGender;
    
//    self.leftRingView.isDisabled = YES;
    self.leftRingView.genderImageView.userInteractionEnabled = NO;
    [self.view addSubview:self.leftRingView];
    
    self.leftRingView.ringColor = [UIColor whiteColor];
    
    self.rightRingView = [[TTCompRingView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5+41, originY+30, 70, 70+13*KHEIGHT+32.8)];
    self.rightRingView.isFemale = self.rightGender;
//    self.rightRingView.isDisabled = YES;
    self.rightRingView.genderImageView.userInteractionEnabled = NO;
    [self.view addSubview:self.rightRingView];
    
    self.rightRingView.ringColor = [UIColor whiteColor];
    
    self.leftRingView.imageView.image = [UIImage imageNamed:self.leftModel.titleImageName];
    self.leftRingView.nameLb.text = self.leftModel.zodiacName;
    self.leftRingView.dateLb.text = self.leftModel.dateString;
    
    self.rightRingView.imageView.image = [UIImage imageNamed:self.rightModel.titleImageName];
    self.rightRingView.nameLb.text = self.rightModel.zodiacName;
    self.rightRingView.dateLb.text = self.rightModel.dateString;
    

    UIImageView* plusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5-11.5, originY+30+35-11.5, 23, 23)];
    plusImageView.image = [UIImage imageNamed:@"图标 配对 加号"];
    [self.view addSubview:plusImageView];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.leftRingView.frame)+ 15, KScreenWidth,self.view.xy_height-CGRectGetMaxY(self.leftRingView.frame) - 15);
    [self.view addSubview:self.scrollView];
    
    
    TTCompResultViewModel* viewModel = [[TTCompResultViewModel alloc]initWithZodiacIndex_1:[self.leftModel.zodiacIndex integerValue] zodiacIndex_2:[self.rightModel.zodiacIndex integerValue] delegate:self];
    self.viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(self.viewModel, models) subscribeNext:^(id next){
        @strongify(self);
        [self addCardViewWithArray:next];
    }];
    
    // 导航栏白背景
    UIView *navigationBgView = [UIView new];
    navigationBgView.backgroundColor = [UIColor whiteColor];
    navigationBgView.frame = CGRectMake(0, 0, KScreenWidth, kNavBarHeight);
    [self.view addSubview:navigationBgView];
    [self.view bringSubviewToFront:navigationBgView];
    
}

- (void)addCardViewWithArray:(NSArray <XYCompResultModel *>*)arr{
    for (UIView* view in self.scrollView.subviews) {
        if ([view isKindOfClass:[XYCompResultCardView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat y = 10;
    
    for (int i = 0; i < arr.count; i++) {
        XYCompResultModel* model = arr[i];
        XYCompResultCardView* cardView = [[XYCompResultCardView alloc]initWithFrame:CGRectMake(0, y, KScreenWidth, 100)];
        cardView.titleLb.text = model.title;
        cardView.subTitleLb.text = model.subTitle;
        [self.scrollView addSubview:cardView];
        [cardView.progressView setProgress:model.matchPercent.floatValue animated:YES];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        
        NSDictionary* attributeDict = @{NSFontAttributeName:cardView.contentLb.font, NSParagraphStyleAttributeName:paragraphStyle};
        
        cardView.contentLb.attributedText = [[NSAttributedString alloc]initWithString:model.content attributes:attributeDict];
        CGFloat messageLableHeight = [cardView.contentLb.text boundingRectWithSize:CGSizeMake(KScreenWidth-58, MAXFLOAT)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:attributeDict
                                                                           context:nil].size.height;
        cardView.xy_height = 80+20+messageLableHeight;
        
        y += cardView.xy_height;
        if (i == arr.count - 1) {
            self.scrollView.contentSize = CGSizeMake(KScreenWidth, y+20);
        }
    }
}

- (instancetype)initWithLeftGender:(BOOL)isFemale_left rightGender:(BOOL)isFemale_right leftZodiac:(TTZodiacItemModel *)leftModel rightZodiac:(TTZodiacItemModel *)rightModel{
    self = [super init];
    self.leftGender = isFemale_left;
    self.rightGender = isFemale_right;
    self.leftModel = leftModel;
    self.rightModel = rightModel;
    return self;
}
@end
