//
//  VipPaymentController.m
//  XToolWhiteNoiseIOS
//
//  Created by KevinXu on 2018/9/6.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTVipPaymentController.h"
#import "TTPaymentManager.h"
#import <YYText.h>
#import <NSAttributedString+YYText.h>
#import <QuartzCore/QuartzCore.h>
#import <SafariServices/SafariServices.h>
#import <MessageUI/MessageUI.h>
#import "TTVipTitleView.h"
#import "TTBaseNavigationController.h"
#import "TTVipPaymentCell.h"
#import "UITabBar+Extension.h"
#import "TTPaymentPriceModel.h"

#import "TTHoroscopePlusiOS-Swift.h"
@interface TTVipPaymentController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isSubscribed; /**< 是否已经订阅过 */
@property (nonatomic, strong) UIButton      *restoreButton;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) TTVipTitleView  *titleView;
@property (nonatomic, strong) UIButton      *payButton;
@property (nonatomic, strong) UIView        *infoContentView;
@property (nonatomic, strong) YYLabel       *infoLabel;
@property (nonatomic, strong) YYLabel       *subTitleLabel;
@property (nonatomic, strong) UIButton      *termsOfServicesButton;
@property (nonatomic, strong) UIButton      *privacyPolicyButton;
@property (nonatomic, strong) UITableView   *subTabview;
@property (nonatomic, strong) NSArray <TTPaymentPriceModel *>*vipPriceArray;

@end

@implementation TTVipPaymentController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isBootProcess = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewSelectorFromBg:) name:ENTER_FOREGROUND_NOTIFICATION object:nil];

    self.navigationItem.title = @"PREMIUM";
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - 后台进入前台进行数据刷新
- (void)reloadViewSelectorFromBg:(NSNotification *)notification {
    // 时间间隔判断
    NSNumber *time_intervel = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"][@"refresh_time_interval"];
    if (!time_intervel) {
        time_intervel = @(10);// 默认30分钟
    }
    
    // 获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *current_time_str = [formatter stringFromDate:[NSDate date]];
    
    // 获取进入后台的时间
    NSString *time_enter_bg = [[NSUserDefaults standardUserDefaults] stringForKey:@"kAppEnterBackgroundTimeKey"];
    if (!time_enter_bg) {
        time_enter_bg = current_time_str;
    }
    
    if (current_time_str.integerValue > time_enter_bg.integerValue + time_intervel.integerValue) {
        [self reloadViewSelector];
    }
}

- (void)reloadViewSelector{
    [[TTManager sharedInstance] reloadConfigWithDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[TTPaymentManager shareInstance] addPayTransactionObserver];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentSuccees:) name:PAYMENT_SUCCEED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerPaymentFail:) name:PAYMENT_FAIL_NOTIFICATION object:nil];
    
    TTBaseNavigationController *nav = (TTBaseNavigationController *)self.navigationController;
    [nav navBlackTitleSet];
    // 检查订阅状态
//    [SVProgressHUD show];
    @weakify(self);
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
//        [SVProgressHUD dismiss];
        @strongify(self);
        self.isSubscribed = isVip;
        self.restoreButton.hidden = isVip;
        self.payButton.enabled = !isVip;
        self.scrollView.hidden = NO;
        
        if (isVip) {
                [UIAlertController showAlertTitle:@"You have subscribed" message:nil cancelTitle:@"Sure" otherTitle:nil cancleBlock:^{
                    [self removeTabBarPaymentItem];
                    if (self.navigationController.childViewControllers.count > 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        if (self.isTabBarItem) {
                            self.tabBarController.selectedIndex = 0;
                        } else {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                } otherBlock:^{
                    
                }];
        }
        
        [self.subTabview reloadData];
    }];
    
    if (!self.vipPriceArray || self.vipPriceArray.count == 0) {
        [[TTManager sharedInstance] reloadConfigWithDelegate:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[TTPaymentManager shareInstance] removePayTransactionObserver];
    [SVProgressHUD dismiss];
}


#pragma mark - 返回
- (void)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 恢复
- (void)restoreButtonAction:(UIButton *)sender {
    [[TTPaymentManager shareInstance] refreshReceipt];
    
    [self logIsPayButton:NO];
}

