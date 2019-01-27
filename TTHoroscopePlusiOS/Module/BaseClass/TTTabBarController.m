//
//  XYTabBarController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/23.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTabBarController.h"
#import "TTBaseNavigationController.h"
#import "TTHomeViewController.h"
#import "TTVipPaymentController.h"
#import "TTDiscoverViewController.h"
#import <ViewDeck/ViewDeck.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import "TTWebViewController.h"
#import "TTAboutViewController.h"
#import "TTPaymentManager.h"

#import "TTFeedbackViewController.h"
#import "UITabBar+Extension.h"
#import <TTHoroscopePlusiOS-Swift.h>


@interface TTTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong)NSMutableArray* jsbadgeArray;


@end

@implementation TTTabBarController



- (instancetype)init{
    self = [super init];
    __weak typeof(self)weakSelf = self;
    self.selectBlock_tabbar = ^(NSDictionary *info){
        [weakSelf gotoPageWithInfo:info];
    };
    return self;
}

- (void)gotoPageWithInfo:(NSDictionary *)info{
    NSString* className = info[@"className"];
    [self.viewDeckController closeSide:YES];
    Class class = NSClassFromString(className);
    UIViewController *vc = [[class alloc]init];
    if(vc == nil){
        NSString *title = info[@"value"];
        if([title isEqualToString:@"1"]){//评分
            NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", kAppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
           
            /****/
            [[XYLogManager shareManager] addLogKey1:@"menu" key2:@"rate us" content:nil userInfo:nil upload:YES];
            
        }else if([title isEqualToString:@"2"]){//分享给朋友
            [self shard];
            /****/
            [[XYLogManager shareManager] addLogKey1:@"menu" key2:@"share" content:nil userInfo:nil upload:YES];
            
        }else if([title isEqualToString:@"3"]){//点击了购买
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey];
            NSNumber *isPushPayVC = dict[@"cloud"][@"leftVc"][@"isPushPayVC"];
            if (isPushPayVC.integerValue == 0){
                [self payVip];
            }else{
                
                if (self.selectedIndex == 2) {
                    return;
                } else {
                    if (self.childViewControllers.count == 3) {
                        self.selectedIndex = 2;
                    } else {
                        TTVipPaymentController *puVC = [TTVipPaymentController new];//nav.viewControllers.lastObject;
                        puVC.isFullScreen = YES;
                        puVC.hidesBottomBarWhenPushed = YES;
                        [self.selectedViewController pushViewController:puVC animated:YES];
                    }
                }
            }
            
            /****/
            [[XYLogManager shareManager] addLogKey1:@"menu" key2:@"premium" content:nil userInfo:nil upload:YES];
            
            [TTManager sharedInstance].paySource = @"menu";
        }
        return;
    }
    
    if ([vc isKindOfClass:TTVipPaymentController.class]){
        if (self.selectedIndex == 2) {
            return;
        } else {
            if (self.childViewControllers.count == 3) {
                self.selectedIndex = 2;
            } else {
                TTVipPaymentController *puVC = [TTVipPaymentController new];//nav.viewControllers.lastObject;
                puVC.isFullScreen = YES;
                puVC.hidesBottomBarWhenPushed = YES;
                [self.selectedViewController pushViewController:puVC animated:YES];
            }
        }
        
    }else if([vc isKindOfClass:TTAboutViewController.class]){
        /****/
        [[XYLogManager shareManager] addLogKey1:@"menu" key2:@"adout" content:nil userInfo:nil upload:YES];
        
        TTAboutViewController* about = [TTAboutViewController new];
        about.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:about animated:YES];
        
    }else if([className isEqualToString:@"TTTarotPickCardVC"]){
        
//        [self setSelectedViewController:self.viewControllers[1]];
        
    }else if([vc isKindOfClass:TTFeedbackViewController.class]){
        /****/
        [[XYLogManager shareManager] addLogKey1:@"menu" key2:@"feedback" content:nil userInfo:nil upload:YES];
        
        TTFeedbackViewController *feedbackVC = [[TTFeedbackViewController alloc] init];
        feedbackVC.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:feedbackVC animated:YES];
    }

}



