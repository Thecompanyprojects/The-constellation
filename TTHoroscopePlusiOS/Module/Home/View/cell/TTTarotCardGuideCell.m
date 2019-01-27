//
//  XYTarotCardGuideCell.m
//  Horoscope
//
//  Created by KevinXu on 2018/9/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotCardGuideCell.h"

@interface TTTarotCardGuideCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *l;
@property (nonatomic, strong) UIButton *l2;
@end
@implementation TTTarotCardGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"kaluopai"];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(TOP_MARGIN, LEFT_MARGIN, TOP_MARGIN, LEFT_MARGIN));
//        make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(0.56);

        make.width.mas_equalTo(KScreenWidth - LEFT_MARGIN*2);
        make.centerX.mas_equalTo(self.contentView);
        
        make.top.mas_equalTo(self.contentView).offset(TOP_MARGIN);
        NSInteger height = (KScreenWidth - LEFT_MARGIN*2) * 0.428;
        make.height.mas_equalTo(height);
        make.bottom.mas_equalTo(self.contentView).offset(-TOP_MARGIN);
    }];
    
    self.l = [[UILabel alloc]init];
    self.l.textColor = [UIColor colorWithHex:0xf3f3f3];
    self.l.text = @"Tarot Reading";
    self.l.textAlignment = NSTextAlignmentLeft;
    [self.l sizeToFit];
    self.l.font = kFontMedium(19);
    [self.contentView addSubview:self.l];
    
    [self.l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView).offset(-16);
    }];
    
    self.l2 = [UIButton new];
    self.l2.backgroundColor = [UIColor whiteColor];
    
    self.l2.titleLabel.font = kFontMedium(14);
    [self.l2 setTitle:@"  View>  " forState:UIControlStateNormal];
    self.l2.userInteractionEnabled = NO;
    self.l2.layer.masksToBounds = true;
    self.l2.layer.cornerRadius = 14;
    
    [self.l2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.l2];
    [self.l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.l);
        make.top.mas_equalTo(self.l.mas_bottom).offset(10);
    }];
    
    
    
    
}

@end
