//
//  XYBestMatchCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/25.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBestMatchCell.h"
#import "TTBestMatchView.h"

@implementation TTBestMatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    TTBestMatchView *matchView = [[TTBestMatchView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:matchView];
    [matchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(LEFT_MARGIN);
        make.right.equalTo(self.contentView).offset(-LEFT_MARGIN);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setModel:(TTBestMacthModel *)model{
    _model = model;
}

@end
