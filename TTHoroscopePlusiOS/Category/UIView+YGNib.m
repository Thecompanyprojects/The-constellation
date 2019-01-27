//
//  UIView+YGNib.m
//  UIKit分类整合
//
//  Created by Mr.xu on 2017/1/8.
//  Copyright © 2017年 xuyaguang. All rights reserved.
//

#import "UIView+YGNib.h"

@implementation UIView (YGNib)
+ (instancetype)yg_loadViewFromNib {
    return [self yg_loadViewFromNibWithName:NSStringFromClass([self class])];
}

+ (instancetype)yg_loadViewFromNibWithName:(NSString *)nibName {
    return [self yg_loadViewFromNibWithName:nibName owner:nil];
}

+ (instancetype)yg_loadViewFromNibWithName:(NSString *)nibName owner:(id)owner {
    return [self yg_loadViewFromNibWithName:nibName owner:owner bundle:[NSBundle mainBundle]];
}

+ (instancetype)yg_loadViewFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle {
    UIView *result = nil;
    NSArray* elements = [bundle loadNibNamed:nibName owner:owner options:nil];
    for (id object in elements) {
        if ([object isKindOfClass:[self class]]) {
            result = object;
            break;
        }
    }
    return result;
}
@end
