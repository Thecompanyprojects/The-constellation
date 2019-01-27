//
//  XYCompResultCardView.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/1.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"
@interface XYCompResultCardView : UIView
@property (nonatomic, strong)UAProgressView* progressView;
@property (nonatomic, strong)UILabel* titleLb;
@property (nonatomic, strong)UILabel* subTitleLb;
@property (nonatomic, strong)UILabel* contentLb;
@property (nonatomic, strong)UIView* container;

@end
