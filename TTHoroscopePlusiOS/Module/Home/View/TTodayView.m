//
//  XYTodayView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//
#import <TTHoroscopePlusiOS-Swift.h>

#import "TTodayView.h"
#import "TTConstellationCardCell.h"
#import "TTHoroscopeModel.h"
#import "TTBestMatchView.h"
#import "TTBestMatchCell.h"
#import "TTScoreCardCell.h"
#import "TTHomeTipsCell.h"
#import "TTHomeNewsCell.h"
#import "TTHomeCardNormalCell.h"

#import "TTFBNativeAdBigCell.h"
#import "TTFBNativeAdNormalCell.h"
#import "TTTarotCardGuideCell.h"

@interface TTodayView () <UITableViewDelegate,UITableViewDataSource,XYConstellationCardCellDelegate, XYAdObjectDelegate,XYTodyPsychicTipDelegage>
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) TTHomeCardNormalCell *conCell;
@property (nonatomic, strong) NSIndexPath *tipCellIndexPath;

@property (nonatomic, strong) XYAdObject *bigNativeAdObj;
@property (nonatomic, strong) XYAdObject *normalNativeAdObj;

@end

@implementation TTodayView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger )type{
    self=  [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.mas_equalTo(self);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            
        } else {
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0);
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.frame = self.bounds;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[TTConstellationCardCell class] forCellReuseIdentifier:NSStringFromClass([TTConstellationCardCell class])];
        [_tableView registerClass:[TTBestMatchCell class] forCellReuseIdentifier:NSStringFromClass([TTBestMatchCell class])];
        [_tableView registerClass:[TTScoreCardCell class] forCellReuseIdentifier:NSStringFromClass([TTScoreCardCell class])];
        [_tableView registerClass:[TTHomeTipsCell class] forCellReuseIdentifier:NSStringFromClass([TTHomeTipsCell class])];
        [_tableView registerClass:[TTHomeNewsCell class] forCellReuseIdentifier:NSStringFromClass([TTHomeNewsCell class])];
        [_tableView registerClass:[TTHomeCardNormalCell class] forCellReuseIdentifier:NSStringFromClass([TTHomeCardNormalCell class])];
        
        [_tableView registerClass:[TTFBNativeAdBigCell class] forCellReuseIdentifier:NSStringFromClass([TTFBNativeAdBigCell class])];
        [_tableView registerClass:[TTFBNativeAdNormalCell class] forCellReuseIdentifier:NSStringFromClass([TTFBNativeAdNormalCell class])];
        [_tableView registerClass:[TTTarotCardGuideCell class] forCellReuseIdentifier:NSStringFromClass([TTTarotCardGuideCell class])];
        
        [_tableView registerClass:[XYCelestialPlanetCell class] forCellReuseIdentifier:NSStringFromClass([XYCelestialPlanetCell class])];
        [_tableView registerClass:[XYTodyPsychicTipCell class] forCellReuseIdentifier:NSStringFromClass([XYTodyPsychicTipCell class])];
        [_tableView registerClass:[XYDailyCompatibilityTableCell class] forCellReuseIdentifier:NSStringFromClass([XYDailyCompatibilityTableCell class])];
        [_tableView registerClass:[XYPalmistryCell class] forCellReuseIdentifier:NSStringFromClass([XYPalmistryCell class])];
          [_tableView registerClass:[XYLuckyViewCell class] forCellReuseIdentifier:NSStringFromClass([XYLuckyViewCell class])];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TTBaseModel *cModel = self.model.cardList[indexPath.row];
    if (cModel.cardType.integerValue == 5 || cModel.cardType.integerValue == 300001) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayPushWebViewWithModel:)]) {
            [self.delegate todayPushWebViewWithModel:(TTNewsModel *)cModel];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayViewDidClickModel:)]) {
            [self.delegate todayViewDidClickModel:cModel];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.cardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTBaseModel *cModel = self.model.cardList[indexPath.row];
    if (cModel.cardType.integerValue == 300001) {
        TTTarotCardGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTTarotCardGuideCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
        
    } else if (cModel.cardType.integerValue == 100001) {
        TTFBNativeAdBigCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTFBNativeAdBigCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.adModel = cModel;
        return cell;
        
    } if (cModel.cardType.integerValue == 100002) {
        TTFBNativeAdNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTFBNativeAdNormalCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.adModel = cModel;
        return cell;
        
    } else if (cModel.cardType.integerValue == 1) {
        if (_type == 0) {
            TTConstellationCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTConstellationCardCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.model = self.model.horoscopeModel;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }else {
            TTHomeCardNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTHomeCardNormalCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            self.conCell = cell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.model = self.model.horoscopeModel;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
    }else if (cModel.cardType.integerValue == 2){//评分
        TTScoreCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTScoreCardCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if (cModel.cardType.integerValue == 3){//匹配
        TTBestMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTBestMatchCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else if (cModel.cardType.integerValue == 4){//tips
        TTHomeTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTHomeTipsCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.model = (XYTipsModel *)cModel;
        return cell;
        
    } else if (cModel.cardType.integerValue == 5){//news
        TTHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTHomeNewsCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.model = (TTNewsModel *)cModel;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if (cModel.cardType.integerValue == 6){ //星球
        XYCelestialPlanetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYCelestialPlanetCell class]) forIndexPath:indexPath];
        cell.model = (XYPlanetModel *)cModel;
        return cell;

    }else
        if (cModel.cardType.integerValue == 7){ //最佳匹配
        
        XYDailyCompatibilityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYDailyCompatibilityTableCell class]) forIndexPath:indexPath];
        cell.model = (TTDailyCompatibilityModel *)cModel;
        return cell;
    }else if (cModel.cardType.integerValue == 8){ //每日名言
          XYTodyPsychicTipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYTodyPsychicTipCell class]) forIndexPath:indexPath];
        cell.model = (TTTodyPsychicTipModel *)cModel;
        self.tipCellIndexPath = indexPath;
        cell.delegate = self;
        return cell;
    }else if (cModel.cardType.integerValue == 500001){
        XYPalmistryCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([XYPalmistryCell class])];
        return  cell;
    }else if (cModel.cardType.integerValue == 600001){
        XYLuckyViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([XYLuckyViewCell class])];
            cell.dic = ((TTLuckModel *)cModel).dic;
        return  cell;
    }else {//只为消除警告
        XYTodyPsychicTipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYTodyPsychicTipCell class]) forIndexPath:indexPath];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    }
    //    return 320;
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CELL_TOP_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CELL_TOP_MARGIN;
}

