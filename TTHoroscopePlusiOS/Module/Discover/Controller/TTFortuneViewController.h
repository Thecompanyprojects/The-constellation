//
//  XYFortuneViewController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseViewController.h"

typedef enum : NSUInteger {
    LUCKY_COLOR_TYPE,
    LUCKY_NUMBER_TYPE,
    BENEFACTOR_TYPE,
} XYFortuneLuckType;

@interface TTFortuneViewController : TTBaseViewController

@property (nonatomic, assign) XYFortuneLuckType luckType;

- (instancetype)initWithType:(XYFortuneLuckType)type;

@end
