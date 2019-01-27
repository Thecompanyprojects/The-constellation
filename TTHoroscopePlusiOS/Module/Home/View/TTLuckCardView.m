//
//  XYLuckCardView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTLuckCardView.h"
#import "TTPaymentManager.h"
#define topImgH (self.bounds.size.width/1000*400)
#define margin 20.0
#import "TTAdHelpr.h"
@interface TTLuckCardView ()
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UIView *btmView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIImageView *ballImgV;
@property (nonatomic, strong) UIImageView *middleImgV;
@property (nonatomic, strong) UILabel *moreL;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *currentTimeL;
@property (nonatomic, assign) XYLuckCardViewTpye cardType; //0
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, weak)   UIView *subscribeView;

@property (nonatomic, assign)   XYResultType payBtnType;//按钮类型。付费还是看视频还是没有


@end

@implementation TTLuckCardView

//- (instancetype)initWithFrame:(CGRect)frame model:(XYHoroscopeModel *)model{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _model = model;
//    }
//    return self;
//}
//这个遍历构造函数只为了home页面的after 1 明天 2 周 3 月 4 年
//- (instancetype)initWithFrame:(CGRect)frame cardType:(XYLuckCardViewTpye)cardType afterType:(NSInteger)afterType{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _cardType = cardType;
//        __weak typeof(self) weakself = self;
//        if (cardType == AFTER_TYPE) {
//            [[XYManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
//                __strong typeof(weakself) strongself = weakself;
//                [[XYLogManager shareManager] addLogKey1:@"luck_card" key2:@"check_vip" content:@{@"is_vip":[NSString stringWithFormat:@"%d",isVip]} userInfo:nil upload:NO];
//                if (isVip) {
//                    strongself.cardType = HOME_TYPE;
//                }
//            }];
//        }
//        _locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        [self testUI];
//    }
//    return self;
//}


- (instancetype)initWithFrame:(CGRect)frame cardType:(XYLuckCardViewTpye)cardType{
    self = [super initWithFrame:frame];
    if (self) {
        
        _cardType = cardType;
        __weak typeof(self) weakself = self;
        if (cardType == AFTER_TYPE) {
            [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
                __strong typeof(weakself) strongself = weakself;
                [[XYLogManager shareManager] addLogKey1:@"luck_card" key2:@"check_vip" content:@{@"is_vip":[NSString stringWithFormat:@"%d",isVip]} userInfo:nil upload:NO];
                if (isVip) {
                    strongself.cardType = HOME_TYPE;
                }
            }];
        }
        _locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [self testUI];
    }
    return self;
}

//#define topW (335.0*KWIDTH)
#define topW (self.frame.size.width)
#define topH (topW/375*216)
#define marginL 15.0
#define maxH 70.0

- (void)testUI{
    //    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    __weak typeof(self) weakself = self;
    //    self.layer.masksToBounds = YES;
    //    self.layer.cornerRadius = 5;
    [self addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(topW);
        make.height.offset(topH);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.topImgView addSubview:self.ballImgV];
    [self.ballImgV addSubview:self.middleImgV];
    [self.topImgView addSubview:self.timeLabel];
    [self.topImgView addSubview:self.titleLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImgView.mas_bottom).offset(14);
        make.right.equalTo(self.topImgView).offset(-marginL);
        //        make.right.lessThanOrEqualTo(self.topImgView).offset(-20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImgView).offset(marginL);
        make.top.equalTo(self.topImgView.mas_bottom).offset(14);
        //        make.bottom.equalTo(self.timeLabel.mas_top).offset(-5);
    }];
    
    [self addSubview:self.btmView];
    [self.btmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImgView.mas_bottom);
        make.left.right.equalTo(self.topImgView);
        make.bottom.equalTo(self);
    }];
    
    if (_cardType == CHARACTERISTIC_TYPE) {
        [self.btmView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImgView.mas_bottom).offset(44);
            make.left.bottom.right.equalTo(self.btmView);
        }];
        
        [self.scrollView addSubview:self.desLabel];
        
    }else if (_cardType == HOME_TYPE){
        
        [self.btmView addSubview:self.currentTimeL];
        [self.currentTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(marginL);
            make.left.equalTo(self.btmView).offset(marginL);
        }];
        
        [self.btmView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btmView).offset(marginL);
            make.right.equalTo(self.btmView).offset(-marginL);
            make.top.equalTo(self.currentTimeL.mas_bottom).offset(marginL);
        }];
    }else if (_cardType == FORECAST_TYPE || _cardType == TIPS_TYPE){
        [self.btmView addSubview:self.scrollView];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImgView.mas_bottom).offset(28);
            //            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.right.bottom.equalTo(self.btmView);
            //            make.edges.equalTo(self.btmView);
        }];
        [self.scrollView addSubview:self.desLabel];
        
    }else if (_cardType == AFTER_TYPE){
        
        [self.btmView addSubview:self.currentTimeL];
        [self.currentTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.left.equalTo(self.btmView).offset(marginL);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(marginL);
            make.left.equalTo(self.btmView).offset(marginL);
        }];
        
        [self.btmView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btmView).offset(marginL);
            make.right.equalTo(self.btmView).offset(-marginL);
            make.top.equalTo(self.currentTimeL.mas_bottom).offset(marginL);
        }];
        
        UIView *subscribeView = [self createSubscribeBtnView];
        self.subscribeView = subscribeView;
        [self.btmView addSubview:subscribeView];
        [subscribeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desLabel.mas_bottom).offset(12*KWIDTH);
            make.centerX.equalTo(self.desLabel);
            make.width.equalTo(self.btmView).offset(-20*KWIDTH);
            make.height.offset(50*KWIDTH);
            make.bottom.equalTo(self.btmView).offset(-10*KWIDTH);
        }];
    }
    
    [self.btmView addSubview:self.moreL];
    [self.moreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(20*KWIDTH);
        make.centerX.equalTo(self.desLabel);
        if (weakself.cardType != AFTER_TYPE) {
            make.height.offset(0);
        }
        make.bottom.equalTo(self.btmView).offset(-20*KWIDTH);
    }];
}

