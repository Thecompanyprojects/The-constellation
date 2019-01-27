//
//  XYTarotBreakupVC.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/16.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotBreakupVC.h"
#import "TTTarotManager.h"
#import "TTTarotCardView.h"
#import "TTTarotManager.h"
#import "TTVipPaymentController.h"

#define cardViewTag 18414
#define maskViewTag 20185152

@interface TTTarotBreakupVC () <XYTarotCardViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UILabel *causeLabel;
@property (nonatomic, strong) UILabel *adviceLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *subscribeBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *notDataLabel;
@property (nonatomic, strong) UIView *loadingViewT;
@property (nonatomic, copy)   NSString *titleStr;
@property (nonatomic, assign) NSInteger tarotType;
@property (nonatomic, weak)   TTTarotCardView *animateView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSDictionary *causeDic;
@property (nonatomic, strong) NSDictionary *adviceDic;

@property (nonatomic, strong) NSMutableArray *frameArr;
@property (nonatomic, strong) NSMutableArray *cardViewArr;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) CGFloat causeHeight;
@property (nonatomic, assign) CGFloat adviceHeight;

@end

@implementation TTTarotBreakupVC

#define cardMargin (40.0*KWIDTH)
#define cardWidth ((KScreenWidth-3*cardMargin)/2)
#define cardHeight (cardWidth / 360 * 600)
- (instancetype)initWithTarotType:(NSInteger)tarotType title:(NSString *)title{
    self = [super init];
    if (self) {
        _titleStr = title;
        _tarotType = tarotType;
        _queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
        [[TTTarotManager shareInstance]breakupRandomArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tarotPaymentSucceed) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tarotPaymentFail) name:PAYMENT_FAIL_NOTIFICATION object:nil];
    
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    self.title = @"Tarot Readings";
    [self setupUI];
    
    NSNumber *cardIndex =  [TTTarotManager shareInstance].breakupArr.firstObject;
    NSNumber *cardIndex2 = [TTTarotManager shareInstance].breakupArr.lastObject;
    [[TTTarotManager shareInstance]loadTarotDataWithType:self.tarotType Index:cardIndex.integerValue index2:cardIndex2.integerValue Complete:^(NSArray *array, BOOL isSuccess) {
        if (isSuccess) {
            self.causeDic = array.firstObject;
            self.adviceDic = array.lastObject;
            self.causeLabel.attributedText = [self attributeString:self.causeDic[@"cardExplanation"] title:self.causeDic[@"cardName"]];
            self.adviceLabel.attributedText = [self attributeString:self.adviceDic[@"cardExplanation"] title:self.adviceDic[@"cardName"]];
            CGFloat causeHeight = [UIView getHeightAttributeByWidth:KScreenWidth-40*KWIDTH attTitle:self.causeLabel.attributedText font:kFontTitle_L_12];//[UIFont systemFontOfSize:12*KWIDTH]];
            
            CGFloat adviceHeight = [UIView getHeightAttributeByWidth:KScreenWidth-40*KWIDTH attTitle:self.adviceLabel.attributedText font:kFontTitle_L_12];//[UIFont systemFontOfSize:12*KWIDTH]];
            self.causeLabel.xy_height = causeHeight+10;
            self.adviceLabel.xy_height = adviceHeight+10;
            self.causeHeight = self.causeLabel.xy_height;
            self.adviceHeight = self.adviceLabel.xy_height;
            self.adviceLabel.xy_y = CGRectGetMaxY(self.causeLabel.frame) + 20*KHEIGHT;
            
            //tips label
            [self.scrollView addSubview:self.tipLabel];
            NSAttributedString *attStr = [self attributeString:[TTDataHelper readTarotTipsString] title:@"Tips:"];
            self.tipLabel.attributedText = attStr;
            CGFloat tipsHeight = [UIView getHeightAttributeByWidth:KScreenWidth-30*KWIDTH attTitle:attStr font:self.tipLabel.font];
            self.tipLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(self.adviceLabel.frame)+20*KHEIGHT, KScreenWidth-30*KWIDTH, tipsHeight+10*KHEIGHT);
            self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.tipLabel.frame)+ 60*KHEIGHT);
            
            [self refreshVipStatus];
        }else{
            [self.baseView addSubview:self.notDataLabel];
        }
        
        /*
        (
        {
            cardExplanation = "Cause: Relying on self-confidence and determination can be enough in many situations, but unfortunately it wasn't enough to keep this relationship intact. The Strength card denotes the potential to turn determination into aggression, which clearly didn't help your situation. The more intolerance there is, the faster a partnership disintegrates. A kinder, gentler approach could have kept things afloat for a while longer.";
            cardName = Cause;
        },
        {
            cardExplanation = "Advice: It's painful when someone lies or is deceitful, and now that the relationship is over, it's very human to want to seek revenge. The Justice card reminds you that nothing good will come of this. Resist the urge to plan and plot. The Universe is fair and balanced, and what goes around usually comes back around all on its own.";
            cardName = Advice;
        }
         )
        */
    }];
    
}

