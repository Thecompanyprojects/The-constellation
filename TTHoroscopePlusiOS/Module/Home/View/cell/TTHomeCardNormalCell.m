//
//  XYHomeCardNormalCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHomeCardNormalCell.h"
#import "TTLuckCardView.h"
#import "TTHoroscopeModel.h"
#import "TTHomeCardView.h"

@interface TTHomeCardNormalCell ()<XYLuckCardViewDelegate,XYHomeCardViewDelegate>
@property (nonatomic, weak) TTLuckCardView *cardView;
@property (nonatomic, weak) TTHomeCardView *homeCardView;
@end

@implementation TTHomeCardNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    TTLuckCardView *cardView = [[TTLuckCardView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, KScreenWidth-LEFT_MARGIN*2, 300) cardType:AFTER_TYPE];
    cardView.delegate = self;
    self.cardView = cardView;
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-TOP_MARGIN);
        
        
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

- (void)cardCellRefreshVipStatus{
    [self.cardView luckRefreshVipStatus];
}

@end
