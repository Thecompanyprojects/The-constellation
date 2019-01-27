//
//  XYTodayView.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHoroscopeModel.h"

@protocol XYTodayViewDelegate <NSObject>

@optional
- (void)todayViewDidClickMoreBtnWithModel:(TTHoroscopeModel *)model;
- (void)todayPushWebViewWithModel:(TTNewsModel *)model;
- (void)todayViewDidClickPayVipCardWithModel:(TTBaseModel *)model;
- (void)todayViewDidClickModel:(TTBaseModel *)model;

@end


@interface TTodayView : UIView

@property (nonatomic, weak) id<XYTodayViewDelegate>delegate;

@property (nonatomic, strong) XYDayModel *model;



- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger )type;
- (void)dayViewRefreshVipStatus;

@end