//MARK:- XYTodyPsychicTipDelegage
- (void)refresPsychicTipCellWithCell:(XYTodyPsychicTipCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - XYConstellationCardCellDelegate
- (void)cardCellDidClickMoreBtnWithModel:(TTHoroscopeModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(todayViewDidClickMoreBtnWithModel:)]) {
        [self.delegate todayViewDidClickMoreBtnWithModel:model];
    }
}

- (void)setModel:(XYDayModel *)model{
    _model = model;
    NSDictionary *adConfigDict = [self readAdConfig];
    
    if ([model.tabTitle isEqualToString:@"Today"]) {
        // 引导卡片
        if ([adConfigDict[@"TarotCardGuide"] isEqualToNumber:@(1)]) {
            if (![self doubleWithTag:300001]) {
                TTBaseModel *adModel = [[TTBaseModel alloc] init];
                adModel.cardType = @(300001);
                NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:model.cardList];
                NSNumber *numberIndex = adConfigDict[@"TarotCardGuideIndex"];
                [arrM_ insertObject:adModel atIndex:numberIndex.integerValue];
                model.cardList = arrM_.copy;
                _model = model;
            }
        }
        [self loadInSertPalmistryCard];
    }
    
    [self.tableView reloadData];
    
    
    // 以下是广告
    if ([model.tabTitle isEqualToString:@"Today"]) {
        [self loadLuckyCard];
        [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
            if (!isVip) {
                if ([adConfigDict[@"nativeHome"] isEqualToNumber:@(1)]) { // 加入广告
                    NSNumber *loc = adConfigDict[@"adHomeLoc"];
                    [self loadBigNativeAd:ios_horoscope_home_native loc:loc];
                }
                
                if ([adConfigDict[@"nativeHomeNews"] isEqualToNumber:@(1)]) { // 加入广告
                    NSNumber *loc_ = adConfigDict[@"adHomeNewsLoc"];
                    [self loadNormalNativeAd:ios_horoscope_home_news_navtive loc:loc_];
                }
            }
        }];
    } else if ([model.tabTitle isEqualToString:@"Tomorrow"]) {
        [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
            if (!isVip) {
                if ([adConfigDict[@"nativeHomeNewsTom"] isEqualToNumber:@(1)]) { // 加入广告
                    NSNumber *loc = adConfigDict[@"adHomeNewsTomLoc"];
                    [self loadNormalNativeAd:ios_horoscope_home_news_tomorrow_native loc:loc];
                }
            }
        }];
    }
    
    NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:model.cardList];
    NSInteger position = 1;
    for (TTBaseModel *m in arrM_){
        if([m.cardType isEqual: @(5)]){
            ((TTNewsModel *)m).position = @(position);
            position += 1;
        }
    }
    model.cardList = arrM_.copy;
}



