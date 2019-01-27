//
//  XYHtmlTableViewCell.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHtmlTableViewCell.h"

@implementation TTHtmlTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.lb = [UILabel new];
    self.lb.numberOfLines = 0;
    [self addSubview:self.lb];
    [self.lb mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];

     self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
