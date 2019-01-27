//
//  XYManager.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTManager.h"
#import "TTAdHelpr.h"
#import "TTRequestTool.h"
#import "XYPriceModel.h"
#import <YYModel/YYModel.h>
#import "TTPaymentManager.h"
#import "TTVipPaymentController.h"

static int VALUE_INT_NETWORK_SUCCESS_CODE = 1;
@interface TTManager()<XYZodiacSelectionManagerDelegate,XYPaymentManageDelegate>
@property (nonatomic, strong)NSPointerArray * delegates;
@property (nonatomic, strong) TTPaymentManager *payManager;
@property (nonatomic, assign) BOOL isVipPush;
@end

@implementation TTManager
+ (TTManager *)sharedInstance{
    static TTManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TTManager new];
    });
    manager.showRedDot = YES;
    return manager;
}

- (instancetype)init{
    self = [super init];
    self.zodiacManager = [TTZodiacSelectionManager new];
    self.zodiacManager.delegate = self;
    self.localDataManager = [TTLocalDataManager new];
    self.delegates = [NSPointerArray weakObjectsPointerArray];
    self.itemModel = self.localDataManager.zodiacSignModels[self.zodiacManager.zodiacIndex-1];
    NSArray *arr = [TTDataHelper readCharacteristicData];
    self.characterArr = arr[self.zodiacManager.zodiacIndex-1][@"characterList"];
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults]objectForKey:kConfigUserDefaultLocalKey];
    if (dict) {
      //  [self setConfigDict:dict];
    }
   // [self requestConfig];
    _payManager = [TTPaymentManager shareInstance];
    _payManager.delegate = self;
    [_payManager addPayTransactionObserver];
    return self;
}

- (void)initializeData{
//    [self loadLuckyData];
    [self loadHomeData];
}

- (void)loadHomeData{
    [self.homeVC addLoadingViewToSelf];
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [forMatter stringFromDate:date];
    
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc]initWithDictionary:@{@"zodiacIndex":[NSString stringWithFormat:@"%zd",self.zodiacManager.zodiacIndex],@"date":dateStr}];
    [TTRequestTool  requestWithURLType:0 params:mudic success:^(NSDictionary *dictData) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.homeVC removeLoadingView];
        });
        if (dictData) {
            NSNumber *code = dictData[@"code"];
            if (code.integerValue == 1) {
                [self.homeVC setReloadViewHidden:YES];
            }else {
                [self.homeVC setReloadViewHidden:NO type:SERVICE_ERROR];
                return;
            }
            NSArray *arr = dictData[@"data"];
            NSMutableArray *muArr = [NSMutableArray array];
            NSMutableArray *titleMuArr = [NSMutableArray array];
            
            
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                XYDayModel *model = [XYDayModel new];
                [model setValuesForKeysWithDictionary:dic];
                model.horoscopeModel.index = i;
                [muArr addObject:model];

                if ([model.tabTitle isEqualToString:@"Today"]) {
                    self.todayModel = model;
                }else if ([model.tabTitle isEqualToString:@"Tomorrow"]){
                    self.tomorrowModel = model;
                }else if ([model.tabTitle isEqualToString:@"Week"]){
                    self.weekModel = model;
                }else if ([model.tabTitle isEqualToString:@"Month"]){
                    self.monthModel = model;
                } else if ([model.tabTitle isEqualToString:@"Year"]){
                    self.yearModel = model;
                }
                
                [titleMuArr addObject:model.tabTitle];
            }
            self.titleArr = titleMuArr.copy;
            self.horoscopeArray = muArr.copy;
        }
    } failure:^(NSError *error) {
            [self.homeVC removeLoadingView];
            [self.homeVC setReloadViewHidden:NO type:NOT_NEIWORK];
    }];
}


- (void)loadLuckyDataComplete:(void(^)(BOOL isSuccess))complete{
    __weak typeof(self) weakself = self;
    
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [forMatter stringFromDate:date];
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc]initWithDictionary:@{@"zodiacIndex":[NSString stringWithFormat:@"%zd",self.zodiacManager.zodiacIndex],@"date":dateStr}];
    [TTRequestTool requestWithURLType:Lucky params:mudic success:^(NSDictionary *dictData) {
        NSNumber *code = dictData[@"code"];
        if (code.integerValue == 1) {
            weakself.luckyData = dictData[@"data"];
            if (complete) complete(YES);
        }else{
            if (complete) complete(NO);
        }
    } failure:^(NSError *error) {
        if (complete) complete(NO);
    }];
}

