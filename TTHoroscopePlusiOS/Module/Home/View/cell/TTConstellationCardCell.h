//
//  XYConstellationCardCell.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHoroscopeModel.h"

@protocol XYConstellationCardCellDelegate <NSObject>

- (void)cardCellDidClickMoreBtnWithModel:(TTHoroscopeModel *)model;

@end

@interface TTConstellationCardCell : UITableViewCell

@property (nonatomic, weak) id<XYConstellationCardCellDelegate>delegate;

@property (nonatomic, strong) TTHoroscopeModel *model;


@end
