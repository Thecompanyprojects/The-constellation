//
//  XYBaseViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTBaseViewController ()


@property (nonatomic, strong) TTNetWorkReloadView *reloadView;


@end

@implementation TTBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusBarHeightChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusBarHeightDidChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)statusBarHeightDidChange:(NSNotification *)notification{
    
}

- (void)statusBarHeightChanged:(NSNotification *)notification{
    NSDictionary* dict = notification.userInfo;
    NSValue* newStatusBarRectValue = [dict objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    if (newStatusBarRectValue == nil) {
        return;
    }
    if (isIPhoneX) {
        return;
    }
    
    if (_backgroundImgV) {
        [self setBackgroundImage:_backgroundImage];
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _isNotData = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isNotData) {
        [self reloadViewSelector];
    }
}

- (void)uiConfig{
    [super uiConfig];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = true;
    self.view.layer.masksToBounds = YES;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [self.view insertSubview:self.backgroundImgV atIndex:0];
    [self.backgroundImgV mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.mas_equalTo(self.view);
    }];
    [self.backgroundImgV setImage:backgroundImage];
    
}

- (UIImageView *)backgroundImgV{
    if (!_backgroundImgV) {
        _backgroundImgV = [[UIImageView alloc]init];
        _backgroundImgV.tag = bgImgVTag;
        _backgroundImgV.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImgV.frame = self.view.bounds;
    }
    return _backgroundImgV;
}

- (void)addCoverToBackImage{
    UIView* cover = [UIView new];
//    cover.backgroundColor = [UIColor colorWithHex:0x3E2555 alpha:0.5];
    self.backgroundImageCoverView = cover;
    cover.backgroundColor = [UIColor whiteColor];
    [self.backgroundImgV addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.mas_equalTo(self.backgroundImgV);
    }];
}

- (void)addLeftItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setReloadViewHidden:(BOOL)hidden{
    self.reloadView.hidden = hidden;
    self.isNotData = hidden;
    if (hidden == NO) {
        [self.view addSubview:self.reloadView];
        [self.reloadView mas_makeConstraints:^(MASConstraintMaker* make){
            make.edges.mas_equalTo(self.view);
        }];
        [self.view bringSubviewToFront:self.reloadView];
    }else{
        [self.reloadView removeFromSuperview];
    }
}

- (void)setReloadViewHidden:(BOOL)hidden type:(XYReloadViewNetworkStatus)type{
    [self setReloadViewHidden:hidden];
    if (hidden == NO) {
        if (type == NOT_NEIWORK) {
            self.reloadView.subLabel.text = @"The Internet connection appears to be offline.";
        }else if (type == SERVICE_ERROR){
            self.reloadView.subLabel.text = @"Sever connection timeout！";
        }
    }
}

- (TTNetWorkReloadView *)reloadView{
    if (!_reloadView) {
        _reloadView = [TTNetWorkReloadView new];
        _reloadView.delegate = self;
    }return _reloadView;
}

#pragma mark - loading View

- (void) addLoadingViewToSelf{
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
}

- (void)removeLoadingView{
    if (!_loadingView) return;
    [self.loadingView removeFromSuperview];
}

- (UIView *)loadingView{
    if (!_loadingView) {
        _loadingView = [TTLoadingHUD CreateLoadingViewWithFrame:self.view.bounds];
    }
    return _loadingView;
}

- (void)reloadViewSelector{
    NSLog(@"%s",__func__);
    
}

@end
