//
//  XYAboutViewController.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTAboutViewController.h"
#import "TTWebViewController.h"
#import <SafariServices/SafariServices.h>

@interface TTAboutViewController ()
@property (nonatomic, strong)UIImageView* imageView;
@end

@implementation TTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"About";
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    
    UIImageView *logo = [[UIImageView alloc] init];
    [self.view addSubview:logo];
    logo.image = [UIImage imageNamed:@"logo-1"];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    self.imageView = logo;
    
    UILabel *name = [[UILabel alloc] init];
    [self.view addSubview:name];
    name.font = [UIFont systemFontOfSize:19 weight:1];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    name.text = app_Name;
    name.textColor = [UIColor blackColor];//[UIColor colorWithHex:0xBCA6D3];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.top.equalTo(logo.mas_bottom).offset(14);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.textColor = [UIColor blackColor];
    versionLabel.font = [UIFont boldSystemFontOfSize:15];
    
    versionLabel.text = [NSString stringWithFormat:@"Release %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(isIPhoneX?-80:-60);
    }];
    
    
    UIButton *privacyPolicy = [[UIButton alloc]init];
    [privacyPolicy setTitle:@"Privacy Policy" forState:UIControlStateNormal];
    privacyPolicy.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    [self.view addSubview:privacyPolicy];
    [privacyPolicy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privacyPolicy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view).offset(60);
    }];
    [privacyPolicy addTarget:self action:@selector(clickPrivacyPolicy) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *termsOfService = [[UIButton alloc]init];
    [termsOfService setTitle:@"Terms of Service" forState:UIControlStateNormal];
    termsOfService.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    [self.view addSubview:termsOfService];
    [termsOfService setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [termsOfService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view).offset(-60);
    }];
    [termsOfService addTarget:self action:@selector(clickTermsofService) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)clickTermsofService{

//    XYWebViewController* web = [[XYWebViewController alloc]initWithUrlStr:TermHtml];
//    web.title = @"Terms of Service";
//    [self.navigationController pushViewController: web animated:true];
    
    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:TermHtml]];
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)clickPrivacyPolicy{
//    XYWebViewController* web = [[XYWebViewController alloc]initWithUrlStr:PrivacyHtml];
//    web.title = @"Privacy Policy";
//    [self.navigationController pushViewController: web animated:true];
    
    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:PrivacyHtml]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

@end