#pragma mark - 购买
- (void)payButtonAction:(UIButton *)sender {
    NSDictionary *subdict = [self getConfigInfo];
    // 按钮点击购买取单独的ID
    NSString *payment_id = subdict[@"subscribe_id"];
    
    [self payWithProduct:payment_id];
    [self logIsPayButton:YES];
}

- (void)payWithProduct:(NSString *)productId {
    [SVProgressHUD show];
    [[TTPaymentManager shareInstance] paymentWithProductID:productId];
}




- (void)logIsPayButton:(BOOL)payButton {
    /****/
    if (payButton) {
        [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"button" content:nil userInfo:nil upload:YES];
    } else {
        [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"restore" content:nil userInfo:nil upload:YES];
    }
}



- (void)observerPaymentSuccees:(NSNotification *)notification {
    self.payButton.enabled = NO;
    self.restoreButton.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"paySuccess_bootProcess"];
   
    
    NSNumber *numer = notification.userInfo[@"type"];
    [self showWithState:numer.integerValue isSuccess:YES];
    
    if (self.isBootProcess){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYNotification.switchRootViewController object:self];
        });
    }
}

- (void)observerPaymentFail:(NSNotification *)notification {
    NSNumber *numer = notification.userInfo[@"type"];
    [self showWithState:numer.integerValue isSuccess:NO];
}


#pragma mark - 服务条款
- (void)termsOfServicesButtonAction:(UIButton *)sender {
    NSString *terms_of_services = [self getConfigInfo][@"terms_of_services"];
    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:terms_of_services]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 隐私政策
- (void)privacyPolicyButtonAction:(UIButton *)sender {
    NSString *privacy_policy = [self getConfigInfo][@"privacy_policy"];
    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:privacy_policy]];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - 设置UI
- (void)setupUI {
    [self setupNavigationView];
    [self setupViews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.infoContentView.backgroundColor = [UIColor whiteColor];
    self.scrollView.hidden = NO;
}

- (void)setupNavigationView {
    self.restoreButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSNumber *alpha = [self getConfigInfo][@"restore_btn_alpha"];
        UIColor *color = [UIColor colorWithHexString:[self getConfigInfo][@"restore_btn_color"]];
        [button setTitle:[self getConfigInfo][@"restore_btn_title"] forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.alpha = alpha.doubleValue;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 2;
        [button addTarget:self action:@selector(restoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    UIBarButtonItem *restore = [[UIBarButtonItem alloc] initWithCustomView:self.restoreButton];
    self.navigationItem.rightBarButtonItem = restore;
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.isFullScreen) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight + 10, 0));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
        }
    }];
}