- (void)setModel:(TTHoroscopeModel *)model{
    _model = model;
    NSAttributedString *attributeContent = [self getAttributedStringWithLineSpace:model.content lineSpace:5 kern:0];
    self.desLabel.attributedText = attributeContent;
    self.titleLabel.text = [TTManager sharedInstance].itemModel.zodiacName;
    self.timeLabel.text = [TTManager sharedInstance].itemModel.dateString;
    CGFloat height = [self heightViewWithStr:attributeContent];
    
    if (_cardType == HOME_TYPE) {
        self.moreL.alpha = 1;
        [self.moreL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desLabel.mas_bottom).offset(20*KWIDTH);
            make.centerX.equalTo(self.desLabel);
            make.bottom.equalTo(self.btmView).offset(-11*KWIDTH);
        }];
        
        
    }else if (_cardType == CHARACTERISTIC_TYPE){
        self.scrollView.contentSize = CGSizeMake(0, height+marginL*2);
        self.desLabel.frame = CGRectMake(marginL, marginL, self.frame.size.width-marginL*2, height);
        self.titleLabel.text = model.title;
        if (model.cardType.integerValue == 3) {//best macth 特征
            if ([TTManager sharedInstance].bestMacthType == 0) {
                TTZodiacItemModel *model = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].todayModel.bestMacthModel.loveZodiacIndex.integerValue-1];
                [self.topImgView setImage:[UIImage imageNamed:model.imageName]];
                [self.middleImgV setImage:[UIImage imageNamed:@""]];
                self.timeLabel.text = model.dateString;
            }else if ([TTManager sharedInstance].bestMacthType == 1){
                TTZodiacItemModel *model = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].todayModel.bestMacthModel.friendshipZodiacIndex.integerValue-1];
                [self.topImgView setImage:[UIImage imageNamed:model.imageName]];
                [self.middleImgV setImage:[UIImage imageNamed:@""]];
                self.timeLabel.text = model.dateString;
            }else if ([TTManager sharedInstance].bestMacthType == 2){
                TTZodiacItemModel *model = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].todayModel.bestMacthModel.careerZodiacIndex.integerValue-1];
                [self.topImgView setImage:[UIImage imageNamed:model.imageName]];
                [self.middleImgV setImage:[UIImage imageNamed:@""]];
                self.timeLabel.text = model.dateString;
            }
        }
    }else if (_cardType == FORECAST_TYPE || _cardType == TIPS_TYPE){
        [self.moreL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desLabel.mas_bottom).offset(0*KWIDTH);
            make.centerX.equalTo(self.desLabel);
            
            make.bottom.equalTo(self.btmView).offset(-0*KWIDTH);
        }];
        
        [self.btmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImgView.mas_bottom);
            make.left.right.equalTo(self.topImgView);
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, topH + (height+marginL*2) + 50);
            make.bottom.equalTo(self);
        }];
        
        self.scrollView.contentSize = CGSizeMake(0, height+marginL*2);
        self.desLabel.frame = CGRectMake(marginL, marginL, self.frame.size.width-marginL*2, height);
        [self layoutIfNeeded];
        if (self.cardType == TIPS_TYPE) {
            self.titleLabel.text = model.title;
            self.timeLabel.text = @"";
            NSLog(@"%@",[TTDataHelper readTipsImageStrIndex:model.tipsType.integerValue]);
            [self.middleImgV setImage:[UIImage imageNamed:[TTDataHelper readTipsImageStrIndex:model.tipsType.integerValue]]];
        }
        if (_cardType == FORECAST_TYPE){
            self.moreL.hidden = YES;
        }
        
    }
    
    
    /**
     *    对应首页时间
     */
    
    self.currentTimeL.text = model.title;
    
    XYShowAdAds addss = model.index;
    
    [TTAdHelpr getTitleForType:addss WithComplete:^(XYResultType btnType) {
        self.payBtnType = btnType;
        switch (btnType) {
            case XYResultTypeNotShowBtn:{
                NSLog(@"%ld应该不显示按钮",(long)model.index)
                self.cardType = HOME_TYPE;
                self.moreL.alpha = 1;
                self.subscribeView.hidden = true;
                [self.moreL mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.desLabel.mas_bottom).offset(20*KWIDTH);
                    make.centerX.equalTo(self.desLabel);
                    make.bottom.equalTo(self.btmView).offset(-11*KWIDTH);
                }];
            } break;
            case XYResultTypeShowPlayVideoBtn:{
                [self checkSubLabel:self.subscribeView];
                
                NSLog(@"%ld应该展示看激励视频按钮",(long)model.index)
            }   break;
            case XYResultTypeShowPayBtn://之前有逻辑，不做处理
                NSLog(@"%ld应该展示购买按钮",(long)model.index)
                break;
                
        }
        
    }];
    
    
    //    if (model.index==0) {           //day
    //        self.currentTimeL.text = [self getDateintervalStrWithDays:0];
    //    }else if(model.index==1){       //tomorrow
    //        self.currentTimeL.text = [self getDateintervalStrWithDays:1];
    //    }else if (model.index == 2){    //week
    //        NSString *dateStr = [NSString stringWithFormat:@"%@/%@",[self getDateintervalStrWithDays:0],[self getFirstAndLastDayOfThisWeek].lastObject];
    //        self.currentTimeL.text = dateStr;
    //    }else if (model.index == 3){    //month
    //        NSDate *date = [NSDate date];
    //        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    //        forMatter.locale = self.locale;
    //        [forMatter setDateFormat:@"MMMM,yyyy"];
    //        NSString *dateStr = [forMatter stringFromDate:date];
    //        self.currentTimeL.text = dateStr;
    //    }else if (model.index == 4){    //year
    //        NSDate *date = [NSDate date];
    //        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    //        forMatter.locale = self.locale;
    //        [forMatter setDateFormat:@"yyyy"];
    //        NSString *dateStr = [forMatter stringFromDate:date];
    //        self.currentTimeL.text = dateStr;
    //    }
    
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