- (void)requestConfig{
    /*
     "ad_enable" = 1;
     "guide_rate_enable" = 1;
     "rate_enable" = 0;
     "vpn_enable" = 1;
     "vpn_request_ad_enable" = 0;
     */
    @weakify(self);
    if (self.requestConfigDelegate && [self.requestConfigDelegate respondsToSelector:@selector(requestStarted)]) {
        [self.requestConfigDelegate requestStarted];
    }
    
    NSDictionary *params = @{@"time":[TTAdManager sharedInstance].ad_timeString,
                             @"app_version":[TTAdManager sharedInstance].ad_versionCode,
                             @"country_code":[TTAdManager sharedInstance].ad_countryCode};
    
    NSDictionary *params_e = @{@"data":params};
    
   BOOL res = [TTRequestTool requestWithURLType:Config params:params_e.mutableCopy success:^(NSDictionary* response){
       @strongify(self);
        if (response && [response[@"code"] integerValue] == VALUE_INT_NETWORK_SUCCESS_CODE) {
            NSDictionary * config_dict = response[@"data"];
//            NSDictionary *vipDic = config_dict[@"vip"];
//            NSArray *discountArr = vipDic[@"discount"];
//            NSArray *priceArr = vipDic[@"price"];
//            weakself.discountArray = discountArr.copy;
//            weakself.priceArray = priceArr.copy;
            
            // 本地存储配置信息
            [self setConfigDict:config_dict];
            
            // 代理回调
            if (self.requestConfigDelegate &&[self.requestConfigDelegate respondsToSelector:@selector(requestDidSucceed:info:)]) {
                [self.requestConfigDelegate requestDidSucceed:YES info:nil];
                self.requestConfigDelegate = nil;
            }
            
        }else{
            if (self.requestConfigDelegate && [self.requestConfigDelegate respondsToSelector:@selector(requestDidSucceed:info:)]) {
                [self.requestConfigDelegate requestDidSucceed:NO info:response[@"code"]?[NSString stringWithFormat:@"%@",response[@"code"]]:@"noneCode"];
                self.requestConfigDelegate = nil;
            }
        }
       
    } failure:^(NSError*error){
        @strongify(self);
        if ([self.requestConfigDelegate respondsToSelector:@selector(requestDidSucceed:info:)]) {
            [self.requestConfigDelegate requestDidSucceed:NO info:error.localizedDescription?[NSString stringWithFormat:@"%@",error.localizedDescription]:@"noneDesc"];
            self.requestConfigDelegate = nil;
        }
    }];
    if (!res) {
        if (self.requestConfigDelegate && [self.requestConfigDelegate respondsToSelector:@selector(requestDidSucceed:info:)]) {
            [self.requestConfigDelegate requestDidSucceed:NO info:@"Invalid Request"];
            self.requestConfigDelegate = nil;
        }
    }
}
- (void)setRequestConfigDelegate:(id<XYConfigRequestDelegate>)requestConfigDelegate{
    _requestConfigDelegate = requestConfigDelegate;
}

- (void)reloadConfigWithDelegate:(id)delegate{
    self.requestConfigDelegate = delegate;
    [self requestConfig];
}

- (void)setConfigDict:(NSDictionary*)config_dict{
    if (!config_dict) {
        return;
    }
    
    NSDictionary *dictResult = [NSDictionary changeType:config_dict];
    
    [[NSUserDefaults standardUserDefaults]setObject:dictResult forKey:kConfigUserDefaultLocalKey];
//    if ([config_dict objectForKey:@"vip"]) {
//        NSDictionary *dictVIP = dictResult[@"vip"];
//        if ([dictVIP objectForKey:@"price"] && [dictVIP[@"price"] isKindOfClass:[NSArray class]]) {
//              _priceArray = [NSArray yy_modelArrayWithClass:[XYPriceModel class] json:dictVIP[@"price"]];
//        }
//        if (_isVIPDiscount && [dictVIP objectForKey:@"discount"] && [dictVIP[@"discount"] isKindOfClass:[NSArray class]]) {
//            _discountArray = [NSArray yy_modelArrayWithClass:[XYPriceModel class] json:dictVIP[@"discount"]];
//            
//        }
//    }

}

//- (NSArray *)priceArray{
//    if (!_priceArray) {
//        _priceArray = [NSArray yy_modelArrayWithClass:
//                       [XYPriceModel class] json:@[@{@"type":@"normal",
//                                                    @"id":@"horoscope_vip_month_normal_v1",
//                                                    @"name":@"1 Month",
//                                                    @"description":@"Get Premium $11.99/Month",
//                                                    @"trialTitle":@"After Free-trial : $11.99/Month",
//                                                    @"tag":@""}]];
//    }
//    return _priceArray;
//}

