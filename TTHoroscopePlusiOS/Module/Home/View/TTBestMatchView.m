//
//  XYBestMatchView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBestMatchView.h"

#define friendsTag 10000
#define loveTag 10001
#define careerTag 10002

@interface TTBestMatchView ()
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation TTBestMatchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 5;
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    
    UIView *topLine = [UIView new];
    [self addSubview:topLine];
    topLine.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    TTBestMacthModel *model = [TTManager sharedInstance].todayModel.bestMacthModel;
    TTZodiacItemModel *friendsModel = [TTManager sharedInstance].localDataManager.zodiacSignModels[model.friendshipZodiacIndex.integerValue-1];
    TTZodiacItemModel *loveModel = [TTManager sharedInstance].localDataManager.zodiacSignModels[model.loveZodiacIndex.integerValue-1];
    TTZodiacItemModel *careerModel = [TTManager sharedInstance].localDataManager.zodiacSignModels[model.careerZodiacIndex.integerValue-1];
    
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18*KWIDTH);
        make.left.equalTo(self).offset(15);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-20);
    }];
    
    TTZodiacItemModel *fmodel = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].todayModel.bestMacthModel.friendshipZodiacIndex.integerValue-1];
    UIView *friendsV = [self createViewWithColor:[UIColor redColor] title:@"Friendship" subTitle:friendsModel.zodiacName image:[UIImage imageNamed:@"大图标 匹配 友情"] macthImage:[UIImage imageNamed:fmodel.titleImageName] macthColor:[UIColor colorWithHex:0x29B6F6]];
    friendsV.tag = friendsTag;
    [self addSubview:friendsV];
    [friendsV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMacthView:)]];
    [friendsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleL.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.width.offset(100);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    TTZodiacItemModel *lmodel = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].todayModel.bestMacthModel.loveZodiacIndex.integerValue-1];
    UIView *loveV = [self createViewWithColor:[UIColor redColor] title:@"Love" subTitle:loveModel.zodiacName image:[UIImage imageNamed:@"大图标 匹配 爱情"] macthImage:[UIImage imageNamed:lmodel.titleImageName] macthColor:[UIColor colorWithHex:0xEC407A]];
    loveV.tag = loveTag;
    [self addSubview:loveV];
    [loveV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMacthView:)]];
    [loveV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(friendsV);
//        make.width.equalTo(friendsV);
        make.right.equalTo(friendsV.mas_left).offset(-30);
        make.left.equalTo(self).offset(30);
    }];
    
    TTZodiacItemModel *cmodel = [TTManager sharedInstance].localDataManager.zodiacSignModels[[TTManager sharedInstance].todayModel.bestMacthModel.careerZodiacIndex.integerValue-1];
    UIView *careerV = [self createViewWithColor:[UIColor redColor] title:@"Career" subTitle:careerModel.zodiacName image:[UIImage imageNamed:@"大图标 匹配 事业"] macthImage:[UIImage imageNamed:cmodel.titleImageName] macthColor:[UIColor colorWithHex:0xFFB300]];
    careerV.tag = careerTag;
    [self addSubview:careerV];
    [careerV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMacthView:)]];
    [careerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loveV);
        make.width.equalTo(loveV);
        make.left.equalTo(friendsV.mas_right).offset(30);
//        make.right.equalTo(self).offset(30);
    }];
}

- (UIView *)createViewWithColor:(UIColor *)color title:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image macthImage:(UIImage *)macthImage macthColor:(UIColor *)macthColor{
    UIView *view = [[UIView alloc]init];
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.textColor = macthColor;
    titlelabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    titlelabel.text = title;
    [view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
  //  imageView.backgroundColor = [UIColor redColor];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlelabel.mas_bottom).offset(10);
        make.centerX.equalTo(view);
        make.width.offset(48.3*KWIDTH);
        make.height.offset(43.3*KWIDTH);
    }];
    
    UIView *macthView = [[UIView alloc]init];
    macthView.backgroundColor = macthColor;
    macthView.layer.masksToBounds = YES;
    macthView.layer.borderWidth = 2;
    macthView.layer.borderColor = [UIColor whiteColor].CGColor;
    macthView.layer.cornerRadius = 15*KWIDTH;
    [view addSubview:macthView];
    [macthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView).offset(2*KWIDTH);
        make.right.equalTo(imageView).offset(7*KWIDTH);
        make.width.height.offset(28*KWIDTH);
    }];
    
    UIImageView *macthImgV = [[UIImageView alloc]initWithImage:macthImage];
    
    [macthView addSubview:macthImgV];
    [macthImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(macthView);
        make.width.height.offset(20*KWIDTH);
    }];
    
    UILabel *subTitleL = [[UILabel alloc]init];
    subTitleL.textColor = [UIColor colorWithHex:0x333333];
    subTitleL.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    subTitleL.text = subTitle;
    [view addSubview:subTitleL];
    [subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10*KHEIGHT);
        make.bottom.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    return view;
}

- (void)clickMacthView:(UITapGestureRecognizer *)sender{
    if (sender.view.tag == loveTag) {
        [[TTManager sharedInstance] bestMacthDidClickWithType:0];
    }else if(sender.view.tag == friendsTag){
        [[TTManager sharedInstance] bestMacthDidClickWithType:1];
    }else if (sender.view.tag == careerTag){
        [[TTManager sharedInstance] bestMacthDidClickWithType:2];
    }
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"Today's Best Match";
        _titleL.font = kFontTitle_M_15;//FONT_TITLE_HB;
        _titleL.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleL;
}

@end
