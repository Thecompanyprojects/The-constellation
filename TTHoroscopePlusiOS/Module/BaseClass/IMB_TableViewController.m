//
//  IMB_TableViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "IMB_TableViewController.h"

@interface IMB_TableViewController ()

@end

@implementation IMB_TableViewController

#pragma mark - Interface method

// 数据初始化
- (void)dataConfig{
    
}

// 界面初始化
- (void)uiConfig{
    // 设置数据源
    if (self.navigationController.viewControllers.count > 0 && self.navigationController.viewControllers[0] != self)
    {
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        leftView.frame = CGRectMake(0, 0, 15, 15);
        [leftView setImage:[UIImage imageNamed:@"navigation_back_icon"] forState:UIControlStateNormal];
        [leftView addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = item;
    }
}

// 返回上层
- (void)backToPrevious
{
    [self.view endEditing:YES];
    if (self.navigationController.viewControllers[0] != self)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    //nav.popBlock=nil;
}

#pragma mark - Life Cycle method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self dataConfig];
    }
    return self;
}

// storyboard
- (void)awakeFromNib{
    [super awakeFromNib];
    // 配置
    [self dataConfig];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uiConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 快捷push
- (void)pushTo:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}
// 快捷返回
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