- (void)addDelegate:(id)delegate{
    if (!delegate) {
        return;
    }
    BOOL isDuplicated = NO;
    for (id obj in self.delegates) {
        if (obj == delegate) {
            isDuplicated = YES;
            break;
        }
    }
    //去重
    if (!isDuplicated) {
        [self.delegates addPointer:(__bridge void * _Nullable)(delegate)];
        if ([delegate respondsToSelector:@selector(zodiacDidChange:)]) {
            TTZodiacItemModel* model = self.localDataManager.zodiacSignModels[self.zodiacManager.zodiacIndex-1];
            [delegate zodiacDidChange:model];
        }
    }
    NSMutableArray<NSNumber *>* indexArr =[NSMutableArray new];
    //移除Null
    for (int i = 0; i< self.delegates.count; i++) {
        id obj =[self.delegates pointerAtIndex:i];
        if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
            [indexArr addObject:@(i)];
        }
    }
    if (indexArr.count) {
        [indexArr sortUsingComparator:^NSComparisonResult(__strong id obj1, __strong id obj2){
            return [obj1 intValue] > [obj2 intValue];
        }];
    }
    [indexArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop){
        [self.delegates removePointerAtIndex:obj.integerValue];
    }];
}

- (void)removeDelegate:(id)delegate{
    NSInteger index = -1;
    for (int i = 0; i< self.delegates.count; i++) {
        id obj =[self.delegates pointerAtIndex:i];
        if (obj == delegate) {
            index = i;
            break;
        }
    }
    if (index == -1) {
        return;
    }
    [self.delegates removePointerAtIndex:index];
}

#pragma mark - XYZodiacSelectionManagerDelegate

- (void)zodiacSelectionDidChange:(NSInteger)index{
    [self.payManager checkSubscriptionStatusComplete:^(BOOL isVip) {
        NSLog(@"%@",isVip ? @"YES": @"NO");
    }];
    TTZodiacItemModel* model = self.localDataManager.zodiacSignModels[index-1];
    self.characterArr = [TTDataHelper readCharacteristicData][index-1][@"characterList"];
    NSLog(@"%zd",self.zodiacManager.zodiacIndex);
    self.itemModel = model;
//    [self loadLuckyData];
    [self loadHomeData];
    
    if (self.homeDelegate  && [self.homeDelegate respondsToSelector:@selector(zodiacDidChange:)]) {
        [self.homeDelegate zodiacDidChange:model];
    }
    
}

- (void)setHoroscopeArray:(NSArray *)horoscopeArray{
    _horoscopeArray = horoscopeArray;
    if (self.homeDelegate && [self.homeDelegate respondsToSelector:@selector(refreshHomeData)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.homeDelegate refreshHomeData];
        });
    }
}

- (void)setHomeDelegate:(id<XYManagertodayDelegate>)homeDelegate{
    _homeDelegate = homeDelegate;
    if (_homeDelegate && [_homeDelegate respondsToSelector:@selector(refreshHomeData)] && self.horoscopeArray && [self.horoscopeArray respondsToSelector:@selector(count)] && self.horoscopeArray.count) {
        [self.homeDelegate refreshHomeData];
    }
}

//- (void)delegateMethod:(SEL)method objc:(id)objc1 objc:(id)objc2{
//    for (id delegate in [self.delegates copy]) {
//        if (delegate != NULL && [delegate respondsToSelector:method]) {
//            [delegate performSelector:method withObject:objc1 withObject:objc2];
//        }
//    }
//}

- (void)bestMacthDidClickWithType:(NSInteger)type{
    self.bestMacthType = type;
    NSArray *arr;
    if (type == 0) {//
        NSLog(@"0 ------- %zd",self.todayModel.bestMacthModel.loveZodiacIndex.integerValue);
       arr = [TTDataHelper readCharacteristicData][self.todayModel.bestMacthModel.loveZodiacIndex.integerValue-1][@"characterList"];
    }else if (type == 1){
        NSLog(@"1 ------- %zd",self.todayModel.bestMacthModel.friendshipZodiacIndex.integerValue);
        arr = [TTDataHelper readCharacteristicData][self.todayModel.bestMacthModel.friendshipZodiacIndex.integerValue-1][@"characterList"];
    }else if (type == 2){
        NSLog(@"2 ------- %zd",self.todayModel.bestMacthModel.careerZodiacIndex.integerValue);
        arr = [TTDataHelper readCharacteristicData][self.todayModel.bestMacthModel.careerZodiacIndex.integerValue-1][@"characterList"];
    }
    self.characterArr = arr;
    if (self.todayDelegate && [self.todayDelegate respondsToSelector:@selector(managerMacthDidClickWithType:)]) {
        [self.todayDelegate managerMacthDidClickWithType:type];
    }
}


