//
//  XYNewZodiacSelectionViewController.m
//  Horoscope
//
//  Created by 郭连城 on 2018/10/25.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "TTNewZodiacSelectController.h"
#import "WSDatePickerView.h"
#import "TTTabBarController.h"
#import "TTViewDeckController.h"
#import "TTLeftViewController.h"
#import "TTZodiacSelectionViewModel.h"
#import "TTBaseNavigationController.h"

@interface TTNewZodiacSelectController (){
    BOOL animationIsRun;
}

@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, strong)UIButton *datePickButton;
@property (nonatomic, strong)TTZodiacSelectionViewModel* viewModel;
@property (nonatomic, strong)TTZodiacItemModel* currentModel;
@property (nonatomic, strong)WSDatePickerView *picker;
@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *zodiacName;
@property (nonatomic, strong)UIButton *arrowRight;
@property (nonatomic, strong)UIButton *arrowLeft;
///星座图片
@property (nonatomic, strong)UIImageView *imageViewA;
@property (nonatomic, strong)UIImageView *imageViewABack;
///星座小图片
@property (nonatomic, strong)UIImageView *imageViewB;
///星座透明图片
@property (nonatomic, strong)UIImageView *transparentImageName;

@end

@implementation TTNewZodiacSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.presentingViewController) {
        [self addLeftItemWithImage:[UIImage imageNamed:@"nav_back_btn"] target:self selector:@selector(dismiss)];
    }
    self.title = @"Select your zodiac sign";
    TTBaseNavigationController *nav = (TTBaseNavigationController *)self.navigationController;
    [nav navWhiteTitleSet];
    
    self.backgroundImage = [UIImage imageNamed:@"风象星座"];
    animationIsRun = false;
    self.viewModel = [TTZodiacSelectionViewModel new];
    [self.view addSubview:self.imageViewABack];
    [self setupUI];
    self.selectIndex = [TTManager sharedInstance].zodiacManager.zodiacIndex - 1;
    TTZodiacItemModel *model = self.viewModel.dataArray[self.selectIndex];
    [self setModelInfo:model];
    
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if(!isVip){
            [[XYAdBaseManager sharedInstance]loadAdWithKey:ios_horoscope_plus_select_horoscope_interstitial scene:request_scene_switch_constellation_interstitial];
        }
    }];
}

- (void)setModelInfo:(TTZodiacItemModel *)model{
    self.imageViewB.image = [UIImage imageNamed:model.titleImageName];
    self.imageViewA.image = [UIImage imageNamed:model.titleImageNameA];
    self.transparentImageName.image = [UIImage imageNamed:model.transparentImageName];
    self.timeLabel.text = model.dateString;
    self.zodiacName.text = model.zodiacName;
    [UIView transitionWithView:self.imageViewABack duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.imageViewABack.image = [UIImage imageNamed:[NSString stringWithFormat:@"椭圆_%@",model.backgroundImage]];
    } completion:nil];
    [UIView transitionWithView:self.backgroundImgV duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.backgroundImage = [UIImage imageNamed:model.backgroundImage];
    } completion:nil];
    self.currentModel = model;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)setupUI{
    
    [self.datePickButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-24);
    }];

    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(KWIDTH * 235 / KWIDTH);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.datePickButton.mas_top).offset(-18*KWIDTH);
    }];
    
    [self.imageViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset((NAV_HEIGHT + 36)*KWIDTH);
        make.width.height.mas_equalTo(300 * KWIDTH);
    }];
    
    [self.imageViewABack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageViewA);
        make.width.height.mas_equalTo(KScreenWidth * KWIDTH);
    }];
    
  
    [self.transparentImageName mas_makeConstraints:^(MASConstraintMaker *make) {
         NSInteger offset = isIPhoneX ? -45 * KWIDTH : -5*KWIDTH;
        make.bottom.equalTo(self.startButton.mas_top).offset(offset);
        make.centerX.equalTo(self.view);
    }];
    
    [self.imageViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.transparentImageName.mas_top).offset(8*KWIDTH);
    }];
    
    [self.arrowRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageViewB.mas_right);
        make.centerY.equalTo(self.imageViewB);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [self.arrowLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageViewB.mas_left);
        make.centerY.equalTo(self.imageViewB);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.transparentImageName.mas_bottom).offset(-9*KWIDTH);
    }];
    
    [self.zodiacName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-8*KWIDTH);
    }];
    
    
    
    
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognize:)];
        [self.view addGestureRecognizer:(pan)];
}
- (void)applicationWillEnterForeground{
   
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.arrowRight mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageViewB.mas_right).offset(20);
        }];
        [self.arrowLeft mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageViewB.mas_left).offset(-20);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

- (void)applicationDidEnterForeground{
    [self.arrowRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageViewB.mas_right);
    }];
    
    [self.arrowLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageViewB.mas_left);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterForeground)name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.arrowRight mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageViewB.mas_right).offset(20);
        }];
        [self.arrowLeft mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageViewB.mas_left).offset(-20);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}

