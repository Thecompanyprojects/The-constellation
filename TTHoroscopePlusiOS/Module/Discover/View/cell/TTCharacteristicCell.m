//
//  XYCharacteristicCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCharacteristicCell.h"
#import "TTLuckCardView.h"

@interface TTCharacteristicCell ()
@property (nonatomic, weak) TTLuckCardView *cardView;
@end

@implementation TTCharacteristicCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    TTLuckCardView *cardView = [[TTLuckCardView alloc]initWithFrame:self.contentView.bounds cardType:CHARACTERISTIC_TYPE];
    self.cardView = cardView;
    [self.contentView addSubview:cardView];
}

- (void)setModel:(TTHoroscopeModel *)model{
    _model = model;
    self.cardView.model = model;
}

@end
