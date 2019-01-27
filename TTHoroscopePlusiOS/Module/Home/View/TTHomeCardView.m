//
//  XYLuckCardView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHomeCardView.h"
#define topImgH (self.bounds.size.width/1000*400)
#define margin 20.0

@interface TTHomeCardView ()
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
@property (nonatomic, strong) UIButton *subscribeBtn;
@property (nonatomic, assign) XYHomeCardViewTpye cardType; //0
@end

@implementation TTHomeCardView

//- (instancetype)initWithFrame:(CGRect)frame model:(XYHoroscopeModel *)model{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _model = model;
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame cardType:(XYHomeCardViewTpye)cardType{
    self = [super initWithFrame:frame];
    if (self) {
        _cardType = cardType;
        [self testUI];
    }
    return self;
}

//#define topW (335.0*KWIDTH)
#define topW (self.frame.size.width)
#define topH (topW/1000*400)
#define marginL 10.0
#define maxH 70.0

- (void)testUI{
    //    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    __weak typeof(self) weakself = self;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
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
        make.bottom.equalTo(self.topImgView).offset(-10);
        make.left.equalTo(self.topImgView).offset(10);
        make.right.lessThanOrEqualTo(self.topImgView).offset(-20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-5);
    }];
    
    [self addSubview:self.btmView];
    [self.btmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImgView.mas_bottom);
        make.left.right.equalTo(self.topImgView);
        make.bottom.equalTo(self);
    }];
    
    if (_cardType == _CHARACTERISTIC_TYPE) {
        [self.btmView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.btmView);
        }];
        [self.scrollView addSubview:self.desLabel];

    }else if (_cardType == _HOME_TYPE){
        [self.btmView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.btmView).offset(10);
            make.right.equalTo(self.btmView).offset(-10);
            //            if (weakself.cardType == HOME_TYPE) {
//            make.height.mas_lessThanOrEqualTo(maxH);
            //            }
        }];
    }else if (_cardType == _FORECAST_TYPE || _cardType == _TIPS_TYPE){
        [self.btmView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.btmView);
            //            make.top.left.right.equalTo(self.btmView);

        }];
        [self.scrollView addSubview:self.desLabel];
    }else if (_cardType == _AFTER_TYPE){
        [self.btmView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.btmView).offset(10);
            make.right.equalTo(self.btmView).offset(-10);
        }];
        
        UIView *subscribeView = [self createSubscribeBtnView];
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
        make.top.equalTo(self.desLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.desLabel);
        make.height.offset(0);
        if (weakself.cardType != _AFTER_TYPE) {
            make.bottom.equalTo(self.btmView).offset(-10);
        }
    }];
}

- (void)setHomeUI{
    
    
    
}

- (void)setModel:(TTHoroscopeModel *)model{
    _model = model;
    self.desLabel.text = model.content;
    self.titleLabel.text = [TTManager sharedInstance].itemModel.zodiacName;
    self.timeLabel.text = [TTManager sharedInstance].itemModel.dateString;
    CGFloat height = [self heightViewWithStr:model.content];
    
    if ( _cardType == _HOME_TYPE) {
        self.moreL.alpha = 1;
        [self.moreL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.desLabel);
            make.bottom.equalTo(self.btmView).offset(-15);
        }];
    }else if (_cardType == _CHARACTERISTIC_TYPE){
        self.scrollView.contentSize = CGSizeMake(0, height+marginL*2);
        self.desLabel.frame = CGRectMake(marginL, marginL, self.frame.size.width-marginL*2, height);
    }else if (_cardType == _FORECAST_TYPE || _cardType == _TIPS_TYPE){
        //        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.top.left.right.equalTo(self.btmView);
        //            if (self.bounds.size.height - topH < (height+marginL*2)) {
        //                make.height.offset(self.bounds.size.height - topH);
        //            }else{
        //                make.height.offset(height+marginL*2);
        //            }
        //            make.bottom.equalTo(self.btmView);
        //        }];
        
        [self.btmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImgView.mas_bottom);
            make.left.right.equalTo(self.topImgView);
            //            if (self.bounds.size.height - topH < (height+marginL*2)) {
            //                make.height.offset(self.bounds.size.height - topH);
            //            }else{
            //                make.height.offset(height+marginL*2);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, topH + (height+marginL*2));
            //            }
            make.bottom.equalTo(self);
        }];
        
        self.scrollView.contentSize = CGSizeMake(0, height+marginL*2);
        self.desLabel.frame = CGRectMake(marginL, marginL, self.frame.size.width-marginL*2, height);
        [self layoutIfNeeded];
        //        self.backgroundColor = [UIColor clearColor];
        if (self.cardType == _TIPS_TYPE) {
            self.titleLabel.text = model.title;
            self.timeLabel.text = @"";
            NSLog(@"%@",[TTDataHelper readTipsImageStrIndex:model.tipsType.integerValue]);
            [self.middleImgV setImage:[UIImage imageNamed:[TTDataHelper readTipsImageStrIndex:model.tipsType.integerValue]]];
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
        [_topImgView setImage:[UIImage imageNamed:@"card_top_ picture"]];
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
        _desLabel.textColor = [UIColor whiteColor];
        if (_cardType == _HOME_TYPE || _cardType == _AFTER_TYPE) {
            _desLabel.numberOfLines = 4;
        }else{
            _desLabel.numberOfLines = 0;
        }
        _desLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];//
        _desLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _desLabel;
}

