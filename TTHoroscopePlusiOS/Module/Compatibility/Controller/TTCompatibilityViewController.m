//
//  XYCompatibilityViewController.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCompatibilityViewController.h"
#import "TTCompRingView.h"
#import "TTCompZodiacView.h"
#import "TTCompViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TTCompResultViewController.h"
@interface TTCompatibilityViewController ()<XYCompRingViewDelegate>
@property (nonatomic, strong) TTCompRingView *leftRingView;
@property (nonatomic, strong) TTCompRingView *rightRingView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) TTCompViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray<TTCompZodiacView *> *items;
@property (nonatomic, strong) TTCompZodiacView *selectedZodiacView;
@property (nonatomic, strong) UIButton *checkCompBtn;
@end

@implementation TTCompatibilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Compatibility";
    self.viewModel = [TTCompViewModel new];
    
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    self.backgroundImageCoverView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    CGFloat originY = kNavBarHeight;
    
    self.leftRingView = [[TTCompRingView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5-70-41, originY + 30, 70, 70+13*KHEIGHT+32.8)];
    
    self.topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形3"]];
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(originY+10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.topImageView.mas_width).multipliedBy(134.0/355.0);
    }];
    
    
    self.leftRingView.isFemale = NO;
    self.leftRingView.delegate = self;
    self.leftRingView.isSelected = YES;
    [self.view addSubview:self.leftRingView];
    
    self.leftRingView.ringColor = [UIColor whiteColor];
    
    self.rightRingView = [[TTCompRingView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5+41, originY+30, 70, 70+13*KHEIGHT+32.8)];
    self.rightRingView.isFemale = YES;
    self.rightRingView.isSelected = NO;
    self.rightRingView.delegate = self;
    [self.view addSubview:self.rightRingView];
    
    self.rightRingView.ringColor = [UIColor whiteColor];
    
    CGFloat btnHeight = 60*KHEIGHT;//isIPhoneX?104:(70*KHEIGHT);    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftRingView.frame)+15, KScreenWidth, self.view.xy_height-CGRectGetMaxY(self.leftRingView.frame)-btnHeight - 15)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.scrollView];
    
    UIImageView *plusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5-11.5, originY+30+35-11.5, 23, 23)];
    plusImageView.image = [UIImage imageNamed:@"图标 配对 加号"];
    [self.view addSubview:plusImageView];
    
    self.checkCompBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.xy_height-btnHeight,KScreenWidth ,btnHeight)];
//    [self.checkCompBtn setBackgroundColor:[UIColor colorWithHex:0xBE5099 alpha:0.7]];
    [self.checkCompBtn setBackgroundImage:[UIImage imageNamed:@"bt_fangxing"] forState:UIControlStateNormal];
      [self.checkCompBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [self.checkCompBtn setTitle:@"Check compatibility" forState:UIControlStateNormal];
    [self.checkCompBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkCompBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.view addSubview:self.checkCompBtn];
    [self.checkCompBtn addTarget:self action:@selector(checkCompabitility) forControlEvents:UIControlEventTouchUpInside];
    [self.checkCompBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    self.checkCompBtn.enabled = NO;
    [self layoutItems];
    
    
    // 预加载广告
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_match_interstitial scene:request_scene_match_pre_interstitial];
        }
    }];
    
    
    // 导航栏白背景
    UIView *navigationBgView = [UIView new];
    navigationBgView.backgroundColor = [UIColor whiteColor];
    navigationBgView.frame = CGRectMake(0, 0, KScreenWidth, kNavBarHeight);
    [self.view addSubview:navigationBgView];
    [self.view bringSubviewToFront:navigationBgView];
}

- (void)dealloc{
    [[XYLogManager shareManager] uploadAllLog];
    self.viewModel.leftModel = nil;
    self.viewModel.rightModel = nil;
    self.leftRingView.imageView.image = nil;
    self.leftRingView.nameLb.text = nil;
    self.leftRingView.dateLb.text = nil;
    self.rightRingView.imageView.image = nil;
    self.rightRingView.nameLb.text = nil;
    self.rightRingView.dateLb.text = nil;
    self.leftRingView.isSelected = YES;
    self.rightRingView.isSelected = NO;
    
    if (self.viewModel.leftModel && self.viewModel.rightModel){
        self.checkCompBtn.enabled = YES;
        [self.checkCompBtn setBackgroundColor:[UIColor colorWithHex:0xBE5099]];
    }else{
        self.checkCompBtn.enabled = NO;
        [self.checkCompBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)checkCompabitility{
    
    
    if (self.viewModel.leftModel == nil || self.viewModel.rightModel == nil) {
        return;
    }
    
    [[XYLogManager shareManager] addLogKey1:@"discover" key2:@"check" content:nil userInfo:nil upload:NO];
    
    // 预加载广告
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_match_interstitial scene:request_scene_match_interstitial];
        }
    }];
    
    TTCompResultViewController *res = [[TTCompResultViewController alloc]initWithLeftGender:self.leftRingView.isFemale rightGender:self.rightRingView.isFemale leftZodiac:self.viewModel.leftModel rightZodiac:self.viewModel.rightModel];
    [self.navigationController pushViewController:res animated:YES];
}

