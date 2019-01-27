//
//  XYBaseNavigationController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseNavigationController.h"
#import "TTBaseViewController.h"
#import "TTNewZodiacSelectController.h"
#import "TTZodiacPresentTransition.h"
@interface TTBaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate, UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong)UIViewController* currentShowVC;
@end

@implementation TTBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if ([rootViewController isKindOfClass:[TTNewZodiacSelectController class]]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

+ (void)initialize{
    
    UINavigationBar* appearance =[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[TTBaseNavigationController class]]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    appearance.translucent = YES;
    appearance.backgroundColor = [UIColor clearColor];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    
    //返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"返回黑"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 0) resizingMode:UIImageResizingModeTile];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    //参考自定义文字部分
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if (viewController != self.viewControllers[0]) {
        [self addLeftBarButtonWithImage:[UIImage imageNamed:@"返回黑"] action:@selector(popViewController) vc:viewController];
    }
    if (![viewController isKindOfClass:[TTNewZodiacSelectController class]]) {
           [(TTBaseViewController *)viewController addCoverToBackImage];
    }
    [self setTitleAttribute:viewController];
    [self setGuestureWithViewController:viewController];
}

- (void)setTitleAttribute:(UIViewController*)viewController{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictM[NSFontAttributeName] = kFontTitle_L_18;//[UIFont boldSystemFontOfSize:19];
    [viewController.navigationController.navigationBar setTitleTextAttributes:dictM];
}

- (void)setGuestureWithViewController:(UIViewController *)contoller{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"deckPanning" object:@(![contoller isKindOfClass:[XYHomeViewController class]])];
}

- (void)popViewController{
    [self popViewControllerAnimated:YES];
    UIViewController* viewController = self.viewControllers[0];
    [self setTitleAttribute:viewController];
    [self setGuestureWithViewController:viewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    
}

- (void)navBlackTitleSet{
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)navWhiteTitleSet{
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action vc:(UIViewController *)viewController

{
    //https://blog.csdn.net/u011146511/article/details/78191309

    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 66, 66);
    firstButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    if (isIOS11) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    }
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法在视图控制器完成push的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1){
        //如果堆栈内的视图控制器数量为1 说明只有根控制器，将currentShowVC 清空，为了下面的方法禁用侧滑手势
        self.currentShowVC = Nil;
    }
    else{
        //将push进来的视图控制器赋值给currentShowVC
        self.currentShowVC = viewController;
    }
}

//这个方法是在手势将要激活前调用：返回YES允许侧滑手势的激活，返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首先在这确定是不是我们需要管理的侧滑返回手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.currentShowVC == self.topViewController) {
            //如果 currentShowVC 存在说明堆栈内的控制器数量大于 1 ，允许激活侧滑手势
            return YES;
        }
        //如果 currentShowVC 不存在，禁用侧滑手势。如果在根控制器中不禁用侧滑手势，而且不小心触发了侧滑手势，会导致存放控制器的堆栈混乱，直接的效果就是你发现你的应用假死了，点哪都没反应，感兴趣是神马效果的朋友可以自己试试 = =。
        return NO;
    }
    
    //这里就是非侧滑手势调用的方法啦，统一允许激活
    return YES;
}

//获取侧滑返回手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [TTZodiacPresentTransition transitionWithTransitionType:XYPresentOneTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [TTZodiacPresentTransition transitionWithTransitionType:XYPresentOneTransitionTypeDismiss];
}

@end
