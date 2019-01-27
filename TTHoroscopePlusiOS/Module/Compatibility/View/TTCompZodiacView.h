//
//  XYCompZodiacView.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTCompZodiacView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy) void(^tapBlock)(TTCompZodiacView *view);
@property (nonatomic, assign) BOOL isSelected;

- (void)copyConfig;

@end
