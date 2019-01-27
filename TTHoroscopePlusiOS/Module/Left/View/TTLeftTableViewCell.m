//
//  XYLeftTableViewCell.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTLeftTableViewCell.h"

@implementation TTLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