#define ballW 80.0
- (UIImageView *)ballImgV{
    if (!_ballImgV ) {
        UIImage *image;
        if (self.cardType == _HOME_TYPE || self.cardType == _FORECAST_TYPE || self.cardType == _AFTER_TYPE) {
            image = [UIImage imageNamed:[TTManager sharedInstance].itemModel.imageName];
            _ballImgV = [[UIImageView alloc]initWithImage:image];
            _ballImgV.frame = CGRectMake(0, 0, 460*0.17*KWIDTH, 640*0.17*KWIDTH);
        }else if (self.cardType == _CHARACTERISTIC_TYPE){
            //   image = [UIImage imageNamed:[XYManager sharedInstance].itemModel.titleImageName];
            image = [UIImage imageNamed:@"插图 水晶球"];
            _ballImgV = [[UIImageView alloc]initWithImage:image];
            _ballImgV.frame = CGRectMake(0, 0, ballW*KWIDTH, ballW*KWIDTH);
        }else if(self.cardType == _TIPS_TYPE){
            image = [UIImage imageNamed:@"插图 水晶球"];
            _ballImgV = [[UIImageView alloc]initWithImage:image];
            _ballImgV.frame = CGRectMake(0, 0, ballW*KWIDTH, ballW*KWIDTH);
        }
        
        //        _ballImgV.frame = CGRectMake(0, 0, 460*0.25*KWIDTH, 640*0.25*KWIDTH);
        _ballImgV.center = CGPointMake(self.topImgView.frame.size.width*0.5, self.topImgView.frame.size.height*0.5);
    }
    return _ballImgV;
}

#define middleW 40.0
- (UIImageView *)middleImgV{
    if (!_middleImgV ) {
        UIImage *image;
        if (self.cardType == _HOME_TYPE || self.cardType == _FORECAST_TYPE || self.cardType == _AFTER_TYPE) {
            // image = [UIImage imageNamed:[XYManager sharedInstance].itemModel.imageName];
            _middleImgV = [[UIImageView alloc]initWithImage:image];
        }else if (self.cardType == _CHARACTERISTIC_TYPE){
            image = [UIImage imageNamed:[TTManager sharedInstance].itemModel.titleImageName];
            _middleImgV = [[UIImageView alloc]initWithImage:image];
            _middleImgV.frame = CGRectMake(0, 0, middleW*KWIDTH, middleW*KWIDTH);
        }else if (self.cardType == _TIPS_TYPE){
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
        NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:@"More ＞"];
        [muStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 6)];
        _moreL = [[UILabel alloc]init];
        _moreL.textAlignment = NSTextAlignmentCenter;
        _moreL.alpha = 0;
        _moreL.textColor = [UIColor whiteColor];
        _moreL.attributedText = muStr;
        _moreL.font = kFontTitle_M_15;//Font_HB(15);
        _moreL.userInteractionEnabled = YES;
        [_moreL addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMoreLabel)]];
    }
    return _moreL;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = kFontTitle_M_15;//Font_HB(15);
        _titleLabel.text = @"Love Tips Today";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"06/21~07/22";
        _timeLabel.font = kFontTitle_L_15;//[UIFont systemFontOfSize:15];
        _timeLabel.textColor = [UIColor whiteColor];
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

- (UIButton *)subscribeBtn{
    if (!_subscribeBtn) {
        _subscribeBtn = [[UIButton alloc]init];
        _subscribeBtn.layer.masksToBounds = YES;
        _subscribeBtn.layer.cornerRadius = 5;
        [_subscribeBtn setImage:[UIImage imageNamed:@"小图标 引导付费钻石"] forState:UIControlStateNormal];
        [_subscribeBtn setBackgroundImage:[UIImage imageNamed:@"bt_fangxing"] forState:UIControlStateNormal];
        [_subscribeBtn setTitle:@"View full prediction with premium" forState:UIControlStateNormal];
        _subscribeBtn.titleLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _subscribeBtn.titleLabel.textColor = [UIColor whiteColor];
        _subscribeBtn.backgroundColor = COLOR_BTN;
        
    }
    return _subscribeBtn;
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
        make.width.height.offset(35*KWIDTH);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"View full prediction with premium";
    label.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    [cView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(cView);
        make.centerY.equalTo(imageView);
    }];
    return view;
}

- (CGFloat)heightViewWithStr:(NSString *)str{
    //    CGFloat height = [UIView getHeightByWidth:topW-marginL*2 title:str font:self.desLabel.font];
    CGFloat height = [UIView getHeightByWidth:self.frame.size.width-marginL*2 title:str font:self.desLabel.font];
    //    NSLog(@"%f",height);
    return height;
}

@end