- (void)setupUI{
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.contentL];
    [self.baseView addSubview:self.getBtn];
    
    NSInteger count = 2;//列
    CGFloat width = cardWidth;
    CGFloat height = cardHeight;
    
    for (int i=0; i<2; i++) {
        NSInteger columnNum = i%count;
        NSInteger rowNum = i/count;
        CGRect rect = CGRectMake((columnNum+1)*cardMargin + columnNum * width, rowNum*height+rowNum*cardMargin + (KScreenHeight* 0.5 - cardHeight * 0.5), width, height);
        [self.frameArr addObject:[NSValue valueWithCGRect:rect]];
        
        TTTarotCardView *cardView = [[TTTarotCardView alloc]initWithFrame:CGRectMake(0, 0, width*0.8, height*0.8)];
        cardView.center = CGPointMake(self.baseView.xy_width * 0.5, KScreenHeight - height * 0.5);
        cardView.tag = cardViewTag + i;
        NSNumber *tarotIndex = [TTTarotManager shareInstance].breakupArr[i];
        cardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"塔罗 正 %02zd",tarotIndex.integerValue]];
        cardView.delegate = self;
        [self.baseView addSubview:cardView];
        [self.baseView sendSubviewToBack:cardView];
        [self.cardViewArr addObject:cardView];
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCardView:)]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(self.queue, ^{
                self.semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cardView startanimateFrame:rect duration:0.8/12 animate:nil completion:^{
                        dispatch_semaphore_signal(self.semaphore);
                    }];
                });
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            });
        });
    }
//    _getBtn.userInteractionEnabled = YES;
    //scrollView
    [self.baseView addSubview:self.scrollView];
    self.scrollView.xy_y = KScreenHeight - height +15*KHEIGHT;
    [self.scrollView addSubview:self.causeLabel];
    [self.scrollView addSubview:self.adviceLabel];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.adviceLabel.frame) + 15*KHEIGHT);
    
}

- (void)refreshVipStatus{
    [self.scrollView addSubview:self.subscribeBtn];
    [self.subscribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(95*KHEIGHT);
        make.width.offset(KScreenWidth-40*KWIDTH);
        make.height.offset(50*KWIDTH);
        make.centerX.equalTo(self.scrollView);
    }];
    
    self.causeLabel.xy_height = 25*KHEIGHT;
    self.adviceLabel.xy_height = 25*KHEIGHT;
    self.adviceLabel.xy_y = CGRectGetMaxY(self.causeLabel.frame)+10*KHEIGHT;
//    self.adviceLabel.alpha = 0;
    self.scrollView.scrollEnabled = NO;
    self.tipLabel.alpha = 0;
    
    
    [[TTManager sharedInstance] checkVipStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            
        }else{
            self.scrollView.scrollEnabled = YES;
            self.causeLabel.xy_height = self.causeHeight;
            self.adviceLabel.xy_height = self.adviceHeight;
            self.adviceLabel.xy_y = CGRectGetMaxY(self.causeLabel.frame) + 20*KHEIGHT;
            self.adviceLabel.alpha = 1;
            self.tipLabel.alpha = 1;
            [self.subscribeBtn removeFromSuperview];
        }
    }];
}

