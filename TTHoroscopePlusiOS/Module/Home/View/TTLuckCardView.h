//
//  XYLuckCardView.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHoroscopeModel.h"

@protocol XYLuckCardViewDelegate <NSObject>

- (void)luckCardViewDidClickMoreBtnWithModel:(TTHoroscopeModel *)model;

@end

typedef enum : NSUInteger {
    HOME_TYPE,
    CHARACTERISTIC_TYPE,
    FORECAST_TYPE,
    TIPS_TYPE,
    AFTER_TYPE,
} XYLuckCardViewTpye;

@interface TTLuckCardView : UIView

@property (nonatomic, weak) id <XYLuckCardViewDelegate>delegate;

@property (nonatomic, strong) TTHoroscopeModel *model;

//- (instancetype)initWithFrame:(CGRect)frame model:(XYHoroscopeModel *)model;

- (instancetype)initWithFrame:(CGRect)frame cardType:(XYLuckCardViewTpye)cardType;
- (void)luckRefreshVipStatus;

@end
