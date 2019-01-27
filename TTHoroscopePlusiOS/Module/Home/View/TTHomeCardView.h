//
//  XYLuckCardView.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHoroscopeModel.h"

@protocol XYHomeCardViewDelegate <NSObject>

- (void)luckCardViewDidClickMoreBtnWithModel:(TTHoroscopeModel *)model;

@end

typedef enum : NSUInteger {
    _HOME_TYPE,
    _CHARACTERISTIC_TYPE,
    _FORECAST_TYPE,
    _TIPS_TYPE,
    _AFTER_TYPE,
} XYHomeCardViewTpye;

@interface TTHomeCardView : UIView

@property (nonatomic, weak) id <XYHomeCardViewDelegate>delegate;

@property (nonatomic, strong) TTHoroscopeModel *model;

//- (instancetype)initWithFrame:(CGRect)frame model:(XYHoroscopeModel *)model;

- (instancetype)initWithFrame:(CGRect)frame cardType:(XYHomeCardViewTpye)cardType;

@end
