//
//  UIView+YGNib.h
//  UIKit分类整合
//
//  Created by Mr.xu on 2017/1/8.
//  Copyright © 2017年 xuyaguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YGNib)
+ (instancetype)yg_loadViewFromNib;
+ (instancetype)yg_loadViewFromNibWithName:(NSString *)nibName;
+ (instancetype)yg_loadViewFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)yg_loadViewFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;
@end