- (void)clickMoreLabel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(luckCardViewDidClickMoreBtnWithModel:)]) {
        [self.delegate luckCardViewDidClickMoreBtnWithModel:self.model];
    }
}

- (UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc]init];
        _topImgView.frame = CGRectMake(0, 0, self.bounds.size.width, topImgH);//1000 / 400
        [_topImgView setImage:[UIImage imageNamed:@"homeCard_插图"]];
    }
    return _topImgView;
}

- (UIView *)btmView{
    if (!_btmView) {
        _btmView = [[UIView alloc]init];
        _btmView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        _btmView.frame = CGRectMake(0, topImgH, self.bounds.size.width, self.bounds.size.height-topImgH);
    }
    return _btmView;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.frame = CGRectMake(10, 10, self.btmView.bounds.size.width-20, self.btmView.bounds.size.height-20);
        _desLabel.textColor = [UIColor colorWithHex:0x333333];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        //        if (_cardType == AFTER_TYPE || _cardType == HOME_TYPE) {
        //            _desLabel.numberOfLines = 5;
        //        }else{
        //            _desLabel.numberOfLines = 0;
        //        }
        if (_cardType == HOME_TYPE) {
            _desLabel.numberOfLines = 3;
        }else if (_cardType == AFTER_TYPE){
            _desLabel.numberOfLines = 2;
        }else{
            _desLabel.numberOfLines = 0;
        }
        _desLabel.font = kFontTitle_L_14;//[UIFont systemFontOfSize:14*KWIDTH];//
        _desLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _desLabel;
}

