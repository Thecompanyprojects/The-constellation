//
//  XYTarotBreakupResultVC.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/18.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotBreakupResultVC.h"

@interface TTTarotBreakupResultVC ()

@property (nonatomic, assign) NSInteger tarotType;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSDictionary *causeDic;
@property (nonatomic, strong) NSDictionary *adviceDic;

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *causeLabel;
@property (nonatomic, strong) UILabel *adviceLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TTTarotBreakupResultVC

#define cardMargin (40.0*KWIDTH)
#define cardWidth ((KScreenWidth-3*cardMargin)/2)
#define cardHeight (cardWidth / 360 * 600)

- (instancetype)initWithTarotType:(NSInteger)tarotType{
    self = [super init];
    if (self) {
        _tarotType = tarotType;
        _arrData = [TTDataHelper readTarotType:@(tarotType).stringValue];
        _causeDic = _arrData.firstObject;
        _adviceDic = _arrData.lastObject;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    self.title = @"Tarot Readings";
    [self setupUI];
}

- (void)setupUI{
    [self.view addSubview:self.baseView];
    
    NSInteger count = 2;//列
    CGFloat width = cardWidth;
    CGFloat height = cardHeight;
    
    for (int i=0; i<2; i++) {
        NSDictionary *dic = self.arrData[i];
        NSNumber *cardIndex = dic[@"cardindex"];
        NSInteger columnNum = i%count;
        NSInteger rowNum = i/count;
        CGRect rect = CGRectMake((columnNum+1)*cardMargin + columnNum * width, rowNum*height+rowNum*cardMargin + (NAV_HEIGHT + 20*KHEIGHT), width, height);
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"塔罗 正 %02zd",cardIndex.integerValue]]];
        imageView.frame = rect;
        [self.baseView addSubview:imageView];
    }
    
    
    
    [self.baseView addSubview:self.scrollView];
    [self.scrollView addSubview:self.causeLabel];
    [self.scrollView addSubview:self.adviceLabel];
    
    self.causeLabel.attributedText = [self attributeString:self.causeDic[@"cardExplanation"] title:self.causeDic[@"cardName"]];
    self.adviceLabel.attributedText = [self attributeString:self.adviceDic[@"cardExplanation"] title:self.adviceDic[@"cardName"]];
    CGFloat causeHeight = [UIView getHeightAttributeByWidth:KScreenWidth-40*KWIDTH attTitle:self.causeLabel.attributedText font:kFontTitle_L_12];//[UIFont systemFontOfSize:12*KWIDTH]];
    
    CGFloat adviceHeight = [UIView getHeightAttributeByWidth:KScreenWidth-40*KWIDTH attTitle:self.adviceLabel.attributedText font:kFontTitle_L_12];//[UIFont systemFontOfSize:12*KWIDTH]];
    self.causeLabel.xy_height = causeHeight+16*KHEIGHT;
    self.adviceLabel.xy_height = adviceHeight+16*KHEIGHT;
//    self.causeHeight = self.causeLabel.xy_height;
    self.adviceLabel.xy_y = CGRectGetMaxY(self.causeLabel.frame) + 20*KHEIGHT;
    
    
    [self.scrollView addSubview:self.tipLabel];
    NSAttributedString *attStr = [self attributeString:[TTDataHelper readTarotTipsString] title:@"Tips:"];
    self.tipLabel.attributedText = attStr;
    CGFloat tipsHeight = [UIView getHeightAttributeByWidth:KScreenWidth-30*KWIDTH attTitle:attStr font:self.tipLabel.font];
    self.tipLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(self.adviceLabel.frame)+20*KHEIGHT, KScreenWidth-30*KWIDTH, tipsHeight+10*KHEIGHT);
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.tipLabel.frame)+ 60*KHEIGHT);
}

- (NSAttributedString *)attributeString:(NSString *)string title:(NSString *)title{
    NSMutableAttributedString *muAtt = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",string]];
    [muAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14*KWIDTH] range:NSMakeRange(0, title.length)];
    [muAtt addAttribute:NSForegroundColorAttributeName value:kHexColor(0x333333)  range:NSMakeRange(0, title.length)];
    return muAtt.copy;
}

- (UILabel *)causeLabel{
    if (!_causeLabel) {
        _causeLabel = [[UILabel alloc]init];
//        _causeLabel.text = self.titleStr;
        _causeLabel.textColor = kHexColor(0x333333);//[[UIColor whiteColor] colorWithAlphaComponent:0.5];
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
//        _adviceLabel.text = self.titleStr;
        _adviceLabel.textColor = kHexColor(0x333333);//[[UIColor whiteColor] colorWithAlphaComponent:0.5];
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
    }
    return _scrollView;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _baseView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = kHexColor(0x000000);//[[UIColor whiteColor]colorWithAlphaComponent:1];
    }
    return _tipLabel;
}

@end
