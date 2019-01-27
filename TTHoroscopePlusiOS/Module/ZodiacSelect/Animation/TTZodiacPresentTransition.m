//
//  XYZodiacPresentTransition.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTZodiacPresentTransition.h"

@interface TTZodiacPresentTransition()
@property (nonatomic, assign) XYPresentOneTransitionType type;
@end

@implementation TTZodiacPresentTransition
+ (instancetype)transitionWithTransitionType:(XYPresentOneTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XYPresentOneTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case XYPresentOneTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case XYPresentOneTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        case XYPresentOneTransitionTypePresentTabVC:
            [self presentTabVCAnimation:transitionContext];
            break;
    }
}


/**
 *  实现present动画
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    toVC.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.01, 0.01), CGAffineTransformMakeTranslation(0, -containerView.xy_height*0.5+(isIPhoneX?66:44))) ;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished){
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];    
}

/**
 *  实现dimiss动画
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.01, 0.01), CGAffineTransformMakeTranslation(0, -containerView.xy_height*0.5+(isIPhoneX?66:44))) ;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {            
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
        }
    }];
}

- (void)presentTabVCAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.01, 0.01), CGAffineTransformMakeTranslation(0, -containerView.xy_height*0.5+(isIPhoneX?66:44)));
    }completion:^(BOOL finished){
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
