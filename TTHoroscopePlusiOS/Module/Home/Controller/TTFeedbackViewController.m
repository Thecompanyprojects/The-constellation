//
//  FeedbackViewController.m
//  XToolWhiteNoiseIOS
//
//  Created by KevinXu on 2018/8/31.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTFeedbackViewController.h"
//#import "ImageSelectView.h"
#import "TTEmailFillView.h"
#import "UITextView+Placeholder.h"
#import "UIView+YGNib.h"
#import <Masonry/Masonry.h>

#import "TTBaseNavigationController.h"

@interface TTFeedbackViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submitBtn;
//@property (nonatomic, strong) ImageSelectView *imageSelectView;
@property (nonatomic, strong) TTEmailFillView *emailFillView;
@property (nonatomic, strong) NSMutableArray <UIImage *>*imageArrayM;
@end

@implementation TTFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
//    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TTBaseNavigationController *nav = (TTBaseNavigationController *)self.navigationController;
    [nav navBlackTitleSet];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray <UIImage *>*)imageArrayM {
    if (!_imageArrayM) {
        _imageArrayM = [NSMutableArray array];
    }
    return _imageArrayM;
}

#pragma mark - 提交反馈
- (void)submitBtnAction:(UIButton *)sender {
    
    [SVProgressHUD show];//WithStatus:NSLocalizedString(@"Submitting...", nil)];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:self.textView.text forKey:@"content"];
    if (self.emailFillView.email.length > 0) {
        [dictM setObject:self.emailFillView.email forKey:@"email"];
    }
    [TTRequestTool requestWithURLType:FeedBack params:dictM success:^(NSDictionary *dictData) {
        if ([dictData[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Thank you for your feedback, we will continue to improve!", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"unknown error!", nil)];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 设置UI
- (void)setupView {
    self.title = NSLocalizedString(@"Feedback", nil);
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = kHexColor(0x000000);
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)kHexColor(0xFFFAD735).CGColor,
                             (__bridge id)kHexColor(0xFFFFBD4A).CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, KScreenWidth, kTabBarHeight);
    [btnView.layer addSublayer:gradientLayer];
    [self.view addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(kTabBarHeight);
    }];
    self.submitBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.enabled = NO;
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [btn setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(0xffffff) forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(0xeeeeee) forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [btnView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    self.containerView = ({
        UIScrollView *scView = [[UIScrollView alloc] init];
        scView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        scView;
    });
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(btnView.mas_top);
    }];
    
    UIView *textContentView = ({
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        v;
    });
    [self.containerView addSubview:textContentView];
    [textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(1);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    self.textView = ({
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.yg_placeholderLabel.text = NSLocalizedString(@"Enter your comments or suggestions...", nil);
        textView.yg_placeholderLabel.textColor = kHexColor(0x999999);
        textView.textColor = kHexColor(0x333333);
        textView.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
        textView;
    });
    [textContentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
//    self.imageSelectView = ({
//        ImageSelectView *view = [[ImageSelectView alloc] init];
//        view.backgroundColor = [UIColor whiteColor];
//        view.imageSelectAction = ^{
//            [self imageSelect];
//        };
//
//        view.imageTapAction = ^(UIImage *image) {
//            [self.imageArrayM removeObject:image];
//        };
//        view;
//    });
//    [self.containerView addSubview:self.imageSelectView];
//    [self.imageSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(self.view);
//        make.top.mas_equalTo(textContentView.mas_bottom).offset(1);
//        make.height.mas_equalTo(105);
//    }];
    
    self.emailFillView = ({
        TTEmailFillView *view = [TTEmailFillView yg_loadViewFromNib];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    [self.containerView addSubview:self.emailFillView];
    [self.emailFillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
        make.top.mas_equalTo(textContentView.mas_bottom).offset(5);
        make.height.mas_equalTo(50);
    }];
    

}


#pragma mark - 调用相机
- (void)imageSelect {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Album", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // 由于基类设置了透明这里加一个背景
        UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kNavBarHeight)];
        navView.backgroundColor = [UIColor whiteColor];
        [picker.view insertSubview:navView belowSubview:picker.navigationBar];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            picker.allowsEditing = NO;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
            }];
            
        } else {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Album Unavailable", nil)];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.allowsEditing = NO;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Camera Unavailable", nil)];
        }
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *textString = [[NSMutableString alloc] initWithString:textView.text];
    [textString stringByReplacingCharactersInRange:range withString:text];
    return textString.length <= 300;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"内容:%@", textView.text);
    self.submitBtn.enabled = textView.text.length >= 1;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageArrayM addObject:image];
//    [self.imageSelectView addImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
