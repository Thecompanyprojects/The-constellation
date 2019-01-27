//
//  XYInitViewController.m
//  Horoscope
//
//  Created by 郭连城 on 2018/9/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "TTNewZodiacSelectController.h"
#import "TTBaseNavigationController.h"
#import "TTViewDeckController.h"
#import "TTLeftViewController.h"
#import "TTTabBarController.h"
#import "TTInitViewController.h"

#import <TTHoroscopePlusiOS-Swift.h>

@interface TTInitViewController ()<XYConfigRequestDelegate>

@end

@implementation TTInitViewController

- (void)dealloc
{
    NSLog(@"我已释放")
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage = [UIImage imageWithColor: [UIColor groupTableViewBackgroundColor]];
   // [UIImage imageNamed: @"背景图1125 2436"];
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if (isVip){
            [self initUI];
        }else{
            [[TTManager sharedInstance] reloadConfigWithDelegate:self];
        }
    }];
}

//MARK:- Configdelegate
- (void)requestStarted{
    NSLog(@"初始页面请求开始")
    [self addLoadingViewToSelf];
}

- (void)requestDidSucceed:(BOOL)didSucceed info:(NSString *)info{
    [self removeLoadingView];
    [[TTManager sharedInstance] removeDelegate:self];
    NSLog(@"初始页面请求结束")

    if (didSucceed){//刷新成功 取配置
         [self setReloadViewHidden:YES];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"][@"bootPage"];
        
        NSNumber *needStrongBootPage = dict[@"needStrongBootPage"];
        
        NSString *version = dict[@"<=version"];
        
        NSString *currentVer = [TTBaseTools publicBundleVersion];
        
        NSComparisonResult compareResult = [currentVer compare:version options:NSNumericSearch];
        
        if (compareResult == NSOrderedAscending || compareResult == NSOrderedSame){ //当前版本小于等于配置版本，执行配置
          BOOL isPayed = [[NSUserDefaults standardUserDefaults] objectForKey:@"paySuccess_bootProcess"];
            
            if (needStrongBootPage.integerValue == 0 || isPayed){ //=0 不需要强引导
                [self initUI];
            }else{
                [self initBootPage];
            }
        }else{
            [self initUI];
        }
    }else{
        [self setReloadViewHidden:NO];
        NSLog(@"拉取配置请求失败")
    }
}


- (void)reloadViewSelector{
    [super reloadViewSelector];
     [[TTManager sharedInstance] reloadConfigWithDelegate:self];
}


- (void)initBootPage{
    
            XYBootProcessVC_1 *vc = [XYBootProcessVC_1 new];
            TTBaseNavigationController *nav = [[TTBaseNavigationController alloc]initWithRootViewController:vc];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = nav;
    
}

- (void)initUI{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
//    4001005678
    if ([TTManager sharedInstance].zodiacManager.showZodiacSelection) { // 选择星座
        TTNewZodiacSelectController *zodiac = [TTNewZodiacSelectController new];
        TTBaseNavigationController* nav = [[TTBaseNavigationController alloc]initWithRootViewController:zodiac];
        window.rootViewController = nav;
    } else { // 主页面
        TTTabBarController *tabVC = [TTTabBarController new];
        TTLeftViewController* left = [TTLeftViewController new];
        left.selectBlock = tabVC.selectBlock_tabbar;
        TTViewDeckController* deck = [[TTViewDeckController alloc]initWithCenterViewController:tabVC leftViewController:left];
        window.rootViewController = deck;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
