//
//  XYPalmReadingVC.m
//  Horoscope
//
//  Created by 郭连城 on 2018/9/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//
#import <TTHoroscopePlusiOS-Swift.h>
#import "TTPalmReadingVC.h"
#import "TTAdHelpr.h"
@interface TTPalmReadingVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GADRewardBasedVideoAdDelegate>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSArray <NSArray <XYPalmReadingModel *>*> *dataSource;
@property(nonatomic,strong) NSMutableDictionary *selectedArr;
@property(nonatomic,strong) NSArray <NSString *> *headerDataSource;
@property(nonatomic,strong) UIButton *footBtn;
@property(nonatomic,assign) XYResultType type;
@property (nonatomic, assign) BOOL isReward; /**< 看过奖励视频了 */
@end

@implementation TTPalmReadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.title = @"Palm Reading";
    self.backgroundImage = [UIImage imageNamed: @"背景图1125 2436"];
    
    [TTAdHelpr recordTheNumberOfPlamReadVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [TTAdHelpr getTitleForType:XYShowAdAdsPalmReading WithComplete:^(XYResultType btnType) {
        self.type = btnType;
        [self.collectionView reloadData];
    }];
}

- (void)clickCompleteBtn{
    
    switch (self.type) {
        case XYResultTypeNotShowBtn:{
            [[XYLogManager shareManager] addLogKey1:@"today" key2:@"plam_button" content:@{} userInfo:nil upload:YES];
            
            XYPalmReadingResultVC *vc = [XYPalmReadingResultVC new];
            vc.selectDic = self.selectedArr;
            [self.navigationController pushViewController:vc animated:true];
        }break;
        case XYResultTypeShowPayBtn:
            NSLog(@"点击了按钮， 需要付费订阅")
            [[XYLogManager shareManager] addLogKey1:@"palmReadVc" key2:@"premiumClick" content:nil userInfo:nil upload:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedVC" object:@{@"className":@"TTVipPaymentController", @"image":@"图标 底导航 付费 激活态", @"title":@"Get Premium" ,@"value":@"", @"title":@""}];
            break;
        case XYResultTypeShowPlayVideoBtn:
            NSLog(@"点击了按钮， 需要观看激励视频")
            
            if ([GADRewardBasedVideoAd sharedInstance].isReady) {
                [GADRewardBasedVideoAd sharedInstance].delegate = self;
                [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
                return;
            }
            
            [GADRewardBasedVideoAd sharedInstance].delegate = self;
            [SVProgressHUD show];
            [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_button_reward scene:request_scene_reward];
     
            break;
    }
    
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XYPalmReadingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYPalmReadingVCCollectionViewCell" forIndexPath:indexPath];
    XYPalmReadingModel *model = self.dataSource[indexPath.section][indexPath.item];
    cell.model = model;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (KScreenWidth - 26)/3 - 0.5;
    if (indexPath.section == 2){
        if (indexPath.item == 3 || indexPath.item == 4){
            return  CGSizeMake(width, width + 10);
        }
        return  CGSizeMake(width, width + 40);
    }else if (indexPath.section == 5){
        if (indexPath.item == 3 || indexPath.item == 4){
            return  CGSizeMake(width, width + 20);
        }
        return  CGSizeMake(width, width + 50);
    }else{
        return CGSizeMake(width, width + 20 + 5);
    }
}

//MARK:- delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   NSArray *sectionModels = self.dataSource[indexPath.section];
    
    for (int i = 0;i<sectionModels.count;i++){
        XYPalmReadingModel *model = sectionModels[i];
        if (model.isSelected){
            model.isSelected = false;
           NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            [self.collectionView reloadItemsAtIndexPaths:@[index]];
        }
    }
    
    XYPalmReadingModel *model = sectionModels[indexPath.item];
    model.isSelected = !model.isSelected;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self.selectedArr setObject:model forKey:@(indexPath.section)];
    
    if (self.selectedArr.count < self.dataSource.count){
        [self.footBtn setEnabled:false];
    }else{
        [self.footBtn setEnabled:true];
    }
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        XYPalmReadingHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        headerView.title.text = self.headerDataSource[indexPath.section];
        headerView.title.font = kFontTitle_L_14;
        return headerView;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
       
        XYPalmReadingFooter *footerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusableViewFooter" forIndexPath:indexPath];
        if (indexPath.section != self.dataSource.count-1){
            [footerView.button setHidden:true];
            return footerView;
        }
        
        footerView.btnType = self.type;
        self.footBtn = footerView.button;
        if (self.selectedArr.count < self.dataSource.count){
            [self.footBtn setEnabled:false];
        }else{
            [self.footBtn setEnabled:true];
        }

        [footerView.button addTarget:self action:@selector(clickCompleteBtn) forControlEvents:UIControlEventTouchUpInside];
         [footerView.button setHidden:false];

        return footerView;
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
     NSString *str = self.headerDataSource[section];
    CGFloat h = [self measureMutilineStringHeight:str andFont:kFontTitle_L_14 andWidthSetup:KScreenWidth-26];
    return (CGSize){KWIDTH,h};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == self.dataSource.count-1){
        return (CGSize){KWIDTH,59};
    }
    return (CGSize){KWIDTH,0.1};
}

#pragma mark - GADRewardBasedVideoAdDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"^^^^^^^^:激励视频广告:完成奖励");
    
    self.isReward = YES;

    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"reward",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"^^^^^^^^:激励视频广告:加载成功");
    [SVProgressHUD dismiss];
    [rewardBasedVideoAd presentFromRootViewController:self];
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"loaded",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"^^^^^^^^:激励视频广告加载失败:%@",error.localizedDescription);
    [SVProgressHUD dismiss];
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"video ad load failed!", nil)];
    
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"failed",@"type":@"reward", @"code":@(error.code), @"message":error.localizedDescription} userInfo:nil upload:NO];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
    
}


- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:关闭");
    if (!self.isReward) {
        [SVProgressHUD showInfoWithStatus:@"sorry, you shut down the ad video without receiving a reward"];
        return;
    }
    
    [GADRewardBasedVideoAd sharedInstance].delegate = nil;
    [[XYAdBaseManager sharedInstance] loadAdWithKey:ios_horoscope_plus_button_reward scene:request_scene_reward];
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"close",@"type":@"reward"} userInfo:nil upload:NO];
    
    
    XYPalmReadingResultVC *vc = [XYPalmReadingResultVC new];
    vc.selectDic = self.selectedArr;
    [self.navigationController pushViewController:vc animated:true];
}


- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:打开");
    [[XYLogManager shareManager] addLogKey1:@"ad" key2:@"admob" content:@{@"action":@"open",@"type":@"reward"} userInfo:nil upload:NO];
}


- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:播放");
}


- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:播放完成");
}


- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBased {
    NSLog(@"^^^^^^^^:激励视频广告:消除");
}



//MARK:- lazy
- (UICollectionView *)collectionView{
    if (!_collectionView){

        CGRect y = CGRectMake(0, NAV_HEIGHT, KScreenWidth, KScreenHeight-NAV_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:y collectionViewLayout:[XYPalmReadingLayout new]];
        [_collectionView registerClass:[XYPalmReadingCell class] forCellWithReuseIdentifier:@"XYPalmReadingVCCollectionViewCell"];
        
        //注册headerView
        [_collectionView registerClass:[XYPalmReadingHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        [_collectionView registerClass:[XYPalmReadingFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableViewFooter"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


- (NSArray <NSArray *>*)dataSource{
    if(!_dataSource){
        _dataSource = [XYPalmReadingModel getModels];
    };
    return _dataSource;
}

- (NSMutableDictionary *)selectedArr{
    if(!_selectedArr){
        _selectedArr = [NSMutableDictionary dictionaryWithCapacity:8];
    }
    return _selectedArr;
}

- (NSArray<NSString *> *)headerDataSource{
    if (!_headerDataSource) {
        _headerDataSource = @[@"1.Compare the pictures below to your own Life Line and select the image that most resembles yours:",
                              @"2.Now select the picture below that most resembles the direction of your Life Line:",
                              @"3.Alright, check off any of the special markings your Life Line may have from the list below:",
                              @"4.Compare the pictures below to your own Head Line and select the image or images that most resembles yours:",
                              @"5.Alright, check off any of the special markings your Head Line may have from the list below:",
                              @"6.Compare the pictures below to your own Head Line and select the image or images that most resembles yours:",
                              @"7.Alright, check off any of the special markings your Heart Line may have from the list below:",
                             @"8.Compare the pictures below to your own hand and select the image that resemble your own:"];
        
    }
    return _headerDataSource;
}


- (float)measureMutilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidthSetup:(float)width{
    
    if (str == nil || width <= 0) return 0;
    
    CGSize measureSize;
//    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
//        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    }else{
        measureSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
//    }
    return ceil(measureSize.height);
    
}
@end


