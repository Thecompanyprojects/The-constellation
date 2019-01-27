//
//  VipTitleView.m
//  Horoscope
//
//  Created by KevinXu on 2018/9/11.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTVipTitleView.h"

@interface TTVipTitleView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TTVipTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *temp = [UIImage imageNamed:@"dingyue"];
        UIImage *dingyuebg = [temp resizableImageWithCapInsets:UIEdgeInsetsMake(temp.size.height * 0.5, 0, temp.size.height * 0.5 - 1, 0) resizingMode:UIImageResizingModeStretch];
    self.bgImageView.image = dingyuebg;
    
    NSDictionary *subinfo = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"][@"subscribe"];
    
    NSString *bigtltle_str = subinfo[@"title_big"];
    if (!bigtltle_str) {
        bigtltle_str = @"Much more than just a daily horoscope";
    }
    
    _bigTitleLabel.text = bigtltle_str;
    
    NSString *title_str = subinfo[@"title"];
    if (!title_str) {
        title_str = @"Detailed future prediction.\nDaily Premium contents.\nAds-free experience.";
    }
    NSArray *titleArray = [title_str componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        NSString *str = titleArray[i];
        NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
        attchment.image = [UIImage imageNamed:@"duihao"];
        attchment.bounds = CGRectMake(0, 0, 12, 12);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attchment];
        [strM appendAttributedString:imageStr];
        [strM yy_appendString:@"  "];
        [strM yy_appendString:str];
        if (i < titleArray.count - 1) {
            [strM yy_appendString:@"\n"];
        }
    }
    
    NSString *color_str = subinfo[@"title_color"];
    if (!color_str) {
        color_str = @"333333";
    }
    
    UIColor *titleColor = [UIColor colorWithHexString:color_str];
    
    NSNumber *titleAlpha = subinfo[@"title_alpha"];
    if (!titleAlpha) {
        titleAlpha = @(1);
    }
    
    strM.yy_font = kFontRegular(15);
    strM.yy_color = titleColor;
    strM.yy_lineSpacing = 12;
    
    _titleLabel.attributedText = strM;
    
    
    
}

@end