#pragma mark - 设置UI
- (void)setupViews {
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.hidden = YES;
        scrollView;
    });
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.isFullScreen) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight + 10, 0));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
        }
    }];
    
    self.contentView = ({
        UIView *view = [[UIView alloc] init];
        view;
    });
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    self.titleView = [TTVipTitleView yg_loadViewFromNib];
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    
    if ([self shouldShowSubcribeList]) {
    
        self.subTabview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.subTabview.delegate = self;
        self.subTabview.dataSource = self;
        self.subTabview.rowHeight = 68;
        self.subTabview.scrollEnabled = NO;
        self.subTabview.bounces = NO;
        self.subTabview.estimatedRowHeight = 50;
        self.subTabview.estimatedSectionFooterHeight = 0;
        self.subTabview.estimatedSectionHeaderHeight = 0;
        self.subTabview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        self.subTabview.separatorColor = kHexColor(0xE2E2E2);
        self.subTabview.tableFooterView = [UIView new];
        self.subTabview.tableHeaderView = [UIView new];
        
        [self.subTabview registerNib:[UINib nibWithNibName:NSStringFromClass([TTVipPaymentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TTVipPaymentCell class])];
        
        [self.contentView addSubview:self.subTabview];
        [self.subTabview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.titleView.mas_bottom).offset(10);
            make.height.mas_equalTo(self.vipPriceArray.count * 68);
        }];
        
    } else {
    
        self.payButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSNumber *font = [self getConfigInfo][@"pay_btn_text_font"];
            button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:font.integerValue];
            [button setTitle:[self getConfigInfo][@"pay_btn_text_notvip"] forState:UIControlStateNormal];
            [button setTitle:[self getConfigInfo][@"pay_btn_text_vip"] forState:UIControlStateDisabled];
            [button setTitleColor:[UIColor colorWithHexString:[self getConfigInfo][@"pay_btn_text_color"]] forState:UIControlStateNormal];
            NSNumber *alpha = [self getConfigInfo][@"pay_btn_text_alpha"];
            button.alpha = alpha.doubleValue;
            
            [button setBackgroundImage:[UIImage imageNamed:@"bt"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.adjustsImageWhenDisabled = NO;
            button.layer.cornerRadius = 4.0;
            button.layer.shadowColor = kHexColor(0x2e2e2e).CGColor;
            button.layer.masksToBounds = YES;
            button.layer.shadowOffset = CGSizeMake(0, 7);
            button.titleLabel.numberOfLines = 2;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button;
        });
        self.payButton.enabled = !self.isSubscribed;
        [self.contentView addSubview:self.payButton];
        [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(345*KWIDTH, 55*KWIDTH));
            make.top.mas_equalTo(self.titleView.mas_bottom).offset(40);
            make.centerX.mas_equalTo(0);
        }];
        
    }
    
    self.infoContentView = ({
        UIView *view = [[UIView alloc] init];
        NSNumber *hidden = [self getConfigInfo][@"instructions_alpha"];
        view.alpha = hidden.doubleValue;
        view;
    });
    [self.contentView addSubview:self.infoContentView];
    [self.infoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if ([self shouldShowSubcribeList]) {
            make.top.mas_equalTo(self.subTabview.mas_bottom).offset(5);
        } else {
            make.top.mas_equalTo(self.payButton.mas_bottom).offset(5);
        }
    }];
    
    self.subTitleLabel = ({
        YYLabel *label = [[YYLabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        label.textColor = [UIColor colorWithHexString:[self getConfigInfo][@"subscribed_price_color"]];
        NSNumber *alpha = [self getConfigInfo][@"subscribed_price_alpha"];
        label.alpha = alpha.doubleValue;
        label.text = [self getConfigInfo][@"subscribed_price"];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    [self.infoContentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth - 40);
    }];
    
    self.infoLabel = ({
        YYLabel *label = [[YYLabel alloc] init];
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        label.attributedText = [self infoString];
        label;
    });
    
    [self.infoContentView addSubview:self.infoLabel];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(KScreenWidth - 40, MAXFLOAT) text:self.infoLabel.attributedText];
    CGFloat infoHeight = layout.textBoundingSize.height;
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(KScreenWidth - 40);
        make.height.mas_equalTo(infoHeight);
    }];
    
    self.termsOfServicesButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setAttributedTitle:[self urlButtonAttributedTextWithText:[self getConfigInfo][@"terms_of_services_title"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(termsOfServicesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.infoContentView addSubview:self.termsOfServicesButton];
    [self.termsOfServicesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(self.infoContentView.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.infoContentView).offset(0);
    }];

    self.privacyPolicyButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setAttributedTitle:[self urlButtonAttributedTextWithText:[self getConfigInfo][@"privacy_policy_title"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(privacyPolicyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.infoContentView addSubview:self.privacyPolicyButton];
    [self.privacyPolicyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.width.mas_equalTo(self.infoContentView.mas_width).multipliedBy(0.5);
        make.top.bottom.mas_equalTo(self.termsOfServicesButton);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoContentView.mas_bottom).offset(isIPhoneX?54:20);
    }];
}



#pragma mark - 获取富文本文字
- (NSMutableAttributedString *)urlButtonAttributedTextWithText:(NSString *)text {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(text, nil)];
    attText.yy_font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    UIColor *color =  [UIColor colorWithHexString:[self getConfigInfo][@"instructions_color"]];
    attText.yy_color = color;
    attText.yy_underlineStyle = NSUnderlineStyleSingle;
    attText.yy_underlineColor = color;
    attText.yy_alignment = NSTextAlignmentCenter;
    return attText;
}


