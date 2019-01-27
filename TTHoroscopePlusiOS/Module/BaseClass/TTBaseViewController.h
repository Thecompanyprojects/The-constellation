//
//  XYBaseViewController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "IMB_ViewController.h"
#import "TTNetWorkReloadView.h"
#define bgImgVTag 201855
@interface TTBaseViewController : IMB_ViewController<XYNetWorkReloadViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImgV;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIView *backgroundImageCoverView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) BOOL isNotData;

- (void)setReloadViewHidden:(BOOL)hidden;
- (void)setReloadViewHidden:(BOOL)hidden type:(XYReloadViewNetworkStatus)type;
- (void)addCoverToBackImage;
- (void)addLeftItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;

- (void)addLoadingViewToSelf;
- (void)removeLoadingView;
- (void)statusBarHeightChanged:(NSNotification *)notification;
- (void)statusBarHeightDidChange:(NSNotification *)notification;
@end
