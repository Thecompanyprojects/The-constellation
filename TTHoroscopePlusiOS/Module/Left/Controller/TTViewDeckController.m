//
//  XYViewDeckController.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/28.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTViewDeckController.h"
#import "TTZodiacPresentTransition.h"
@interface TTViewDeckController ()<UIViewControllerTransitioningDelegate>//UIViewControllerAnimatedTransitioning

@end

@implementation TTViewDeckController

- (instancetype)initWithCenterViewController_present:(UIViewController *)centerController leftViewController:(UIViewController *)leftController{
    self = [super initWithCenterViewController:centerController leftViewController:leftController];
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalPresentationCustom;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
    return self.centerViewController.preferredStatusBarStyle;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [TTZodiacPresentTransition transitionWithTransitionType:XYPresentOneTransitionTypePresentTabVC];
}


@end