- (void)panGestureRecognize:(UIPanGestureRecognizer *)recognize{
    if (recognize.state == UIGestureRecognizerStateEnded){
//        NSLog(@"-----Current State: Ended-----");
        CGPoint endPoint = [recognize translationInView:self.view];
//        NSLog(@"end point (%f, %f) in View", endPoint.x, endPoint.y);
        if (endPoint.x > 0){
            [self animateView:false];
        }else{
            [self animateView:true];
        }
    }
}

- (void)clickArrowBtn:(UIButton *)sender{
    [self animateView:(sender.tag != 1)];
}

- (void)animateView:(BOOL)isLeft{
    if (animationIsRun){return;}
    animationIsRun = true;
    
    isLeft ? (self.selectIndex += 1) : (self.selectIndex -= 1);
   
    if (self.selectIndex < 0){
        self.selectIndex = 11;
    }else if (self.selectIndex > 11){
        self.selectIndex = 0;
    }
    
    TTZodiacItemModel *model = self.viewModel.dataArray[self.selectIndex];
    
    UIImageView *v = [[UIImageView alloc]initWithImage:self.imageViewA.image];
    v.frame = self.imageViewA.frame;
    v.layer.transform = CATransform3DMakeScale(1, 1, 1);
    [self.view addSubview:v];
    
    NSString *imageNameA = model.titleImageNameA;
    UIImageView *v2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageNameA]];
    v2.frame = self.imageViewA.frame;
    v2.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1);
    v2.xy_x = isLeft ? KScreenWidth : (0-v2.xy_width);
    v2.alpha = 0.5;
    [self.view addSubview:v2];
    [self.imageViewA setHidden:true];
    
    UIImageView *b = [[UIImageView alloc]initWithImage:self.imageViewB.image];
    b.frame = self.imageViewB.frame;
    [self.view addSubview:b];
    
    NSString *imageName = model.titleImageName;
    UIImageView *b2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    b2.frame = self.imageViewB.frame;
    b2.xy_x = isLeft ? (b2.xy_width + b2.xy_x) : (b2.xy_x-b2.xy_width);
    b2.alpha = 0;
    [self.view addSubview:b2];
    [self.imageViewB setHidden:true];
    [UIView animateWithDuration:0.35 animations:^{
        // 按照比例scalex=0.001,y=0.001进行缩小
        v.alpha = 0.5;
        v.xy_x = isLeft ? (0-v.xy_width) : KScreenWidth;
        v.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1);
      
        v2.alpha = 1;
        v2.xy_centerX = (KScreenWidth / 2);
        v2.layer.transform = CATransform3DMakeScale(1, 1, 1);
        
        b.alpha = 0;
        b.xy_x = isLeft ? (b.xy_x - b.xy_width) : (b.xy_x+b.xy_width);
        
        b2.alpha = 1;
        b2.xy_centerX = (KScreenWidth / 2);
        
        [self setModelInfo: model];
    } completion:^(BOOL finished) {
        
        [self.imageViewA setHidden:false];
        [self.imageViewB setHidden:false];
        
        [v removeFromSuperview];
        [v2 removeFromSuperview];
        [b removeFromSuperview];
        [b2 removeFromSuperview];
        self->animationIsRun = false;
    }];
    
}


#pragma mark - selector
- (void)start{
    if (self.navigationController.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        TTTabBarController *tabVC = [TTTabBarController new];
        TTLeftViewController* left = [TTLeftViewController new];
        left.selectBlock = tabVC.selectBlock_tabbar;
        TTViewDeckController* deck = [[TTViewDeckController alloc]initWithCenterViewController_present:tabVC leftViewController:left];
        [self presentViewController:deck animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TTManager sharedInstance].isFromTabbar = YES;
        });
    }
    
    [[XYLogManager shareManager] addLogKey1:@"horoscope_choose" key2:@"start" content:nil userInfo:nil upload:NO];
    

    
    [TTManager sharedInstance].zodiacManager.zodiacIndex = self.currentModel.zodiacIndex.integerValue;
    
    NSInteger index = self.currentModel.zodiacIndex.integerValue;
    // NSInteger saved = [XYDataHelper readDataFromKeyChainWithKey:@"zodiacIndex"].integerValue;
    NSInteger saved = [TTDataHelper readZodiacIndex].integerValue;
    if (index != saved || index != [TTManager sharedInstance].zodiacManager.zodiacIndex) {
        [TTManager sharedInstance].zodiacManager.zodiacIndex = index;
        [[TTManager sharedInstance].zodiacManager saveZodiacIdToKeychain];
    }
}


- (void)pickDate{
    [self.picker show];
    
    /****/
    [[XYLogManager shareManager] addLogKey1:@"horoscope_choose" key2:@"birthday" content:nil userInfo:nil upload:YES];
}

