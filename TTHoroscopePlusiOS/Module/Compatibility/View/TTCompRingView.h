//
//  XYCompRingView.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTCompRingView;

@protocol XYCompRingViewDelegate<NSObject>

@optional

- (void)tapped_ring:(TTCompRingView *)view;

@end

@interface TTCompRingView : UIView

@property (nonatomic, weak) id <XYCompRingViewDelegate> delegate;

@property (nonatomic, strong) UIView *ringView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UIColor *ringColor;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isFemale;
@property (nonatomic, assign) BOOL isDisabled;


@end