#define ballW 70.0
- (UIImageView *)ballImgV{
    if (!_ballImgV ) {
        UIImage *image;
        if (self.cardType == HOME_TYPE || self.cardType == FORECAST_TYPE || self.cardType == AFTER_TYPE) {
            image = [UIImage imageNamed:[TTManager sharedInstance].itemModel.imageName];
            _ballImgV = [[UIImageView alloc]initWithImage:image];
            _ballImgV.frame = CGRectMake(0, 0, topW, topH);
        }else if (self.cardType == CHARACTERISTIC_TYPE){
            TTZodiacItemModel* model = [TTManager sharedInstance].itemModel;
            //
            //            XYZodiacItemModel *model = [XYManager sharedInstance].localDataManager.zodiacSignModels[[XYManager sharedInstance].todayModel.bestMacthModel.loveZodiacIndex.integerValue-1];
            [self.topImgView setImage:[UIImage imageNamed:model.imageName]];
            [self.middleImgV setImage:[UIImage imageNamed:@""]];
            
            
            image = [UIImage imageNamed:@""];
            _ballImgV = [[UIImageView alloc]initWithImage:image];
            
            _ballImgV.frame = CGRectMake(0, 0, topW, topH);
        }else if(self.cardType == TIPS_TYPE){
            image = [UIImage imageNamed:@"插图 水晶球"];
            _ballImgV = [[UIImageView alloc]initWithImage:image];
            //            _ballImgV.frame = CGRectMake(0, 0, ballW*KWIDTH, ballW*KWIDTH);
            _ballImgV.frame = CGRectMake(0, 0, topW, topH);
        }
        
        //        _ballImgV.frame = CGRectMake(0, 0, 460*0.25*KWIDTH, 640*0.25*KWIDTH);
        //        _ballImgV.center = CGPointMake(self.topImgView.frame.size.width*0.5, self.topImgView.frame.size.height*0.5);
    }
    return _ballImgV;
}

#define middleW 40.0
- (UIImageView *)middleImgV{
    if (!_middleImgV ) {
        UIImage *image;
        if (self.cardType == HOME_TYPE || self.cardType == FORECAST_TYPE || self.cardType == AFTER_TYPE) {
            // image = [UIImage imageNamed:[XYManager sharedInstance].itemModel.imageName];
            _middleImgV = [[UIImageView alloc]initWithImage:image];
        }else if (self.cardType == CHARACTERISTIC_TYPE){
//            XYManager *manager = [XYManager sharedInstance];
            image = [UIImage imageNamed:[TTManager sharedInstance].itemModel.titleImageName];
            _middleImgV = [[UIImageView alloc]initWithImage:image];
            _middleImgV.frame = CGRectMake(0, 0, middleW*KWIDTH, middleW*KWIDTH);
        }else if (self.cardType == TIPS_TYPE){
            //            image = [UIImage imageNamed:[XYManager sharedInstance].itemModel.titleImageName];
            //            image = [UIImage imageNamed:[XYDataHelper readTipsImageStrIndex:<#(NSInteger)#>]]
            _middleImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图标 插图里 爱情tips"]];
            _middleImgV.frame = CGRectMake(0, 0, middleW*KWIDTH, middleW*KWIDTH);
        }
        //        _middleImgV = [[UIImageView alloc]initWithImage:image];
        _middleImgV.center = CGPointMake(self.ballImgV.frame.size.width*0.5, self.ballImgV.frame.size.height*0.5);
    }
    return _middleImgV;
}

- (UILabel *)moreL{
    if (!_moreL) {
        NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:@"More＞"];
//        [muStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 5)];
        _moreL = [[UILabel alloc]init];
        _moreL.textAlignment = NSTextAlignmentCenter;
        _moreL.alpha = 0;
        _moreL.textColor = [UIColor colorWithHex:0x333333];
        _moreL.attributedText = muStr;
        _moreL.font = kFontTitle_L_15;//Font_HB(15);
        _moreL.userInteractionEnabled = YES;
        [_moreL addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMoreLabel)]];
    }
    return _moreL;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = kFontTitle_M_15;// Font_HB(15);
        _titleLabel.text = @"Love Tips Today";
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"06/21~07/22";
        _timeLabel.font = kFontTitle_L_14;//[UIFont systemFontOfSize:14*KWIDTH];
        _timeLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _timeLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)currentTimeL{
    if (!_currentTimeL) {
        _currentTimeL = [[UILabel alloc]init];
        NSDate *date = [NSDate date]; // 获得时间对象
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"MMMM d,yyyy"];// yyyy-MM-dd
        NSString *dateStr = [forMatter stringFromDate:date];
        _currentTimeL.text = dateStr;
        _currentTimeL.font = kFontTitle_L_13;//Font_HB(13*KWIDTH);
        _currentTimeL.textColor = [UIColor colorWithHex:0x333333];
    }
    return _currentTimeL;
}

