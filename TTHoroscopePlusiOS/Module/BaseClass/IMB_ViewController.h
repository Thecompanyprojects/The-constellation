//
//  IMB_ViewController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMB_ViewController : UIViewController

@property (nonatomic) BOOL changeHeightOnly; // 当注册通知设置该属性有效，表示：是否只改变高度，不改变视图y坐标. 默认为NO.

@property (nonatomic) CGFloat deltaH; // 注册通知有效，可动态修改往上推的高度，默认0，默认推高度：键盘高度，该值可进行微调

/**
 *  是否有左侧返回按钮
 */
@property (nonatomic) BOOL hasBackButtonItem;

@property (nonatomic, readonly) UIBarButtonItem* leftItem;

/**
 *  数据初始化
 */
- (void)dataConfig;

/**
 *  界面初始化
 */
- (void)uiConfig;

// 注册键盘通知
- (void)registKeyBoardNoti;
// 取消注册
- (void)removeKeyBoardNoti;

// 子类可重写
- (void)keyboardShow:(NSNotification *)note;
- (void)keyboardHide:(NSNotification *)note;

/**
 *  快捷push
 *
 *  @param viewController 要push到的视图控制器
 */
- (void)pushTo:(UIViewController *)viewController;
// 快捷返回
- (void)pop;

- (void)backToPrevious;

- (BOOL)isValidateEmail:(NSString *)email;

@end
