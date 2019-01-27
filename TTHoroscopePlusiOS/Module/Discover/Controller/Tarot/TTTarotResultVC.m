//
//  XYTarotResultVC.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/18.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotResultVC.h"

@interface TTTarotResultVC ()

@property (nonatomic, assign) NSInteger tarotType;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSDictionary *dicData;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TTTarotResultVC

#define pointY (cardHeight*0.5*2+NAV_HEIGHT+20*KHEIGHT)
#define margin 10.0*KWIDTH
#define cardWidth ((KScreenWidth - (4+1) * margin) / 4)
#define cardHeight (cardWidth/360*600)

- (instancetype)initWithTarotType:(NSInteger)tarotType{
    self = [super init];
    if (self) {
        _tarotType = tarotType;
        _arrData = [TTDataHelper readTarotType:@(tarotType).stringValue];
        _dicData = _arrData.firstObject;
        
        switch (tarotType) {
            case 1:self.kTagString = @"daily"; break;
            case 2:self.kTagString = @"love"; break;
            case 3:self.kTagString = @"daily_career"; break;
            case 4:self.kTagString = @"yes/no"; break;
            case 5:self.kTagString = @"love_potential"; break;
            case 6:self.kTagString = @"breakup"; break;
            case 7:self.kTagString = @"daily_flirt"; break;
            default:self.kTagString = @"undefine"; break;
        }
        
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
    [self.baseView addSubview:self.imageV];
    self.imageV.frame = CGRectMake(0, 0, cardWidth*2, cardHeight*2);
    self.imageV.center = CGPointMake(KScreenWidth*0.5,pointY);
    
    [self.baseView addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    self.titleLabel.text = self.dicData[@"cardName"];
    self.titleLabel.frame = CGRectMake(20*KWIDTH, 0, 200*KWIDTH, 30*KWIDTH);
    
    [self.scrollView addSubview:self.contentLabel];
    CGFloat height = [UIView getHeightByWidth:KScreenWidth-40*KWIDTH title:self.dicData[@"cardExplanation"] font:self.contentLabel.font];
    self.contentLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(self.titleLabel.frame), KScreenWidth-40*KWIDTH, height);
    self.contentLabel.text = self.dicData[@"cardExplanation"];
    
    [self.scrollView addSubview:self.tipLabel];
    NSAttributedString *attStr = [self attributeString:[TTDataHelper readTarotTipsString] title:@"Tips:"];
    self.tipLabel.attributedText = attStr;
    CGFloat tipsHeight = [UIView getHeightAttributeByWidth:KScreenWidth-30*KWIDTH attTitle:attStr font:self.tipLabel.font];
    self.tipLabel.frame = CGRectMake(20*KWIDTH, CGRectGetMaxY(self.contentLabel.frame)+20*KHEIGHT, KScreenWidth-30*KWIDTH, tipsHeight+10*KHEIGHT);
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.tipLabel.frame) + 20*KHEIGHT);
}

- (NSAttributedString *)attributeString:(NSString *)string title:(NSString *)title{
    NSMutableAttributedString *muAtt = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",string]];
    [muAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14*KWIDTH] range:NSMakeRange(0, title.length)];
    return muAtt.copy;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _baseView;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        NSNumber *index = self.dicData[@"cardindex"];
        _imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"塔罗 正 %02zd",index.integerValue]]];
    }
    return _imageV;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.imageV.frame)+10*KHEIGHT, KScreenWidth, KScreenHeight - (CGRectGetMaxY(self.imageV.frame)+10*KHEIGHT));
    }
    return _scrollView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = kFontTitle_L_15;//[UIFont systemFontOfSize:15*KWIDTH];
        _titleLabel.textColor = kHexColor(0x333333);//[UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = kHexColor(0x333333);//[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    }
    return _contentLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor blackColor];//[[UIColor whiteColor]colorWithAlphaComponent:1];
    }
    return _tipLabel;
}

@end