- (BOOL)doubleWithTag:(NSInteger)tag {
    NSMutableArray *arrM_ = [NSMutableArray arrayWithArray: self.model.cardList];
    for (TTBaseModel *adModel in arrM_) {
        if (adModel.cardType.integerValue == tag) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)indexWithTag:(NSInteger)tag {
    NSInteger index = 0;
    NSMutableArray *arrM_ = [NSMutableArray arrayWithArray: self.model.cardList];
    for(int i = 0;i< arrM_.count;i++){
        TTBaseModel *adModel = arrM_[i];
        if(adModel.cardType.integerValue == tag){
            index = i;
        }
    }
    return index;
}



- (void)dayViewRefreshVipStatus{
    // 刷新卡片
    [self.conCell cardCellRefreshVipStatus];
    
    [self.tableView reloadRowsAtIndexPaths:@[self.tipCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)loadBigNativeAd:(NSString *)placementId loc:(NSNumber *)loc {
    
    [[XYAdBaseManager sharedInstance] loadAdWithKey:placementId scene:request_scene_home_native];
    XYAdObject *todayBigNativeAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:placementId showScene:show_scene_home_native];
    todayBigNativeAdObj.delegate = self;
    self.bigNativeAdObj = todayBigNativeAdObj;
    [todayBigNativeAdObj nativeAdBlock:^(XYAdPlatform adPlatform, FBNativeAd *fbNative, GADBannerView *gadBanner, BOOL isClick, BOOL isLoadSuccess) {
        if (isLoadSuccess) {
            TTBaseModel *adModel = [[TTBaseModel alloc] init];
            adModel.cardType = @(100001);
            adModel.isAdCanClick = isClick;
            NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:self.model.cardList];
            if (adPlatform == XYFacebookAdPlatform) {
                adModel.nativeAd = fbNative;
                if ([self doubleWithTag:100001]) {
                    [arrM_ replaceObjectAtIndex:loc.integerValue withObject:adModel];
                    self.model.cardList = arrM_.copy;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:loc.integerValue inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [arrM_ insertObject:adModel atIndex:loc.integerValue];
                    self.model.cardList = arrM_.copy;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:loc.integerValue inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdNativeType placementId:fbNative.placementID upload:NO];
            } else if (adPlatform == XYAdMobPlatform) {
                if ([self doubleWithTag:100001]) {
                    
                } else {
                    adModel.gadBanner = gadBanner;
                    [arrM_ insertObject:adModel atIndex:loc.integerValue];
                    self.model.cardList = arrM_.copy;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:loc.integerValue inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdNativeType placementId:gadBanner.adUnitID upload:NO];
            }
        }
    }];
}


- (void)loadLuckyCard{
    if([self doubleWithTag:600001]){
        return;
    }
        NSDate *date = [NSDate date]; // 获得时间对象
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [forMatter stringFromDate:date];
    
        NSMutableDictionary *mudic = [[NSMutableDictionary alloc]initWithDictionary:@{@"zodiacIndex":[NSString stringWithFormat:@"%zd",[TTManager sharedInstance].zodiacManager.zodiacIndex],@"date":dateStr}];
        [TTRequestTool requestWithURLType:Lucky params:mudic success:^(NSDictionary *dictData) {
            if([self doubleWithTag:600001]){
                return;
            }
            NSNumber *code = dictData[@"code"];
            if (code.integerValue == 1) {
                TTLuckModel *model = [TTLuckModel new];
                model.dic = dictData[@"data"];
                model.cardType = @(600001);
                NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:self.model.cardList];

                NSInteger index = [self indexWithTag:8];
                
                if (self.model.cardList.count >=5){
                    [arrM_ insertObject:model atIndex:index+1];
                      self.model.cardList = arrM_.copy;
                    [self.tableView reloadData];
                }
            }else{
                
            }
        } failure:^(NSError *error) { }];
}

//MARK:- 插入手相入口卡片
- (void)loadInSertPalmistryCard{
    if ([self doubleWithTag:500001]) {
        return;
    }
    
    //暂时隐藏
     TTBaseModel *adModel = [[TTBaseModel alloc] init];
     adModel.cardType = @(500001);
     NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:self.model.cardList];
    if (self.model.cardList.count >=5){
        [arrM_ insertObject:adModel atIndex:5];
        self.model.cardList = arrM_.copy;
    }
}