- (NSMutableAttributedString *)titleBigAttributedText {
    NSString *title = [NSString stringWithFormat:@"%@",[self getConfigInfo][@"title_big"]];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(title, nil)];
    attText.yy_font = [UIFont boldSystemFontOfSize:17];
    UIColor *color = [UIColor colorWithHexString:[self getConfigInfo][@"title_color"]];
    attText.yy_color = color;
    attText.yy_alignment = NSTextAlignmentCenter;
    attText.yy_lineSpacing = 15.0;
    return attText;
}

- (NSMutableAttributedString *)titleAttributedText {
    NSString *title = [NSString stringWithFormat:@"%@",[self getConfigInfo][@"title"]];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(title, nil)];
    attText.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    UIColor *color = [UIColor colorWithHexString:[self getConfigInfo][@"title_color"]];
    attText.yy_color = color;
    attText.yy_alignment = NSTextAlignmentLeft;
    attText.yy_lineSpacing = 15.0;
    
    NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
    textAttach.bounds = CGRectMake(0, 0, 16, 16);
    textAttach.image = [UIImage imageNamed:@"小图标 付费页对勾"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小图标 付费页对勾"]];
    imageView.bounds = CGRectMake(0, 0, 16, 16);
    YYTextAttachment *a = [YYTextAttachment attachmentWithContent:imageView];
    
//    [attText insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach] atIndex:0];
//    [attText appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach]];
    [attText yy_setTextAttachment:a range:NSMakeRange(0, 1)];
    
    return attText;
}

- (NSMutableAttributedString *)infoString {
    NSString *text = [self getConfigInfo][@"instructions_text"];
    NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:text];
    attStrM.yy_font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    NSNumber *alpha = [self getConfigInfo][@"instructions_alpha"];
    UIColor *color = [[UIColor colorWithHexString:[self getConfigInfo][@"instructions_color"]] colorWithAlphaComponent:alpha.doubleValue];
    attStrM.yy_color = color;
    attStrM.yy_alignment = NSTextAlignmentLeft;
    return attStrM;
}


- (NSDictionary *)getConfigInfo {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey];
    NSDictionary *subscribe = dict[@"cloud"][@"subscribe"];
    
//    NSString *limitVersion = subscribe[@"<=version"];
//
//    NSString *current = [TTBaseTools publicBundleVersion];
//
//    NSComparisonResult compareResult = [current compare:limitVersion options:NSNumericSearch];
    //当前版本 >= 限制版本，就返回符合规则的本地的数据
    
//    if (!subscribe || (compareResult == NSOrderedDescending) || (compareResult == NSOrderedSame)) {
//        return   @{
//                   @"subscribe_enter_show":@1,
//                   @"subscribe_payment_id":@"horoscope_vip_week_3days_trial_v1",
//                   @"restore_btn_title":@"Restore",
//                   @"restore_btn_alpha":@1,
//                   @"restore_btn_color":@"000000",
//                   @"title_big":@"Much more than just a daily horoscope",
//                   @"title":@"Detailed future prediction.\nDaily Premium contents.\nAds-free experience.",
//                   @"title_alpha":@1,
//                   @"title_color":@"FFFFFF",
//                   @"pay_btn_text_notvip":@"Get 3-day free trial\nAfter Free-trial:$4.99/week",
//                   @"pay_btn_text_vip":@"Subscribed",
//                   @"pay_btn_text_font":@13,
//                   @"pay_btn_text_alpha":@1,
//                   @"pay_btn_text_color":@"FFFFFF",
//                   @"subscribed_price":@"After Free-trial:$4.99/week",
//                   @"subscribed_price_color":@"333333",
//                   @"subscribed_price_alpha":@1,
//                   @"instructions_text":@"Weekly subscription with a 3-day free trial, then $4.99 per week charged to iTunes Account on confirmation of purchase. Horoscope offers Weekly Premium ($4.99 billed once a week after 3-day free trial expires). Payment will be charged to iTunes Account at confirmation of purchase. Subscriptions automatically renew unless auto-renew is turned off at least 24-hours before the end of the current period Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.",
//                   @"instructions_alpha":@0.3,
//                   @"instructions_color":@"333333",
//                   @"terms_of_services_title":@"Terms of Service",
//                   @"terms_of_services":@"https://dailyhoroscope2019.weebly.com/term-of-service.html",
//                   @"privacy_policy_title":@"Privacy Policy",
    //                   @"privacy_policy":@"https://dailyhoroscope2019.weebly.com/",
