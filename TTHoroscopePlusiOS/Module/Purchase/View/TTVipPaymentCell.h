//
//  VipPaymentCell.h
//  XToolWhiteNoiseIOS
//
//  Created by KevinXu on 2018/10/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TTPaymentPriceModel;
@interface TTVipPaymentCell : UITableViewCell

@property (nonatomic, strong) TTPaymentPriceModel *model;

@property (nonatomic, copy) void (^payButtonAction)(TTPaymentPriceModel *model);

@end


