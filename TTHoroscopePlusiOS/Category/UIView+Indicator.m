//
//  UIView+Indicator.m
//  XToolCuteCamera
//
//  Created by KevinXu on 2018/7/17.
//  Copyright © 2018年 nbt. All rights reserved.
//

#import "UIView+Indicator.h"
#import <objc/runtime.h>

static char kIndicatorViewKey;

@implementation UIView (Indicator)

- (void)showIndicatorView {
    UIActivityIndicatorView *activityIndicator = objc_getAssociatedObject(self, &kIndicatorViewKey);
    if (activityIndicator) {
        [activityIndicator startAnimating];
        return;
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.color = [UIColor grayColor];
    activityIndicator.hidesWhenStopped = NO;
    
    [self addSubview:activityIndicator];
    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    objc_setAssociatedObject(self, &kIndicatorViewKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [activityIndicator startAnimating];
}

- (void)dismissIndicatorView {
    UIActivityIndicatorView *activityIndicator = objc_getAssociatedObject(self, &kIndicatorViewKey);
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    objc_setAssociatedObject(self, &kIndicatorViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
