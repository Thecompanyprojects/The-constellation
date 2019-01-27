//
//  UIView+category.h
//  VPN
//
//  Created by PanZhi on 2018/3/9.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (category)

@property (nonatomic, assign) CGFloat xy_width;
@property (nonatomic, assign) CGFloat xy_height;
@property (nonatomic, assign) CGFloat xy_x;
@property (nonatomic, assign) CGFloat xy_y;
@property (nonatomic, assign) CGFloat xy_centerX;
@property (nonatomic, assign) CGFloat xy_centerY;

@property (nonatomic, assign) CGFloat xy_right;
@property (nonatomic, assign) CGFloat xy_bottom;

@property (nonatomic, assign) CGFloat right;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *_Nullable)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

+ (CGFloat)getHeightAttributeByWidth:(CGFloat)width attTitle:(NSAttributedString *)attTitle font:(UIFont *)font;

+ (instancetype)viewFromXib;

- (UIImage *)snapshotImage;

- (void)enlargedScaleToSize:(CGSize)size animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;

/**
 开始旋转

 @param duration 旋转一周的时间
 */
- (void)startRotateWithDuration:(CGFloat)duration;

@end
