//
//  XYTarotPickCardVC.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/14.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotPickCardVC.h"
#import "TTTarotCardView.h"
#import "TTTarotManager.h"
#import "TTVipPaymentController.h"
#import "TTAdHelpr.h"
#define cardViewTag 1841
#define maskViewTag 2018515

#define margin 10.0*KWIDTH

#define pointY (self.cardHeight*0.5*cardScale+NAV_HEIGHT+20*KHEIGHT)
#define titleY (self.cardHeight*cardScale+NAV_HEIGHT+20*KHEIGHT + 20*KWIDTH)

@interface TTTarotPickCardVC () <XYTarotCardViewDelegate,GADRewardBasedVideoAdDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *frameArr;
@property (nonatomic, strong) NSMutableArray *cardViewArr;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *subscribeBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *notDataLabel;
@property (nonatomic, strong) UIView *loadingViewT;
@property (nonatomic, weak)   UIView *baseView;
@property (nonatomic, weak)   UIView *cardView;
@property (nonatomic, weak)   UILabel *titleL;
@property (nonatomic, weak)   TTTarotCardView *animateView;
@property (nonatomic, assign) BOOL isShowCard;
@property (nonatomic, assign) BOOL isClickShow;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger tarotType;
@property (nonatomic, copy)   NSString *titleStr;

@property (nonatomic, strong) NSDictionary *contentDic;

@property (nonatomic, assign) CGFloat cardHeight;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) NSTimeInterval kCardResultEnterTime;

@property (nonatomic, assign) XYResultType btnType;
@property (nonatomic, assign) BOOL isReward; /**< 看过奖励视频了 */
@end

@implementation TTTarotPickCardVC

- (instancetype)initWithTarotType:(NSInteger)tarotType title:(NSString *)title{
    self = [super init];
    if (self) {
        _titleStr = title;
        _tarotType = tarotType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TTAdHelpr recordTheNumberOfTarotListVc];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYLogManager shareManager]uploadAllLog];
    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tarotPaymentSucceed) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tarotPaymentFail) name:PAYMENT_FAIL_NOTIFICATION object:nil];
    
    self.isShowCard = NO;
    [[TTTarotManager shareInstance]randomArray];
    self.queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    self.title = @"Tarot Readings";
    [self setupUI];
}

- (void)setupUI{
    UIView *baseView = [[UIView alloc]init];
    self.baseView = baseView;
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UILabel *contentL = [[UILabel alloc]init];
    contentL.textColor = [UIColor blackColor];
    contentL.text = self.titleStr;
    contentL.numberOfLines = 0;
    contentL.textAlignment = NSTextAlignmentCenter;
    contentL.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    [baseView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView).offset(NAV_HEIGHT+10*KHEIGHT);
        make.centerX.equalTo(baseView);
        make.width.lessThanOrEqualTo(baseView).offset(-30);
    }];
    
    UILabel *titleL = [[UILabel alloc]init];
    self.titleL = titleL;
    titleL.text = @"PICK ONE CARD";
    titleL.font = [UIFont boldSystemFontOfSize:13*KWIDTH];
    titleL.textColor = [UIColor blackColor];
    [baseView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentL.mas_bottom).offset(10*KHEIGHT);
        make.centerX.equalTo(contentL);
    }];
    
    [baseView layoutIfNeeded];
    [self createCardView];
    
}

- (void)createCardView{
    NSInteger count = 4;//列
//    NSInteger row = 3;  //行
    CGFloat width = (KScreenWidth - (count+1) * margin) / count;
    CGFloat height = width/360*600;//360  600
    self.cardHeight = height;
    
    CGFloat marginR = CGRectGetMaxY(self.titleL.frame) + 15*KHEIGHT;
    for (int i=0; i<12; i++) {
        NSInteger columnNum = i%count;
        NSInteger rowNum = i/count;
        CGRect rect = CGRectMake((columnNum+1)*margin + columnNum * width, rowNum*height+rowNum*margin + marginR, width, height);
        [self.frameArr addObject:[NSValue valueWithCGRect:rect]];
        
        TTTarotCardView *cardView = [[TTTarotCardView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        cardView.center = CGPointMake(self.baseView.xy_width*0.5-i*2, self.baseView.xy_height-height  - i*2);
        cardView.tag = cardViewTag + i;
        NSNumber *tarotIndex = [TTTarotManager shareInstance].randArr[i];
        cardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"塔罗 正 %02zd",tarotIndex.integerValue]];
        cardView.delegate = self;
        [self.baseView addSubview:cardView];
//        [self.cardView sendSubviewToBack:cardView];
        [self.baseView sendSubviewToBack:cardView];
        [self.cardViewArr addObject:cardView];
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCardView:)]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(self.queue, ^{
                self.semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [cardView startanimateFrame:rect duration:0.8/12 animate:nil completion:^{
                        [self.baseView sendSubviewToBack:cardView];
                        dispatch_semaphore_signal(self.semaphore);
                    }];
                });
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            });
        });
    }
    [self.baseView sendSubviewToBack:self.cardView];
}

