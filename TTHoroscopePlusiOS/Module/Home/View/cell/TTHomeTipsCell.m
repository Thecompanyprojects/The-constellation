//
//  XYHomeTipsCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHomeTipsCell.h"
#import "TTLuckCardView.h"

@interface TTHomeTipsCell ()
@property (nonatomic, weak) TTLuckCardView *cardView;
@end

@implementation TTHomeTipsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
//    XYLuckCardView *cardView = [[XYLuckCardView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) cardType:FORECAST_TYPE];
    TTLuckCardView *cardView = [[TTLuckCardView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, KScreenWidth-LEFT_MARGIN*2, 300) cardType:TIPS_TYPE];
    self.cardView = cardView;
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(TOP_MARGIN);
        make.bottom.equalTo(self.contentView).offset(-TOP_MARGIN);
        make.right.equalTo(self.contentView).offset(-LEFT_MARGIN);
        make.left.equalTo(self.contentView).offset(LEFT_MARGIN);
    }];
}

- (void)setModel:(XYTipsModel *)model{
    _model = model;
    self.cardView.model = (TTHoroscopeModel *)model;
}

@end