//MARK:- 直接购买
- (void)payVip{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey];
    NSString *productID = dict[@"cloud"][@"subscribe"][@"subscribe_id"];
    
    /****/
    [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"button" content:@{@"type":@"auto"} userInfo:nil upload:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentSuccees:) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentFail:) name:PAYMENT_FAIL_NOTIFICATION object:nil];
    
    [SVProgressHUD show];
    [[TTPaymentManager shareInstance] paymentWithProductID:productID];
}

- (void)shard{
    //分享的标题
    NSString *textToShare = @"Share to Friends";
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"AppIcon"];
    //分享的url
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", kAppID];
    NSURL *urlToShare = [NSURL URLWithString:url];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare,imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    if (@available(iOS 11.0, *)) {
        activityVC.excludedActivityTypes = @[
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeMessage,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
                                             UIActivityTypeOpenInIBooks,
                                             UIActivityTypeMarkupAsPDF
                                             ];
    } else {
        activityVC.excludedActivityTypes = @[
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeMessage,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
                                             UIActivityTypeOpenInIBooks,
                                             ];
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"share completed");
            //分享 成功
        } else  {
            NSLog(@"share is cancled");
            //分享 取消
        }
    };
}

- (void)setSelectedVC:(NSNotification *)notification{
    NSDictionary* dict = notification.object;
    if (dict == nil) {
        return;
    }
    [self gotoPageWithInfo:dict];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor whiteColor]]];
    [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]];

    [self setupAllViewController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSelectedVC:) name:@"setSelectedVC" object:nil];
//
//    [[UITabBarItem appearance] setTitleTextAttributes:@{
//                                                        NSFontAttributeName : kFontTitle_M_10
//                                                        }
//                                             forState:UIControlStateNormal];
//
//    // 选中字体颜色和字号
//    [[UITabBarItem appearance] setTitleTextAttributes:@{
//                                                        NSFontAttributeName:kFontTitle_M_10
//                                                        }
//                                             forState:UIControlStateSelected];
}

- (void)setupAllViewController{
    [self addControllerClass:[TTHomeViewController class] imageStr:@"xingqiu" selectImageStr:@"xingqiu02"];
    [self addControllerClass:[TTDiscoverViewController class]  imageStr:@"faxian" selectImageStr:@"faxian02"];
    
    if (![TTPaymentManager shareInstance].isVip) {
        TTVipPaymentController * vcPay = (TTVipPaymentController *)[self addControllerClass:[TTVipPaymentController class] imageStr:@"zuanshi" selectImageStr:@"zuanshi02"];
        vcPay.isTabBarItem = YES;
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Discover"] isEqualToString:@"DidSelect"]) {
            [self.tabBar showBadgeOnItemIndex:1 allCount:3];
        }
    }else{
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Discover"] isEqualToString:@"DidSelect"]) {
            [self.tabBar showBadgeOnItemIndex:1 allCount:2];
        }
    }
}

- (UIViewController *)addControllerClass:(Class)class imageStr:(NSString *)imageStr selectImageStr:(NSString *)selectImageStr{
    UIViewController *VC = [[class alloc] init];
    //    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor] } forState: UIControlStateNormal];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kHexColor(0xFFCA28) } forState: UIControlStateSelected];
    
    [VC.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [VC.tabBarItem setImage:[UIImage imageNamed:imageStr]];

    if(isIPhoneX){
        VC.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 10, -10, -10);
    }
    TTBaseNavigationController *nav = [[TTBaseNavigationController alloc]initWithRootViewController:VC];
    [self addChildViewController:nav];
    
    if ([TTDiscoverViewController class] == class){
        
    }else{
        [self addShowDeckButtonToController:VC];        
    }
    return VC;
}

- (void)addShowDeckButtonToController:(UIViewController *)controller{
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    firstButton.frame = CGRectMake(0, 0, 60, 44);
    
    [firstButton setImage:[UIImage imageNamed:@"图标 头 侧边栏"] forState:UIControlStateNormal];
    
    [firstButton addTarget:self action:@selector(showDeck) forControlEvents:UIControlEventTouchUpInside];
    
    firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    
    controller.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if (self.jsbadgeArray == nil) {
        self.jsbadgeArray = [NSMutableArray new];
    }
}

- (void)showDeck{
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)viewDidLayoutSubviews{
         [super viewDidLayoutSubviews];
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            CGRect tabFrame = self.tabBar.frame;
            tabFrame.size.height = kTabBarHeight + 10;
            tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height;
            self.tabBar.frame = tabFrame;
//        });
}


