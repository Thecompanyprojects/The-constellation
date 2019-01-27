//
//  XYCompResultViewController.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/30.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTCompResultViewController : TTBaseViewController
- (instancetype)initWithLeftGender:(BOOL)isFemale_left rightGender:(BOOL)isFemale_right leftZodiac:(TTZodiacItemModel *)leftModel rightZodiac:(TTZodiacItemModel *)rightModel;
@end