- (void)layoutItems{
    NSArray<TTZodiacItemModel *>*models = [TTManager sharedInstance].localDataManager.zodiacSignModels;
    CGFloat gap = 10;
    CGFloat originY = gap;
    CGFloat itemSize = (KScreenWidth - gap*4)/3.0f;
    CGFloat itemHeight = itemSize*0.75;
    for (int i = 0; i < 12; i++) {
        TTCompZodiacView *item = [[TTCompZodiacView alloc]initWithFrame:CGRectMake((itemSize+gap)*(i%3)+gap, originY+i/3*(itemHeight+gap), itemSize , itemHeight)];
        item.index = i;
        __weak typeof(self)weakSelf = self;
        item.tapBlock = ^(TTCompZodiacView *view){
            [weakSelf itemTapped:view];
        };
        item.layer.cornerRadius = 3;
        item.iconImageView.image = [[UIImage imageNamed:models[i].titleImageName] imageWithTintColor:[UIColor blackColor] blendMode:kCGBlendModeOverlay];
        item.dateLabel.text = models[i].dateString;
        item.nameLabel.text = models[i].zodiacName;
        [self.scrollView addSubview:item];
        if (!self.items) {
            self.items = [NSMutableArray new];
        }
        [self.items addObject:item];
        if (i == 11) {
            self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(item.frame)+gap);
        }
    }
}

- (void)itemTapped:(TTCompZodiacView *)item{

    TTZodiacItemModel *model = [TTManager sharedInstance].localDataManager.zodiacSignModels[item.index];
    
    if (item != self.selectedZodiacView) {
        if (self.selectedZodiacView) {
            self.selectedZodiacView.isSelected = NO;
            TTZodiacItemModel *oldModel = [TTManager sharedInstance].localDataManager.zodiacSignModels[self.selectedZodiacView.index];
            self.selectedZodiacView.iconImageView.image = [[UIImage imageNamed:oldModel.titleImageName]  imageWithTintColor:[UIColor blackColor] blendMode:kCGBlendModeOverlay];
  
        }
        self.selectedZodiacView = item;
        item.isSelected = YES;
    }
    
    UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = item.iconImageView.image;
    tempImageView.frame = CGRectMake(self.scrollView.xy_x-self.scrollView.contentOffset.x+item.xy_x+item.xy_width*0.5-item.xy_height*0.15, self.scrollView.xy_y-self.scrollView.contentOffset.y+item.xy_y+item.xy_height*0.1, item.xy_height*0.3, item.xy_height*0.3);
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect originFrame = self.leftRingView.isSelected?self.leftRingView.frame:self.rightRingView.frame;
    CGRect finalFrame = CGRectMake(originFrame.origin.x+originFrame.size.width*0.5-15, originFrame.origin.y+originFrame.size.width*0.5-15, 30, 30);
    CGFloat time = (originFrame.origin.y - finalFrame.origin.y)/100.0f*0.2;
    [UIView animateWithDuration:time animations:^{
        tempImageView.frame = finalFrame;
    }completion:^(BOOL finished){
        [tempImageView removeFromSuperview];
        if (self.leftRingView.isSelected) {
            self.viewModel.leftModel = model;
            self.leftRingView.imageView.image = [UIImage imageNamed:model.titleImageName];
            self.leftRingView.nameLb.text = model.zodiacName;
            self.leftRingView.dateLb.text = model.dateString;
        }else{
            self.viewModel.rightModel = model;
            self.rightRingView.imageView.image = [UIImage imageNamed:model.titleImageName];
            self.rightRingView.nameLb.text = model.zodiacName;
            self.rightRingView.dateLb.text = model.dateString;
        }
        if (self.viewModel.leftModel == nil) {
            self.leftRingView.isSelected = YES;
            self.rightRingView.isSelected = NO;
        }
        if (self.viewModel.rightModel == nil) {
            self.leftRingView.isSelected = NO;
            self.rightRingView.isSelected = YES;
        }
        if (self.viewModel.leftModel && self.viewModel.rightModel){
            self.checkCompBtn.enabled = YES;
            [self.checkCompBtn setBackgroundColor:[UIColor colorWithHex:0xBE5099]];
        }else{
            self.checkCompBtn.enabled = NO;
//            [self.checkCompBtn setBackgroundColor:[UIColor colorWithHex:0xBE5099 alpha:0.7]];
            [self.checkCompBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
        }
    }];
    
}

- (void)tapped_ring:(TTCompRingView *)view{
    if (view == self.leftRingView) {
        self.leftRingView.isSelected = YES;
        self.rightRingView.isSelected = NO;
    }else if (view == self.rightRingView){
        self.leftRingView.isSelected = NO;
        self.rightRingView.isSelected = YES;
    }
}

@end
