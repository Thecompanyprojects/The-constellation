//
//  XTFBNativeAdBigCell.h
//  Horoscope
//
//  Created by KevinXu on 2018/9/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTBaseModel;

@interface TTFBNativeAdBigCell : UITableViewCell

@property (nonatomic, strong) FBNativeAd *nativeAd;

@property (nonatomic, strong) TTBaseModel *adModel;

@end
