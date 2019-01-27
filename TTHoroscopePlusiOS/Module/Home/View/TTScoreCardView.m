//
//  XYScoreCardView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/25.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTScoreCardView.h"

@interface XYStarView : UIView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *starArr;

@end

@implementation XYStarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        UIImageView *starImgV = [[UIImageView alloc]init];
        [starImgV setImage:[UIImage imageNamed:@"小图标 星星 白"]];
        [self addSubview:starImgV];
        [muArr addObject:starImgV];
    }
    self.starArr = muArr;
    for (int i=0; i<muArr.count; i++) {
        UIImageView *imageV = muArr[i];
        if (i==0) {
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self);
                make.width.offset(13.3*KWIDTH);
                make.height.offset(13.3*KWIDTH);
            }];
        }else if(i == muArr.count-1){
            UIImageView *lastImgV = muArr[i-1];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastImgV.mas_right).offset(3*KWIDTH);
                make.top.bottom.equalTo(lastImgV);
                make.right.equalTo(self);
                make.width.height.equalTo(lastImgV);
            }];
        }else{
            UIImageView *lastImgV = muArr[i-1];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastImgV.mas_right).offset(3*KWIDTH);
                make.centerY.equalTo(lastImgV);
                make.width.height.equalTo(lastImgV);
            }];
        }
    }
}

- (void)setCount:(NSInteger)count{
    _count = count;
    for (int i=0; i<self.starArr.count; i++) {
        UIImageView *imagV = self.starArr[i];
        if (i<count) {
            [imagV setImage:[UIImage imageNamed:@"小图标 星星 黄"]];
        }
    }
}

@end












@interface TTScoreCardView ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NSMutableArray *starArr;

@end

@implementation TTScoreCardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    TTScoreModel *model = [TTManager sharedInstance].todayModel.scoreModel;
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.offset(1);
    }];
    
    [self addSubview:self.titleL];
//    NSString *titleStr = [NSString stringWithFormat:@"Today's Overall Rating: %0.1f",model.totalRating.floatValue];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Today's Overall Rating: %0.1f",model.totalRating.floatValue]];
//    NSString *scoreStr = [NSString stringWithFormat:@"%0.1f",model.totalRating.floatValue];
//    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFFB300] range:NSMakeRange(titleStr.length-scoreStr.length, scoreStr.length)];
 
    
    
    self.titleL.attributedText = attStr;
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18*KHEIGHT);
        make.left.equalTo(self).offset(15*KWIDTH);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(18*KHEIGHT);
        make.width.offset(1*KWIDTH);
        make.height.offset(90*KHEIGHT);
    }];
    
    /*
     careerRating = 4;
     loveRating = 4;
     moneyRating = 3;
     moodRating = 3;
     totalRating = "3.5";
     */
    /*
    careerRating = 2;
    familyRating = 5;
    healthRating = 3;
    loveRating = 2;
    marriageRating = 4;
    totalRating = 5;
    wealthRating = 4;
     */
    
    UIView *loveView = [self createStarViewTitleStr:@"Love" starCount:model.loveRating.integerValue];
    [self addSubview:loveView];
    [loveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(lineView.mas_top);//.offset(-3*KWIDTH);
    }];
    
    UIView *starView1 = [self createStarViewTitleStr:@"Health" starCount:model.healthRating.integerValue];
    [self addSubview:starView1];
    [starView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(loveView);
    }];
    
    
    
    UIView *healthView = [self createStarViewTitleStr:@"Familay" starCount:model.familyRating.integerValue];
    [self addSubview:healthView];
    [healthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loveView);
        make.bottom.equalTo(lineView.mas_bottom);//.offset(3*KWIDTH);
    }];

    UIView *view2 = [self createStarViewTitleStr:@"Wealth" starCount:model.wealthRating.integerValue];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(20*KWIDTH);
        make.top.equalTo(lineView.mas_top);//.offset(-3*KWIDTH);
    }];
    
    UIView *view1 = [self createStarViewTitleStr:@"Marriage" starCount:model.marriageRating.integerValue];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(20*KWIDTH);
    }];

    
    
    UIView *view3 = [self createStarViewTitleStr:@"Cancer" starCount:model.careerRating.integerValue];
    [self addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(20*KWIDTH);
        make.bottom.equalTo(lineView.mas_bottom);//.offset(3*KWIDTH);
    }];

    
//    for (int i=0; i<self.starArr.count; i++) {
//        XYStarView *view = self.starArr[i];
//        view.count = i;
//    }
}



- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"Today's Overall Rating: 4.0";
        _titleL.textColor = [UIColor colorWithHex:0x333333];
        _titleL.font = kFontTitle_M_15;//Font_HB(15*KWIDTH);
    }
    return _titleL;
}

- (UIView *)createStarViewTitleStr:(NSString *)titleStr starCount:(NSInteger)starCount{
    
    UIView *baseView = [[UIView alloc]init];

    XYStarView *starView = [[XYStarView alloc]initWithFrame:CGRectZero];
    [baseView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(baseView);
    }];
    [self.starArr addObject:starView];
    starView.count = starCount;
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.text = titleStr;
    titleL.textColor = [UIColor colorWithHex:0x333333];
    [baseView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(starView.mas_left);
        make.width.offset(60*KWIDTH);
        make.centerY.equalTo(starView);
        make.left.equalTo(baseView);
    }];
    
    return baseView;
}

- (UIView *)createStarViewWithNum:(NSInteger)num{
    NSMutableArray *muArr = [NSMutableArray array];
    UIView *baseView = [[UIView alloc]init];
    for (int i=0; i<5; i++) {
        UIImageView *starImgV = [[UIImageView alloc]init];
        if (i<num) {
            [starImgV setImage:[UIImage imageNamed:@"小图标 星星 黄"]];
        }else{
            [starImgV setImage:[UIImage imageNamed:@"小图标 星星 白"]];
        }
        [baseView addSubview:starImgV];
        [muArr addObject:starImgV];
    }
    
    for (int i=0; i<muArr.count; i++) {
        UIImageView *imageV = muArr[i];
        if (i==0) {
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(baseView);
            }];
        }else if(i == muArr.count-1){
            UIImageView *lastImgV = muArr[i-1];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastImgV.mas_right).offset(3*KWIDTH);
                make.top.bottom.equalTo(lastImgV);
                make.right.equalTo(baseView);
            }];
        }else{
            UIImageView *lastImgV = muArr[i-1];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastImgV.mas_right).offset(3*KWIDTH);
                make.centerY.equalTo(lastImgV);
            }];
        }
    }
    return baseView;
}

- (NSMutableArray *)starArr{
    if (!_starArr) {
        _starArr = [NSMutableArray array];
    }
    return _starArr;
}

@end
