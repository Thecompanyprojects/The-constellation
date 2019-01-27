//
//  XYHtmlListLabelView.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/6.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHtmlTableViewModel.h"
@interface TTHtmlListLabelView : UIView
@property (nonatomic, strong)UILabel* label;
@property (nonatomic, strong)TTHtmlTableViewModel* model;
- (instancetype)initWithModel:(TTHtmlTableViewModel *)model;
@end
