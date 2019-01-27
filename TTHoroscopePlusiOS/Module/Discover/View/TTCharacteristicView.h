//
//  XYCharacteristicView.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTCharacteristicView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void (^pageChanged)(NSInteger page);

@property (nonatomic, assign) NSInteger bestMacthType;
@end
