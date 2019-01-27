//
//  XYWebViewController.m
//  VPN
//
//  Created by PanZhi on 2018/3/15.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTWebViewController.h"

@interface TTWebViewController () <UIWebViewDelegate>
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong)UIActivityIndicatorView* indicator;
@end

@implementation TTWebViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr{
    self = [super init];
    if (self) {
        _urlStr = urlStr;
    }
    return self;
}

#define topMargin (isIPhoneX?88:64)
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
//    self.navigationController.navigationBar.hidden = ;
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, topMargin, self.view.bounds.size.width, self.view.bounds.size.height-topMargin)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    [self.indicator hidesWhenStopped];
    [self.indicator startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [webView loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取网页title
    [self.indicator stopAnimating];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.title.length) {
        self.title = title;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