- (void)createRedindex{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5+5, 5, 5, 5)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 2.5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.backgroundColor = [UIColor redColor];
    
}

//MARK:- 应用内购买delegate回调
- (void)observerPaymentSuccees:(NSNotification *)notification {
    NSNumber *numer = notification.userInfo[@"type"];
    [self showWithState:numer.integerValue isSuccess:YES];
}

- (void)observerPaymentFail:(NSNotification *)notification {
    NSNumber *numer = notification.userInfo[@"type"];
    [self showWithState:numer.integerValue isSuccess:NO];
}

- (void)showWithState:(XYPaymentStatus)state isSuccess:(BOOL)success {
    NSString *logString = @"";
    switch (state) {
        case payment_succeed_status:{
            logString = NSLocalizedString(@"Subscribe success",nil);
        } break;
        case verify_timeout_status:{
            logString = NSLocalizedString(@"Verification timeout",nil);
        } break;
        case verify_fail_status:{
            logString = NSLocalizedString(@"Verification failed",nil);
        } break;
        case payment_fail_status:{
            logString = NSLocalizedString(@"Payment timeout",nil);
        } break;
        case no_product_status:{
            logString = NSLocalizedString(@"Unavailable",nil);
        } break;
        case bought_status:{
            logString = NSLocalizedString(@"Subscribed",nil);
        } break;
        case Transaction_fail_status:{
            logString = NSLocalizedString(@"Payment failed",nil);
        } break;
        case vip_Expires_status:{
            logString = NSLocalizedString(@"Subscription expired",nil);
        } break;
        case app_store_connect_fail_status:{
            logString = NSLocalizedString(@"iTunes Store connect failed",nil);
        } break;
        case not_allowed_pay_status:{
            logString = NSLocalizedString(@"No purchase allowed",nil);
        } break;
        case user_cancel:{
            logString = NSLocalizedString(@"User cancelled",nil);
        } break;
        default:
            break;
    }
    
    if (success) {
        [SVProgressHUD showSuccessWithStatus:logString];
    } else {
        [SVProgressHUD showErrorWithStatus:logString];
    }
    
}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    TTBaseNavigationController *navVc = (TTBaseNavigationController *)viewController;
    
    TTDiscoverViewController * vc = [TTDiscoverViewController new];
    TTBaseNavigationController *nvc = [[TTBaseNavigationController alloc]initWithRootViewController:vc];
          nvc.modalPresentationStyle = UIModalPresentationCustom;
        vc.view.alpha = 1;
        nvc.view.alpha = 1;
    if([navVc.topViewController isKindOfClass:[TTDiscoverViewController class]]){
        [navVc presentViewController: nvc animated:NO completion:^{
            if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Discover"] isEqualToString:@"DidSelect"]) {
                [self.tabBar hideBadgeOnItemIndex:1];
                [[NSUserDefaults standardUserDefaults] setObject:@"DidSelect" forKey:@"Discover"];
            }
        }];
        return NO;
    }
    // 记录之前选择的selectedIndex
    self.oldSelectIndex = tabBarController.selectedIndex;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    switch (tabBarController.selectedIndex) {
        case 0:{
            [[XYLogManager shareManager] addLogKey1:@"horoscope_today" key2:@"horoscope" content:nil userInfo:nil upload:YES];
        }break;
        case 1:{
            // 上面的方法已经拦截,这里不执行
//            [[XYLogManager shareManager] addLogKey1:@"discover" key2:@"discover" content:nil userInfo:nil upload:YES];
        }break;
        case 2:{
            [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"premium" content:nil userInfo:nil upload:YES];
        }break;
        default:
            break;
    }
}


//MARK:- lazy
- (UIView *)redDotView{
    if (!_redDotView) {
        _redDotView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth*0.5+6, -4, 8, 8)];
        _redDotView.layer.masksToBounds = YES;
        _redDotView.layer.cornerRadius = 4;
        _redDotView.layer.borderWidth = 1;
        _redDotView.layer.borderColor = [UIColor whiteColor].CGColor;
        _redDotView.backgroundColor = [UIColor redColor];
    }
    return _redDotView;
}




@end
