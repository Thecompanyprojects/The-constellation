//
//  XYConstellationCardCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTConstellationCardCell.h"
#import "TTLuckCardView.h"
#import "TTHoroscopeModel.h"
#import "TTHomeCardView.h"

@interface TTConstellationCardCell ()<XYLuckCardViewDelegate,XYHomeCardViewDelegate>
@property (nonatomic, weak) TTLuckCardView *cardView;
@property (nonatomic, weak) TTHomeCardView *homeCardView;
@end

@implementation TTConstellationCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    TTLuckCardView *cardView = [[TTLuckCardView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, KScreenWidth-LEFT_MARGIN*2, 300) cardType:HOME_TYPE];
    cardView.delegate = self;
    self.cardView = cardView;
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
//    XYHomeCardView *cardView = [[XYHomeCardView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, KScreenWidth-LEFT_MARGIN*2, 300) cardType:_AFTER_TYPE];
//    cardView.delegate = self;
//    self.homeCardView = cardView;
//    [self.contentView addSubview:cardView];
//    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//        make.top.equalTo(self.contentView).offset(TOP_MARGIN);
//        make.bottom.equalTo(self.contentView).offset(-TOP_MARGIN);
//    }];
}

- (void)setModel:(TTHoroscopeModel *)model{
    _model = model;
    self.cardView.model = model;
//    self.homeCardView.model = model;
}

- (void)luckCardViewDidClickMoreBtnWithModel:(TTHoroscopeModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardCellDidClickMoreBtnWithModel:)]) {
        [self.delegate cardCellDidClickMoreBtnWithModel:model];
    }
}


@end