- (void)backToPrevious {

    NSTimeInterval enterTime = self.kCardResultEnterTime;
    if (enterTime > 0) {
        NSTimeInterval outTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *duration = [NSString stringWithFormat:@"%.0f",outTime - enterTime];
        [[XYLogManager shareManager] addLogKey1:@"tarot_reading_view" key2:@"duration" content:@{@"millisecond":duration, @"type":[self typeString:self.tarotType]} userInfo:nil upload:YES];
    }
    
    
    [super backToPrevious];
}

- (void)clickCardView:(UITapGestureRecognizer *)tap{
    if (_isShowCard || _isShowing) return;
    
    
    /****/
    NSString *key_2 = @"unknown";
    switch (self.tarotType) {
        case 1:key_2 = @"daily_tarot_reading"; break;
        case 2:key_2 = @"love_tarot_reading"; break;
        case 3:key_2 = @"daily_career_tarot_reading"; break;
        case 4:key_2 = @"yes/no_tarot_reading"; break;
        case 5:key_2 = @"love_potential_tarot_reading"; break;
        case 6:key_2 = @"breakup_tarot_reading"; break;
        case 7:key_2 = @"daily_flirt_tarot_reading"; break;
        default:
            break;
    }
    [[XYLogManager shareManager] addLogKey1:@"discover" key2:key_2 content:nil userInfo:nil upload:YES];
    
    self.kCardResultEnterTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    
    
    __weak typeof(self) weakself = self;
    _isShowCard = YES;
    _isClickShow = YES;
    _isShowing = YES;
    [self.baseView addSubview:self.maskView];
    
    for (int i=0; i<self.cardViewArr.count; i++) {
        TTTarotCardView *view = self.cardViewArr[i];
        view.layer.zPosition = 0;
    }
    TTTarotCardView *cardView = (TTTarotCardView *)tap.view;
    self.index = cardView.tag - cardViewTag;
    self.animateView = cardView;
    cardView.layer.zPosition = 1000;
//    [self.baseView bringSubviewToFront:self.maskView];
//    [self.baseView bringSubviewToFront:cardView];
    [cardView startAnimatePoint:CGPointMake(self.baseView.xy_width*0.5, pointY) scale:@(2)];
    NSNumber *cardIndex =  [TTTarotManager shareInstance].randArr[self.index];
    [self.view addSubview:self.loadingViewT];
    [[TTTarotManager shareInstance]loadTarotDataWithType:self.tarotType Index:cardIndex.integerValue Complete:^(NSArray *array, BOOL isSuccess) {
        [self.loadingViewT removeFromSuperview];
        if (isSuccess) {
            NSDictionary *dic = array.firstObject;
            weakself.contentDic = dic;
            [weakself createDetailViewWithTitle:dic[@"cardName"] content:dic[@"cardExplanation"]];
        }else{
            [self.maskView addSubview:self.notDataLabel];
        }
    }];
}

- (void)clickMaskView{
    if (_isShowing) return;
    [self.maskView removeFromSuperview];
    _isClickShow = NO;
    _isShowing = YES;
    [self.animateView recoverAnimate];
}

- (void)hideAllViewAlpha:(CGFloat)alpha{
    for (UIView *view in self.baseView.subviews) {
        if ((view.tag!=self.animateView.tag) && view.tag != maskViewTag) {
            view.alpha = alpha;
        }
    }
}

#pragma mark - XYTarotCardViewDelegate

- (void)startAnimateCardView:(TTTarotCardView *)cardView{
    if (_isShowCard) {
        
//        [self.baseView insertSubview:self.maskView aboveSubview:cardView];
    }
}

- (void)stopAnimateCardView:(TTTarotCardView *)cardView{
    if (_isShowCard && !_isClickShow) {
        _isShowCard = NO;
        self.titleLabel.text = @"";
        self.contentLabel.text = @"";
    }
    _isShowing = NO;
}

- (void)cardViewProgress:(CGFloat)progress{
    if (_isShowCard) {
        self.maskView.alpha = progress;
        self.scrollView.alpha = progress;
        [self hideAllViewAlpha:1 - progress];
    }else{
        self.maskView.alpha = 1-progress;
        self.scrollView.alpha = 1-progress;
        [self hideAllViewAlpha:progress];
    }
}

#pragma mark - Observer payment

