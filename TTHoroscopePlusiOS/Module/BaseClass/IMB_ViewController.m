//
//  IMB_ViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "IMB_ViewController.h"
#import "TTFeedbackViewController.h"

@interface IMB_ViewController ()
{
    UIBarButtonItem *leftItem_;
}
@end

@implementation IMB_ViewController

#pragma mark - Interface method

// 数据初始化
- (void)dataConfig{
    
}

// 界面初始化
- (void)uiConfig{
    if (self.navigationController.viewControllers.count > 0 && self.navigationController.viewControllers[0] != self)
    {
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        leftView.frame = CGRectMake(0, 0, 44, 44);
        leftView.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        [leftView setImage:[UIImage imageNamed:@"返回黑"] forState:UIControlStateNormal];
//        if ([self isKindOfClass:[FeedbackViewController class]]) {
//        }else{
//            [leftView setImage:[UIImage imageNamed:@"nav_back_btn"] forState:UIControlStateNormal];
//        }
        
        [leftView addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = item;
        leftItem_ = item;
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
    // 界面初始化
    [self uiConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        if (self.changeHeightOnly) {
            if (!self.navigationController) {
                MakeHeightTo(self.view, ViewHeight(self.view)-deltaY);
            }else{
                BOOL isTranslucent = self.navigationController.navigationBar.translucent;
                MakeHeightTo(self.view, KScreenHeight-deltaY- (isTranslucent ? 0:64));
            }
        }else{
            self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY + self->_deltaH);
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardHide:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        if (self.changeHeightOnly) {
            if (!self.navigationController) {
                MakeHeightTo(self.view, ViewHeight(self.view)+deltaY);
            }else{
                BOOL isTranslucent = self.navigationController.navigationBar.translucent;
                MakeHeightTo(self.view, KScreenHeight- (isTranslucent?0: 64));
            }
           
        }else{
            self.view.transform=CGAffineTransformIdentity;
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)registKeyBoardNoti
{
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyBoardNoti
{
    [kNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 子类都可疯狂重写哦~
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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


#pragma mark - Rotation method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Override get method
- (UIBarButtonItem *)leftItem
{
    return leftItem_;
}

@end
