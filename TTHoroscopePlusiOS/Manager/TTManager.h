//
//  XYManager.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTZodiacSelectionManager.h"
#import "TTLocalDataManager.h"
#import "TTHoroscopeModel.h"
#import "TTHomeViewController.h"
#import <AFNetworking/AFNetworking.h>
@protocol XYManagerDelegate<NSObject>
@optional
- (void)zodiacDidChange:(TTZodiacItemModel *)model;
@end

@protocol XYManagertodayDelegate <XYManagerDelegate>
- (void)refreshHomeData;
- (void)managerMacthDidClickWithType:(NSInteger)type;
@end

@protocol XYConfigRequestDelegate<NSObject>
@optional
- (void)requestStarted;
- (void)requestDidSucceed:(BOOL)didSucceed info:(NSString *)info;
@end

@interface TTManager : NSObject

@property(nonatomic,assign) AFNetworkReachabilityStatus networkStatus;

@property (nonatomic, strong)TTZodiacSelectionManager *zodiacManager;
@property (nonatomic, strong)TTLocalDataManager *localDataManager;

@property (nonatomic, strong) NSArray *horoscopeArray;
@property (nonatomic, strong) XYDayModel *todayModel;
@property (nonatomic, strong) XYDayModel *tomorrowModel;
@property (nonatomic, strong) XYDayModel *weekModel;
@property (nonatomic, strong) XYDayModel *monthModel;
@property (nonatomic, strong) XYDayModel *yearModel;
@property (nonatomic, strong) TTZodiacItemModel *itemModel;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *characterArr;
@property (nonatomic, strong) NSDictionary *luckyData;
@property (nonatomic, assign) NSInteger bestMacthType; //1 love  2 friend  3 career
@property (nonatomic, weak) TTHomeViewController *homeVC;
@property (nonatomic, weak) id <XYManagertodayDelegate>homeDelegate;
@property (nonatomic, weak) id <XYManagertodayDelegate>todayDelegate;
@property (nonatomic, weak) id <XYConfigRequestDelegate>requestConfigDelegate;

@property (nonatomic, assign) BOOL isVIPDiscount;
@property (nonatomic, strong) NSArray * priceArray;
@property (nonatomic, strong) NSArray * discountArray;

// 该字段用于打点统计购买的来源
@property (nonatomic, copy) NSString *paySource;

@property (nonatomic, copy) NSString *deepLinkPush;
@property (nonatomic, assign) BOOL isFromTabbar;


@property (nonatomic, assign)BOOL showRedDot;







+ (TTManager *)sharedInstance;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (void)bestMacthDidClickWithType:(NSInteger)type;
- (void)initializeData;
- (void)loadHomeData;
//- (void)loadLuckyData;
- (void)loadLuckyDataComplete:(void(^)(BOOL isSuccess))complete;

- (void)reloadConfigWithDelegate:(id)delegate;

- (void)paymentWithProduckID:(NSString *)produckID;
- (void)checkVipStatusComplete:(void(^)(BOOL isVip))complete;

- (void)deeplinkPushUrl:(NSString *)url;

@end