- (void)loadNormalNativeAd:(NSString *)placementId loc:(NSNumber *)loc {
    NSString *adRequest = @"";
    NSString *adShow = @"";
    if ([placementId isEqualToString:ios_horoscope_home_news_navtive]) {
        adRequest = request_scene_home_news_native;
        adShow = request_scene_home_news_native;
    } else {
        adRequest = request_scene_home_news_tomorrow_native;
        adShow = show_scene_home_news_tomorrow_native;
    }

    [[XYAdBaseManager sharedInstance] loadAdWithKey:placementId scene:adRequest];
    XYAdObject *normalAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:placementId showScene:adShow];
    normalAdObj.delegate = self;
    self.normalNativeAdObj = normalAdObj;
    [normalAdObj nativeAdBlock:^(XYAdPlatform adPlatform, FBNativeAd *fbNative, GADBannerView *gadBanner, BOOL isClick, BOOL isLoadSuccess) {
        if (isLoadSuccess) {
            
            TTBaseModel *adModel = [[TTBaseModel alloc] init];
            adModel.cardType = @(100002);
            adModel.isAdCanClick = isClick;
            NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:self.model.cardList];
            if (adPlatform == XYFacebookAdPlatform) {
                adModel.nativeAd = fbNative;
                if ([self doubleWithTag:100002]) {
                     NSInteger nowLoc = [self indexWithTag:100002];
                    [arrM_ replaceObjectAtIndex:nowLoc withObject:adModel];
                    self.model.cardList = arrM_.copy;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nowLoc inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [arrM_ insertObject:adModel atIndex:loc.integerValue];
                    self.model.cardList = arrM_.copy;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:loc.integerValue inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdNativeType placementId:fbNative.placementID upload:NO];
                
            } else if (adPlatform == XYAdMobPlatform) {
                adModel.gadBanner = gadBanner;
                if ([self doubleWithTag:100002]) {
                    NSInteger nowLoc = [self indexWithTag:100002];
                    [arrM_ replaceObjectAtIndex:nowLoc withObject:adModel];
                    self.model.cardList = arrM_.copy;
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nowLoc inSection:0]];
                    if(cell){
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nowLoc inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                } else {
                    [arrM_ insertObject:adModel atIndex:loc.integerValue];
                    self.model.cardList = arrM_.copy;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:loc.integerValue inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdNativeType placementId:gadBanner.adUnitID upload:NO];
            }
        }
        
    }];
}

#pragma mark - XYAdObjectDelegate
- (void)adObjectDidClick:(XYAdObject *)adObject {
    NSDictionary *adConfigDict = [self readAdConfig];
    if (adObject == self.normalNativeAdObj) {
        if ([self.model.tabTitle isEqualToString:@"Today"]) {
            NSNumber *loc_ = adConfigDict[@"adHomeNewsLoc"];
            [self loadNormalNativeAd:ios_horoscope_home_news_navtive loc:loc_];
        }
        
        if ([self.model.tabTitle isEqualToString:@"Tomorrow"]) {
            NSNumber *loc = adConfigDict[@"adHomeNewsTomLoc"];
            [self loadNormalNativeAd:ios_horoscope_home_news_tomorrow_native loc:loc];
        }
    } else if (adObject == self.bigNativeAdObj) {
        NSNumber *loc = adConfigDict[@"adHomeLoc"];
        [self loadBigNativeAd:ios_horoscope_home_native loc:loc];
    }

}


- (NSDictionary *)readAdConfig {
    NSDictionary *adConfigDict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"];
    if (!adConfigDict) {
        adConfigDict = @{@"TarotCardGuideIndex":@(3),
                         @"TarotCardGuide":@(1),
                         @"InterstitialDiscover":@(1),
                         @"InterstitialMatch":@(1),
                         @"adHomeLoc":@(2),
                         @"adHomeNewsLoc":@(6),
                         @"adHomeNewsTomLoc":@(2),
                         @"bannerBenefactor":@(1),
                         @"bannerColor":@(1),
                         @"bannerNumber":@(1),
                         @"nativeDiscover":@(1),
                         @"nativeHome":@(1),
                         @"nativeHomeNews":@(1),
                         @"nativeHomeNewsTom":@(1)};
    }
    return adConfigDict;
}

@end