- (void)dismiss{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    
//    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
//    XYViewDeckController *vc = (XYViewDeckController *)window.rootViewController;
//    XYTabBarController *tabvc = (XYTabBarController *)vc.centerViewController;
//    XYBaseNavigationController *nav = (XYBaseNavigationController *)tabvc.childViewControllers[0];
//    XYHomeViewController *cVc = (XYHomeViewController *)nav.childViewControllers.firstObject;
//    NSLog(@"跟控制器：\(%@)",nav.parentViewController)

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if (isVip){
        }else{
            XYAdObject *interstitialAdObj =  [[XYAdBaseManager sharedInstance]getAdWithKey:ios_horoscope_plus_select_horoscope_interstitial showScene:show_scene_switch_constellation_interstitial];
            
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
    }];
    });
}

//MARK:- lazy

- (UIImageView *)imageViewABack{
    if(!_imageViewABack){
        _imageViewABack = [UIImageView new];
        
    }
    return _imageViewABack;
}
- (UIImageView *)transparentImageName{
    if (!_transparentImageName){
        _transparentImageName = [UIImageView new];
        [self.view addSubview:_transparentImageName];
    }
    return _transparentImageName;
}
- (UILabel *)zodiacName{
    if(!_zodiacName){
        _zodiacName = [UILabel new];
        _zodiacName.font = kFont(18);
        _zodiacName.textColor = [UIColor whiteColor];
        [self.view addSubview:_zodiacName];
    }
    return _zodiacName;
}
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [UILabel new];
        _timeLabel.font = kFont(14);
        _timeLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}
- (UIImageView *)imageViewB{
    if(!_imageViewB){
        _imageViewB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"符号 处女"]];
        [self.view addSubview:_imageViewB];
    }
    return _imageViewB;
}
- (UIButton *)arrowLeft{
    if(!_arrowLeft){
        _arrowLeft = [[UIButton alloc]init];
        _arrowLeft.tag = 1;
        [_arrowLeft addTarget:self action:@selector(clickArrowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_arrowLeft setImage:[UIImage imageNamed:@"箭头左"] forState:UIControlStateNormal];
        [self.view addSubview:_arrowLeft];
    }
    return _arrowLeft;
}

- (UIButton *)arrowRight{
    if(!_arrowRight){
        _arrowRight = [[UIButton alloc]init];
        _arrowRight.tag = 2;
        [_arrowRight addTarget:self action:@selector(clickArrowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_arrowRight setImage:[UIImage imageNamed:@"箭头右"] forState:UIControlStateNormal];
        [self.view addSubview:_arrowRight];
    }
    return _arrowRight;
}
- (UIImageView *)imageViewA{
    if (!_imageViewA){
        _imageViewA = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白羊-星座"]];
        [self.view addSubview:_imageViewA];
    }
    return _imageViewA;
}

- (UIButton *)startButton{
    if (!_startButton){
        _startButton = [[UIButton alloc]init];
        
        //    [self.startButton setBackgroundColor:RGBA(211, 38, 246, 1)];
        _startButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [_startButton setTitle:@"Get started now" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        _startButton.backgroundColor = [UIColor whiteColor];
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _startButton.layer.cornerRadius = 23;
        _startButton.layer.masksToBounds = true;
        
        [self.view addSubview:_startButton];
    }
    return _startButton;
}

- (UIButton *)datePickButton{
    if (!_datePickButton){
        
        _datePickButton = [[UIButton alloc]init];
        [_datePickButton addTarget:self action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.datePickButton];
        [_datePickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _datePickButton.titleLabel.font = kFontTitle_L_16;//[UIFont systemFontOfSize:16];
       
        [self.datePickButton setTitle:@"I don't know my zodiac sign >" forState:UIControlStateNormal];
        
    }
    return _datePickButton;
}

- (WSDatePickerView *)picker{
    if (!_picker) {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:[[TTManager sharedInstance] zodiacManager].selectedDate CompleteBlock :^(NSDate *selectDate) {
            [TTManager sharedInstance].zodiacManager.selectedDate = selectDate;
            
            self.selectIndex = [TTManager sharedInstance].zodiacManager.zodiacIndex-1;
            
            [self setModelInfo:self.viewModel.dataArray[self.selectIndex]];
//            [self.zodiacScroll scrollToIndex:zodiacIndex + 12];
            
            /****/
            NSString *key_2 = @"unknown";
            switch (self.selectIndex) {
                case 1:key_2 = @"Aries"; break;
                case 2:key_2 = @"Taurus"; break;
                case 3:key_2 = @"Gemini"; break;
                case 4:key_2 = @"Cancer"; break;
                case 5:key_2 = @"Leo"; break;
                case 6:key_2 = @"Virgo"; break;
                case 7:key_2 = @"Libra"; break;
                case 8:key_2 = @"Scorpio"; break;
                case 9:key_2 = @"Sagittarius"; break;
                case 10:key_2 = @"Capricornus"; break;
                case 11:key_2 = @"Aquarius"; break;
                case 12:key_2 = @"Pisces"; break;
                default:; break;
            }
            [[XYLogManager shareManager] addLogKey1:@"horoscope_choose" key2:key_2.lowercaseString content:nil userInfo:nil upload:YES];
        }];
        _picker = datepicker;
    }return _picker;
}


@end
