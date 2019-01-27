//
//  UITabar+Extension.m
//  Horoscope
//
//  Created by 郭连城 on 2018/10/31.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "UITabBar+Extension.h"

@implementation UITabBar (badge)


////显示红图标
//- (void)showNewOnItemIndex:(int)index{
//
//}
//



//显示红点
- (void)showBadgeOnItemIndex:(int)index allCount:(int)count{
    [self removeBadgeOnItemIndex:index];
    //新建小红点
//    UIView *bview = [[UIView alloc]init];
//    bview.tag = 888+index;
//    bview.layer.cornerRadius = 5;
//    bview.clipsToBounds = YES;
//    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6)/count;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new"]];
    imgView.frame = CGRectMake(x, y, 50, 30);
    imgView.tag = 888+index;
    [imgView sizeToFit];
    
    [self addSubview:imgView];
    [self bringSubviewToFront:imgView];
}
//隐藏红点
- (void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}
//移除控件
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
