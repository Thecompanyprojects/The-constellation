//
//  XYForecastViewController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseViewController.h"
#import "TTHoroscopeModel.h"

@interface TTForecastViewController : TTBaseViewController

- (instancetype)initWithType:(NSInteger)type model:(TTHoroscopeModel *)model;

@end