#pragma mark - payment

- (void)paymentWithProduckID:(NSString *)produckID{
    [self.payManager paymentWithProductID:produckID];
    [TTLoadingHUD show];
}

- (void)checkVipStatusComplete:(void(^)(BOOL isVip))complete{
    
    [self.payManager checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
//            [XYDataHelper cleanTarotTime];
        }
        complete(isVip);
    }];
   // [self.payManager checkSubscriptionStatusComplete:complete];
}

- (void)paymentTransactionSucceedType:(XYPaymentStatus)SucceedType{
//    [[NSNotificationCenter defaultCenter]postNotificationName:PAYMENT_SUCCEED_NOTIFICATION object:nil userInfo:@{@"type":@(SucceedType)}];
    [TTLoadingHUD dismiss];

    /****/
    [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"success" content:@{@"state":[self paymentStateWithType:SucceedType], @"source":self.paySource?:@"default"} userInfo: nil upload:YES];
}

- (void)paymentTransactionFailureType:(XYPaymentStatus)failtype{
//    [[NSNotificationCenter defaultCenter]postNotificationName:PAYMENT_FAIL_NOTIFICATION object:nil userInfo:@{@"type":@(failtype)}];
    [TTLoadingHUD dismiss];
    
    /****/
    [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"failed" content:@{@"state":[self paymentStateWithType:failtype], @"source":self.paySource?:@"default"} userInfo: nil upload:YES];
}

- (NSString *)paymentStateWithType:(XYPaymentStatus)type {
    /*
     payment_succeed_status, //购买成功
     verify_timeout_status,  //购买成功 验证超时
     verify_fail_status,     //购买成功 验证失败
     payment_fail_status,    //支付超时
     no_product_status,      //没有商品
     bought_status,          //购买过
     Transaction_fail_status,//交易失败
     vip_Expires_status,     //vip已过期
     app_store_connect_fail_status, //App Store连接失败
     not_allowed_pay_status, //该设备不允许支付或不能支付
     user_cancel             // 用户取消
     */
    NSString *state = @"unknown";
    switch (type) {
        case payment_succeed_status:state = @"payment_succeed_status";   break;
        case verify_timeout_status:state = @"verify_timeout_status";    break;
        case verify_fail_status:state = @"verify_fail_status";       break;
        case payment_fail_status:state = @"payment_fail_status";      break;
        case no_product_status:state = @"no_product_status";        break;
        case bought_status:state = @"bought_status";            break;
        case Transaction_fail_status:state = @"transaction_fail_status";  break;
        case vip_Expires_status:state = @"vip_expires_status";       break;
        case app_store_connect_fail_status:state = @"app_store_connect_fail_status"; break;
        case not_allowed_pay_status:state = @"not_allowed_pay_status";   break;
        case user_cancel:state = @"user_cancel";             break;
        default: break;
    }
    return state;
}

#pragma mark -

- (void)deeplinkPushUrl:(NSString *)url{
    
    NSArray *dataArr = [url componentsSeparatedByString:@"."];
    self.deepLinkPush = dataArr.lastObject;
    if (self.isFromTabbar) {
        [self pushDeeplink];
    }
//    NSArray *dataArr = [url componentsSeparatedByString:@"."];
//    NSString *str = dataArr.lastObject;
/****///        UIViewController *vc =  [UIViewController currentViewController];
//        VipPaymentController *paymentvc = [[VipPaymentController alloc]init];
//        paymentvc.isFullScreen = YES;
//        [vc.navigationController pushViewController:paymentvc animated:YES];
//    }
}

- (void)setIsFromTabbar:(BOOL)isFromTabbar{
    _isFromTabbar = isFromTabbar;
    
    if (isFromTabbar && self.deepLinkPush) {

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pushDeeplink];
        });
    }
}

- (void)pushDeeplink{
    if ( [self.deepLinkPush isEqualToString:@"vip"]) {
        
        [TTManager sharedInstance].paySource = @"deep_link_push";
        
        TTVipPaymentController *paymentvc = [[TTVipPaymentController alloc]init];
        paymentvc.isFullScreen = YES;
        paymentvc.hidesBottomBarWhenPushed = YES;
        [self.homeVC.navigationController pushViewController:paymentvc animated:YES];
    }
}


@end