- (void)tarotPaymentSucceed{
    [self createDetailViewWithTitle:self.contentDic[@"cardName"] content:self.contentDic[@"cardExplanation"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedVC" object:@{@"className":@"TTTarotPickCardVC", @"image":@"图标 底导航 付费 激活态", @"title":@"Get Premium" ,@"value":@"", @"title":@""}];
    [TTDataHelper saveTarotTimeType:@(self.tarotType).stringValue];
    [TTDataHelper saveTarotType:@(self.tarotType).stringValue value:@[self.contentDic]];
}

- (void)tarotPaymentFail{
//    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedVC" object:@{@"className":@"TTTarotPickCardVC", @"image":@"图标 底导航 付费 激活态", @"title":@"Get Premium" ,@"value":@"", @"title":@""}];
}

- (void)createDetailViewWithTitle:(NSString *)title content:(NSString *)content{
//    [self.scrollView removeFromSuperview];
//    self.scrollView = nil;
    [self.maskView addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    self.titleLabel.text = title;
    self.titleLabel.frame = CGRectMake(20*KWIDTH, 0, 200*KWIDTH, 30*KWIDTH);
    [self.scrollView addSubview:self.contentLabel];
    CGFloat height = [UIView getHeightByWidth:KScreenWidth-40*KWIDTH title:content font:self.contentLabel.font];
    self.contentHeight = height;
    self.contentLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(self.titleLabel.frame), KScreenWidth-40*KWIDTH, height);
    self.contentLabel.text = content;
    
    //tips label
    [self.scrollView addSubview:self.tipLabel];
    NSAttributedString *attStr = [self attributeString:[TTDataHelper readTarotTipsString] title:@"Tips:"];
    self.tipLabel.attributedText = attStr;
    CGFloat tipsHeight = [UIView getHeightAttributeByWidth:KScreenWidth-30*KWIDTH attTitle:attStr font:self.tipLabel.font];
    self.tipLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(self.contentLabel.frame)+20*KHEIGHT, KScreenWidth-30*KWIDTH, tipsHeight+10*KHEIGHT);
    
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.tipLabel.frame) + 20*KHEIGHT);
    
    self.contentLabel.xy_height = 25*KHEIGHT;
//    UIView *subscribeBtn = [self createSubscribeBtnView];
    
    [self.scrollView addSubview:self.subscribeBtn];
    [self.subscribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(60*KHEIGHT);
        make.width.offset(KScreenWidth-40*KWIDTH);
        make.height.offset(50*KWIDTH);
        make.centerX.equalTo(self.scrollView);
    }];
    self.scrollView.scrollEnabled = NO;
    
    [TTAdHelpr getTitleForType:XYShowAdAdsTarot tarotIndex:(int)self.tarotType WithComplete:^(XYResultType btnType) {
        self.btnType = btnType;
        switch (btnType) {
            case XYResultTypeNotShowBtn:{//上边逻辑有处理，这不作处理
                self.scrollView.scrollEnabled = YES;
                self.contentLabel.xy_height = height;
                [self.subscribeBtn removeFromSuperview];
                self.tipLabel.alpha = 1;
            } break;
                
                case XYResultTypeShowPayBtn://上边逻辑有处理，这不作处理
                
                break;
                
                case XYResultTypeShowPlayVideoBtn:
                    [self checkSubLabel:self.subscribeBtn];
                break;
        }
    }];
}

- (void)checkSubLabel:(UIView *)v{
    
    for (UIView *sub in v.subviews){
        v.backgroundColor = [UIColor whiteColor];
        if(sub.tag == 1){
            UIImageView *v = (UIImageView *)sub;
            v.layer.cornerRadius = 50*KWIDTH / 2;
            v.layer.masksToBounds = YES;
            
            UIColor *grandColor = [UIColor colorGradientWithSize:CGSizeMake(KScreenWidth, v.xy_height) direction:GradientDirection_Horizontal startColor:kHexColor(0xFFFE4D4D) endColor:kHexColor(0XFFEE1919)];
            v.backgroundColor = grandColor;
            [v setImage: [UIImage imageNamed:@""]];
        }else if(sub.tag == 2){
            for (UIView *subs in sub.subviews){
                if(subs.tag == 3){
                    UIImageView *v = (UIImageView *)subs;
                    [v setImage: [UIImage imageNamed:@"视频"]];
                }else if(subs.tag == 4){
                    UILabel *l = (UILabel *)subs;
                    l.text = @"Watch Video To Read On";
                }
            }
        }
    }
}


- (NSString *)typeString:(NSInteger)type {
    NSString *typeStr = @"unknown";
    switch (type) {
        case 1:typeStr = @"daily_tarot"; break;
        case 2:typeStr = @"love_tarot"; break;
        case 3:typeStr = @"daily_career_tarot"; break;
        case 4:typeStr = @"yes/no_tarot"; break;
        case 5:typeStr = @"love_potential_tarot"; break;
        case 6:typeStr = @"breakup_tarot"; break;
        case 7:typeStr = @"daily_flirt_tarot"; break;
        default:
            break;
    }
    return typeStr;
}

