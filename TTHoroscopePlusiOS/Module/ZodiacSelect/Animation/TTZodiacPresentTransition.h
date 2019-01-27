//
//  XYZodiacPresentTransition.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, XYPresentOneTransitionType) {
    XYPresentOneTransitionTypePresent = 0,
    XYPresentOneTransitionTypeDismiss,
    XYPresentOneTransitionTypePresentTabVC,
};
@interface TTZodiacPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>
+ (instancetype)transitionWithTransitionType:(XYPresentOneTransitionType)type;
- (instancetype)initWithTransitionType:(XYPresentOneTransitionType)type;
@end
