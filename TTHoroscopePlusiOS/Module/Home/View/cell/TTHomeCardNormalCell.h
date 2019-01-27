//
//  XYHomeCardNormalCell.h
//  Horoscope
//
//  Created by PanZhi on 2018/5/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTConstellationCardCell.h"

@interface TTHomeCardNormalCell : UITableViewCell

@property (nonatomic, weak) id<XYConstellationCardCellDelegate>delegate;

@property (nonatomic, strong) TTHoroscopeModel *model;

- (void)cardCellRefreshVipStatus;

@end