- (void)clickSubscribeBtn{
    
    switch (self.btnType) {
        case XYResultTypeShowPlayVideoBtn:
            
            if ([GADRewardBasedVideoAd sharedInstance].isReady) {
                [GADRewardBasedVideoAd sharedInstance].delegate = self;
                [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
                return;
            }
            
            [GADRewardBasedVideoAd sharedInstance].delegate = self;
            [SVProgressHUD show];
            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_button_reward scene:request_scene_reward];
            
            NSLog(@"需要添加激励视频")
            break;
            
        default:{
            /****/
            [[XYLogManager shareManager] addLogKey1:@"discover" key2:@"premium" content:@{@"type":[self typeString:self.tarotType]} userInfo:nil upload:YES];
            
            [TTManager sharedInstance].paySource = [self typeString:self.tarotType];
            
            TTVipPaymentController *purchaseVC = [[TTVipPaymentController alloc] init];
            purchaseVC.isFullScreen = YES;
            [self.navigationController pushViewController:purchaseVC animated:YES];
        } break;
    }
}

#pragma mark - GADRewardBasedVideoAdDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"^^^^^^^^:激励视频广告:完成奖励");
    
    self.isReward = YES;
    
    self.scrollView.scrollEnabled = YES;
    
    [TTAdHelpr saveTodayWatchedVideo:XYShowAdAdsTarot tarotIndex:self.tarotType];
    
    CGFloat height = [UIView getHeightByWidth:KScreenWidth-40*KWIDTH title:self.contentLabel.text font:self.contentLabel.font];
    self.contentLabel.xy_height = height;
    [self.subscribeBtn removeFromSuperview];
    self.tipLabel.alpha = 1;
    
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




- (UIView *)createSubscribeBtnView{
    
    UIView *view = [[UIView alloc]init];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = COLOR_BTN;
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bt_fangxing"]];
    [view addSubview:backImage];
    backImage.tag = 1;
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    
    UIView *cView = [[UIView alloc]init];
      cView.tag = 2;
    [view addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小图标 引导付费钻石"]];
    imageView.tag = 3;
    [cView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(cView);
        make.width.height.offset(25*KWIDTH);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.tag = 4;
    label.text = @"View full prediction with premium";
    label.font = [UIFont boldSystemFontOfSize:13*KWIDTH];
    [cView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(cView);
        make.centerY.equalTo(imageView);
    }];
    label.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSubscribeBtn)]];
    return view;
}

- (NSAttributedString *)attributeString:(NSString *)string title:(NSString *)title{
    NSMutableAttributedString *muAtt = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",string]];
    [muAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14*KWIDTH] range:NSMakeRange(0, title.length)];
    [muAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]  range:NSMakeRange(0, title.length)];
    return muAtt.copy;
}

- (NSMutableArray *)frameArr{
    if (!_frameArr) {
        _frameArr = [NSMutableArray array];
    }
    return _frameArr;
}

- (NSMutableArray *)cardViewArr{
    if (!_cardViewArr) {
        _cardViewArr = [NSMutableArray array];
    }
    return _cardViewArr;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.tag = 2018515;
        _maskView.frame = self.view.bounds;
//        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMaskView)]];
        
    }
    return _maskView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:15*KWIDTH];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }
    return _contentLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, titleY, KScreenWidth, KScreenHeight-titleY);
        _scrollView.alpha = 0;
    }
    return _scrollView;
}

- (UIView *)subscribeBtn{
    if (!_subscribeBtn) {
        _subscribeBtn = [self createSubscribeBtnView];
    }
    return _subscribeBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
        _tipLabel.alpha = 0;
        _tipLabel.textColor = [[UIColor blackColor]colorWithAlphaComponent:1];
    }
    return _tipLabel;
}

- (UILabel *)notDataLabel{
    if (!_notDataLabel) {
        _notDataLabel = [[UILabel alloc]init];
        _notDataLabel.frame = CGRectMake(20*KWIDTH, titleY + 50*KHEIGHT, KScreenWidth-40*KWIDTH, 50*KHEIGHT);
        _notDataLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _notDataLabel.textAlignment = NSTextAlignmentCenter;
        _notDataLabel.numberOfLines = 0;
        _notDataLabel.alpha = 1;
        _notDataLabel.text = @"The Internet connection appears to be offline.";
        _notDataLabel.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }
    return _notDataLabel;
}

- (UIView *)loadingViewT{
    if (!_loadingViewT) {
        _loadingViewT = [TTLoadingHUD CreateTarotLoadingViewWithFrame:CGRectMake(0, titleY, KScreenWidth, KScreenHeight - self.scrollView.xy_y)];
        _loadingViewT.frame = CGRectMake(0, titleY, KScreenWidth, KScreenHeight - self.scrollView.xy_y);
    }
    return _loadingViewT;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
