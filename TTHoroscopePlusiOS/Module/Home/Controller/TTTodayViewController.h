//
//  XYTodayViewController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseViewController.h"
#import "TTHoroscopeModel.h"



@interface TTTodayViewController : TTBaseViewController

@property (nonatomic, strong) XYDayModel *model;

// type 是否有购买,0无,1有
- (instancetype)initWithType:(NSInteger)type;

@end
