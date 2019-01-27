//
//  UITabar+Extension.h
//  Horoscope
//
//  Created by 郭连城 on 2018/10/31.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar(badge)
- (void)showBadgeOnItemIndex:(int)index allCount:(int)count;
- (void)hideBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