- (void)clickCardView:(UITapGestureRecognizer *)tap{
    for (int i=0; i<self.cardViewArr.count; i++) {
        TTTarotCardView *view = self.cardViewArr[i];
        view.layer.zPosition = 0;
    }
    TTTarotCardView *cardView = (TTTarotCardView *)tap.view;
    self.index = cardView.tag - cardViewTag;
    self.animateView = cardView;
    cardView.layer.zPosition = 1000;
    
    [cardView startAnimatePoint:CGPointMake(cardView.center.x, cardView.center.y) scale:@(1)];
}

- (void)clickGetBtn{
    for (int i=0; i<self.cardViewArr.count; i++) {
        TTTarotCardView *view = self.cardViewArr[i];
        [view.layer removeAllAnimations];
        [view reversalImageView];
        [UIView animateWithDuration:0.25 animations:^{
            view.xy_y = NAV_HEIGHT + 20*KHEIGHT;
            self.contentL.alpha = 0;
            self.getBtn.alpha = 0;
            self.scrollView.alpha = 1;
            self.scrollView.xy_y = NAV_HEIGHT + cardHeight + 40*KHEIGHT;
            self.notDataLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - XYTarotCardViewDelegate

- (void)startAnimateCardView:(TTTarotCardView *)cardView{
    
}

- (void)stopAnimateCardView:(TTTarotCardView *)cardView{
    cardView.userInteractionEnabled = NO;
//    self.getBtn.backgroundColor = COLOR_BTN;
//    self.getBtn.userInteractionEnabled = YES;
    self.getBtn.enabled = YES;
    for (TTTarotCardView *view in self.cardViewArr) {
        if (!view.isPositive) {
//            self.getBtn.backgroundColor = COLOR_GRAY;
            self.getBtn.enabled = NO;
//            self.getBtn.userInteractionEnabled = NO;
            break;
        }
    }
}

- (void)cardViewProgress:(CGFloat)progress{
    
    
}

#pragma mark - Observer payment

- (void)tarotPaymentSucceed{
    [self refreshVipStatus];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedVC" object:@{@"className":@"TTTarotPickCardVC", @"image":@"图标 底导航 付费 激活态", @"title":@"Get Premium" ,@"value":@"", @"title":@""}];
    [TTDataHelper saveTarotTimeType:@(self.tarotType).stringValue];
    [TTDataHelper saveTarotType:@(self.tarotType).stringValue value:@[self.causeDic,self.adviceDic]];

}

- (void)tarotPaymentFail{
//    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedVC" object:@{@"className":@"TTTarotPickCardVC", @"image":@"图标 底导航 付费 激活态", @"title":@"Get Premium" ,@"value":@"", @"title":@""}];
}

- (void)clickSubscribeBtn{

    TTVipPaymentController *purchaseVC = [[TTVipPaymentController alloc] init];
    purchaseVC.isFullScreen = YES;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}

- (UIView *)createSubscribeBtnView{
    
    UIView *view = [[UIView alloc]init];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = COLOR_BTN;
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bt_fangxing"]];
    [view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    
    
    UIView *cView = [[UIView alloc]init];
    [view addSubview:cView];
    [cView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小图标 引导付费钻石"]];
    [cView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(cView);
        make.width.height.offset(25*KWIDTH);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    
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
    [muAtt addAttribute:NSForegroundColorAttributeName value:kHexColor(0x333333)  range:NSMakeRange(0, title.length)];
    return muAtt.copy;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc]init];
        _baseView.frame = self.view.bounds;
    }
    return _baseView;
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.textColor = kHexColor(0x333333);//[UIColor whiteColor];
        _contentL.text = self.titleStr;
        _contentL.numberOfLines = 0;
        _contentL.textAlignment = NSTextAlignmentCenter;
        _contentL.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        CGFloat height = [UIView getHeightByWidth:KScreenWidth-40*KWIDTH title:self.titleStr font:_contentL.font];
        _contentL.frame = CGRectMake(20*KWIDTH, NAV_HEIGHT+20*KHEIGHT, KScreenWidth-40*KWIDTH, height);
    }
    return _contentL;
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

- (UIButton *)getBtn{
    if (!_getBtn) {
        _getBtn = [[UIButton alloc]init];
        [_getBtn setTitle:@"Get your breakup tarot reading" forState:UIControlStateNormal];
        _getBtn.titleLabel.textColor = [UIColor whiteColor];
        
        [_getBtn setBackgroundImage:[UIImage imageNamed:@"bt_fangxing"] forState:UIControlStateNormal];
//        _getBtn.backgroundColor = COLOR_GRAY;
        _getBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16*KWIDTH];
        _getBtn.frame = CGRectMake(0, KScreenHeight - 60*KHEIGHT, KScreenWidth, 60*KHEIGHT);
        [_getBtn addTarget:self action:@selector(clickGetBtn) forControlEvents:UIControlEventTouchUpInside];
        _getBtn.enabled = NO;
    }
    return _getBtn;
}

- (UILabel *)causeLabel{
    if (!_causeLabel) {
        _causeLabel = [[UILabel alloc]init];
        _causeLabel.text = self.titleStr;
        _causeLabel.textColor = kHexColor(0x333333);//[[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _causeLabel.font = kFontTitle_L_12;//[UIFont systemFontOfSize:12*KWIDTH];
        _causeLabel.numberOfLines = 0;
        _causeLabel.textAlignment = NSTextAlignmentLeft;
        //CGFloat height = [UIView getHeightByWidth:KScreenWidth-40*KWIDTH title:self.titleStr font:_causeLabel.font];
        _causeLabel.frame = CGRectMake(20*KWIDTH, 20*KHEIGHT, KScreenWidth-40*KWIDTH, 0);
    }
    return _causeLabel;
}

- (UILabel *)adviceLabel{
    if (!_adviceLabel) {
        _adviceLabel = [[UILabel alloc]init];
        _adviceLabel.text = self.titleStr;
        _adviceLabel.textColor =kHexColor(0x333333);// [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _adviceLabel.font = kFontTitle_L_12;//[UIFont systemFontOfSize:12*KWIDTH];
        _adviceLabel.numberOfLines = 0;
        _adviceLabel.textAlignment = NSTextAlignmentLeft;
       // CGFloat height = [UIView getHeightByWidth:KScreenWidth-40*KWIDTH title:self.titleStr font:_adviceLabel.font];
        _adviceLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(_causeLabel.frame) + 20*KHEIGHT, KScreenWidth-40*KWIDTH, 0);
    }
    return _adviceLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, NAV_HEIGHT + 40*KHEIGHT + cardHeight, KScreenWidth, KScreenHeight- (NAV_HEIGHT + 40*KHEIGHT + cardHeight));
        _scrollView.alpha = 0;
//        _scrollView.backgroundColor = [UIColor redColor];
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
        _tipLabel.alpha = 0;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = kHexColor(0x333333);//[[UIColor whiteColor]colorWithAlphaComponent:1];
    }
    return _tipLabel;
}

- (UILabel *)notDataLabel{
    if (!_notDataLabel) {
        _notDataLabel = [[UILabel alloc]init];
        _notDataLabel.frame = CGRectMake(20*KWIDTH, NAV_HEIGHT + 40*KHEIGHT + cardHeight + 50*KHEIGHT, KScreenWidth-40*KWIDTH, 50*KHEIGHT);
        _notDataLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        
        _notDataLabel.textAlignment = NSTextAlignmentCenter;
        _notDataLabel.numberOfLines = 0;
        _notDataLabel.alpha = 0;
        _notDataLabel.text = @"The Internet connection appears to be offline.";
        _notDataLabel.textColor = kHexColor(0x333333);//[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    }
    return _notDataLabel;
}

- (UIView *)loadingViewT{
    if (!_loadingViewT) {
        _loadingViewT = [TTLoadingHUD CreateTarotLoadingViewWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - self.scrollView.xy_y)];
        _loadingViewT.frame = CGRectMake(0, self.scrollView.xy_y, KScreenWidth, KScreenHeight - self.scrollView.xy_y);
    }
    return _loadingViewT;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

@end
