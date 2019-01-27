//
//  XYTarotListVC.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/14.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotListVC.h"
#import "TTTarotPickCardVC.h"
#import "TTTarotBreakupVC.h"
#import "TTTarotResultVC.h"
#import "TTTarotBreakupResultVC.h"
#import "TTTarotListCell.h"
#import "TTAdHelpr.h"

@interface TTTarotListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) XYAdObject *interstitialAdObj; /**< 插屏广告对象 */

@end

@implementation TTTarotListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Tarot Readings";
    [self setupUI];
}

- (void)backToPrevious {
    [super backToPrevious];
}

- (void)dealloc {
    
    [[XYLogManager shareManager] uploadAllLog];
    
    if ([TTPaymentManager shareInstance].isVip) {
        return;
    }
    
    if ([[TTAdManager sharedInstance] isShouldShowInterstitialAd]) { // 判断是否应该弹出广告
        XYAdObject *interstitialAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_discover_interstitial showScene:show_scene_discover_interstitial];
        self.interstitialAdObj = interstitialAdObj;
        [interstitialAdObj interstitialAdBlock:^(XYAdPlatform adPlatform, FBInterstitialAd *fbInterstitial, GADInterstitial *gadInterstitial, BOOL isClick, BOOL isLoadSuccess) {
            if (isLoadSuccess) {
                if (adPlatform == XYFacebookAdPlatform) {
                    [fbInterstitial showAdFromRootViewController:[UIViewController currentViewController]];
                    [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdInterstitialType placementId:fbInterstitial.placementID upload:NO];
                } else if (adPlatform == XYAdMobPlatform) {
                    [gadInterstitial presentFromRootViewController:[UIViewController currentViewController]];
                    [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdInterstitialType placementId:gadInterstitial.adUnitID upload:NO];
                }
            }
        }];
        
    }
    
    

}

- (void)setupUI{
    
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, KScreenWidth, KScreenHeight-NAV_HEIGHT) style:UITableViewStyleGrouped];

    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[TTTarotListCell class] forCellReuseIdentifier:NSStringFromClass([TTTarotListCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTTarotListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTTarotListCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = self.titleArr[indexPath.row];
    cell.dicModel = dic;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.isShowTopline = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, 100, 85);
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"What does the future have in store for you? Get the answers you need with these tarot readings.";
    label.font = kFontTitle_L_13;//[UIFont systemFontOfSize:13*KWIDTH];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.lessThanOrEqualTo(view).offset(-70*KWIDTH);
    }];
    return view;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([TTManager sharedInstance].networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [SVProgressHUD showSuccessWithStatus:@"The Internet connection appears to be offline."];
        return;
    }
    
    NSDictionary *dic = self.titleArr[indexPath.row];
    
    /****/
    NSString *key_2 = dic[@"title"];
    key_2 = [key_2 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [[XYLogManager shareManager] addLogKey1:@"discover" key2:key_2.lowercaseString content:nil userInfo:nil upload:YES];
    
    if (indexPath.row == 5) {
        [self addLoadingViewToSelf];
        
        [TTAdHelpr getTitleForType:XYShowAdAdsTarot tarotIndex:(int)(indexPath.row + 1) WithComplete:^(XYResultType btnType) {

            [self removeLoadingView];
            BOOL isAvailable;
            if (btnType == XYResultTypeNotShowBtn) {
                isAvailable = [TTDataHelper tarotAvailableJudgeType:@(indexPath.row+1).stringValue];
                
            }else{
                isAvailable = YES;
            }
            if (isAvailable) {
                TTTarotBreakupVC *VC = [[TTTarotBreakupVC alloc]initWithTarotType:indexPath.row + 1 title:dic[@"content"]];
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                TTTarotBreakupResultVC *VC = [[TTTarotBreakupResultVC alloc]initWithTarotType:indexPath.row + 1];
                [self.navigationController pushViewController:VC animated:YES];
            }
            
        }];
        
    }else{
        [self addLoadingViewToSelf];
         [TTAdHelpr getTitleForType:XYShowAdAdsTarot tarotIndex:(int)(indexPath.row + 1) WithComplete:^(XYResultType btnType) {
            [self removeLoadingView];
            BOOL isAvailable;
             if (btnType == XYResultTypeNotShowBtn) {
                isAvailable = [TTDataHelper tarotAvailableJudgeType:@(indexPath.row+1).stringValue];
            }else{
                isAvailable = YES;
            }
            if (isAvailable) {
                TTTarotPickCardVC *VC = [[TTTarotPickCardVC alloc]initWithTarotType:indexPath.row + 1 title:dic[@"content"]];
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                TTTarotResultVC *VC = [[TTTarotResultVC alloc]initWithTarotType:indexPath.row +1];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }];
        
      
    }
}


- (UIView *)createCellViewTitleStr:(NSString *)titleStr imageStr:(NSString *)imageStr content:(NSString *)content{
    UIView *baseView = [[UIView alloc]init];
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 5;
    //baseView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    UIImageView *iconImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
    [baseView addSubview:iconImgV];
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baseView);
        make.left.equalTo(baseView).offset(20);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont boldSystemFontOfSize:15*KWIDTH];
    titleLabel.textColor = [UIColor whiteColor];
    [baseView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView);
        make.left.equalTo(iconImgV.mas_right).offset(20*KWIDTH);
        //        make.right.lessThanOrEqualTo(baseView).offset(25*KWIDTH);
    }];
    
    UILabel *contentL = [[UILabel alloc]init];
    contentL.text = content;
    contentL.font = kFontTitle_L_11;//[UIFont systemFontOfSize:11*KWIDTH];
    contentL.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    contentL.numberOfLines = 0;
    [baseView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5*KWIDTH);
        make.left.equalTo(titleLabel);
        make.right.lessThanOrEqualTo(baseView).offset(-25*KWIDTH);
        make.bottom.equalTo(baseView);
    }];
    
    return baseView;
}


- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [TTDataHelper readTarotListArray];
    }
    return _titleArr;
}

@end