//                   @"support_email":@"support@xtoolapp.com"
//                   };
//    }
    return subscribe;
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
            logString = NSLocalizedString(@"Verification failed!\nIf you are sure you have paid successfully, try to restart the App",nil);
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
        [TTPaymentManager shareInstance].isVip = YES;
        
        if (self.vipPriceArray.count <= 1) {
            self.payButton.enabled = NO;
            self.restoreButton.hidden = YES;
        } else {
            [self.subTabview reloadData];
        }
        
        @weakify(self);
        [SVProgressHUD dismiss];
        [UIAlertController showAlertTitle:@"Verification successful" message:@"Congratulations on your successful subscription, now you can enjoy it!" cancelTitle:@"Sure" otherTitle:nil cancleBlock:^{
            @strongify(self);
            [self removeTabBarPaymentItem];
            if (self.navigationController.childViewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                if (self.isTabBarItem) {
                    self.tabBarController.selectedIndex = 0;
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            
        } otherBlock:nil];
        
    } else {
        [SVProgressHUD showErrorWithStatus:logString];
    }
}

#pragma mark - 移除TabBar订阅Item
- (void)removeTabBarPaymentItem {
    NSMutableArray *vcArrM = [NSMutableArray arrayWithArray:self.tabBarController.childViewControllers];
    if (vcArrM.count == 3) {
        [vcArrM removeLastObject];
        
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Discover"] isEqualToString:@"DidSelect"]) {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
            [self.tabBarController.tabBar showBadgeOnItemIndex:1 allCount:2];
        }
    }
    [self.tabBarController setViewControllers:vcArrM.copy];
}

#pragma mark - 配置请求回调
// 开始请求
- (void)requestStarted {
    [self addLoadingViewToSelf];
}

// 请求成功
- (void)requestDidSucceed:(BOOL)didSucceed info:(NSString *)info{
    [self removeLoadingView];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey];
    NSDictionary *subscribe = dict[@"cloud"][@"subscribe"];
    NSArray *payIDs = subscribe[@"subscribe_ids"];
    self.vipPriceArray = [NSArray yy_modelArrayWithClass:[TTPaymentPriceModel class] json:payIDs];
    
    if (didSucceed) {
        [self setReloadViewHidden:YES];
        [self setupUI];
    } else {
        [self setReloadViewHidden:NO];
    }
}

// 请求失败
- (void)setReloadViewHidden:(BOOL)hidden{
    for (UIView *view in self.view.subviews) {
        if (view.tag != bgImgVTag) {
            [view removeFromSuperview];
        }
    }
    [super setReloadViewHidden:hidden];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vipPriceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    TTVipPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTVipPaymentCell class]) forIndexPath:indexPath];
    TTPaymentPriceModel *model = self.vipPriceArray[indexPath.row];
    model.index = indexPath.row + 1;
    cell.model = model;
    cell.payButtonAction = ^(TTPaymentPriceModel *model) {
        @strongify(self);
        [self payWithProduct:model.payment_id];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 判断是否展示订阅列表
- (BOOL)shouldShowSubcribeList {
    /*
     条件:
     1.配置接口返回参数标识是否在黑名单内,如果在黑名单内展示列表,返回错误或者不在黑名单按照下面逻辑展示
     2.配置接口subscribe_list_show字段标识是否展示列表:1.展示列表;0.不展示列表
     备注:
     1.列表数据通过subscribe_id数据获取
     2.单个订阅按钮
     */
    
    BOOL showListView = NO;
    
    NSDictionary *config = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey];
    NSNumber *blackip = config[@"blackip"];
    if (blackip && blackip.integerValue == 1) {
        showListView = YES;
    } else {
        NSNumber *show_list_config = config[@"cloud"][@"subscribe"][@"subscribe_list_show"];
        if (show_list_config && show_list_config.integerValue == 1) {
            showListView = YES;
        } else {
            showListView = NO;
        }
    }
    
    return showListView;
}

@end