- (CGFloat)heightViewWithStr:(NSAttributedString *)str{
    //    CGFloat height = [UIView getHeightByWidth:topW-marginL*2 title:str font:self.desLabel.font];
    //  CGFloat height = [UIView getHeightByWidth:self.frame.size.width-marginL*2 title:str font:self.desLabel.font];
    CGFloat height = [UIView getHeightAttributeByWidth:self.frame.size.width-marginL*2 attTitle:str font:self.desLabel.font];
    
    //    NSLog(@"%f",height);
    return height;
}

- (UIView *)createSubscribeBtnView{
    UIView *view = [[UIView alloc]init];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = COLOR_BTN;
    
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bt_fangxing"]];
    backImage.tag = 1;
    [view addSubview:backImage];
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
    label.font = kFontTitle_M_13;//[UIFont boldSystemFontOfSize:13*KWIDTH];
    [cView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(cView);
        make.centerY.equalTo(imageView);
    }];
    label.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setSelectedVC)]];
    return view;
}

- (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *) text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= lineSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace; //设置行间距
    paragraphStyle.firstLineHeadIndent = 0;//设置第一行缩进
    NSDictionary*attriDict =@{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attriDict];
    
    return attributedString;
}

- (void)setSelectedVC{
    switch (self.payBtnType) {
        case XYResultTypeShowPlayVideoBtn:{
            NSLog(@"需要展示激励视频，展示完毕后把More展示出来")
    
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifiClickHomeCellVideoBtn object:nil userInfo:@{@"videoType":@(self.model.index)}];
            break;
        case XYResultTypeShowPayBtn:{
            [[XYLogManager shareManager] addLogKey1:@"home" key2:@"premiumClick" content:nil userInfo:nil upload:NO];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedVC" object:@{@"className":@"TTVipPaymentController", @"image":@"图标 底导航 付费 激活态", @"title":@"Get Premium" ,@"value":@"", @"title":@""}];
            
        }break;
        default:
            break;
    }
  }
}

- (void)luckRefreshVipStatus{
    if (_model.index == 0 || _cardType == HOME_TYPE) return;
    //
    [self.subscribeView removeFromSuperview];
    self.moreL.alpha = 1;
    [self.moreL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(20*KWIDTH);
        make.centerX.equalTo(self.desLabel);
        make.bottom.equalTo(self.btmView).offset(-25*KWIDTH);
    }];
    
    [self layoutIfNeeded];
    //    make.top.equalTo(self.desLabel.mas_bottom).offset(12*KWIDTH);
    //    make.centerX.equalTo(self.desLabel);
    //    make.width.equalTo(self.btmView).offset(-20*KWIDTH);
    //    make.height.offset(50*KWIDTH);
    //    make.bottom.equalTo(self.btmView).offset(-10*KWIDTH);
    
    /*
     make.top.equalTo(self.desLabel.mas_bottom).offset(20*KWIDTH);
     make.centerX.equalTo(self.desLabel);
     if (weakself.cardType != AFTER_TYPE) {
     make.height.offset(0);
     }
     make.bottom.equalTo(self.btmView).offset(-20*KWIDTH);
     */
    
}

- (NSString *)getDateintervalStrWithDays:(NSInteger)days{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    forMatter.locale = self.locale;
    NSTimeInterval  interval =24*60*60*days; //1:天数
    NSDate*date1 = [date initWithTimeIntervalSinceNow:+interval];
    
    [forMatter setDateFormat:@"MMMM d,yyyy"];// yyyy-MM-dd
    NSString *dateStr = [forMatter stringFromDate:date1];
    return dateStr;
}

- (NSArray *)getFirstAndLastDayOfThisWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else {
        firstDiff =  - weekday + 2;
        lastDiff = 8 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    
    NSDateComponents *lastComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [lastComponents setDay:day+lastDiff];
    NSDate *lastDay = [calendar dateFromComponents:lastComponents];
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    forMatter.locale = self.locale;
    [forMatter setDateFormat:@"MMMM d,yyyy"];
    return [NSArray arrayWithObjects:firstDay,[forMatter stringFromDate:lastDay], nil];
}

@end
