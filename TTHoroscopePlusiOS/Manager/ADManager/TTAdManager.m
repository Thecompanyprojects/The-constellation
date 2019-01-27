//
//  XYAdManager.m
//  Horoscope
//
//  Created by KevinXu on 2018/10/10.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "TTAdManager.h"
@interface TTAdManager()

@property (nonatomic, strong) NSNumber  *firstCount;
@property (nonatomic, strong) NSNumber  *intervalCount;
@property (nonatomic, strong) NSMutableDictionary <NSString *, XYAdObject *>*adObjetDictM;

@end

@implementation TTAdManager

+ (instancetype)sharedInstance {
    static TTAdManager *_ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ins = [[self alloc] init];
    });
    return _ins;
}

- (NSMutableDictionary *)adObjetDictM {
    if (!_adObjetDictM) {
        _adObjetDictM = [NSMutableDictionary dictionary];
    }
    return _adObjetDictM;
}

- (XYAdObject *)adObjectWithKey:(NSString *)adKey {
    NSParameterAssert(adKey);
    if (self.adObjetDictM.allKeys.count <= 0) {
        return nil;
    }
    XYAdObject *adObj = [self.adObjetDictM objectForKey:adKey];
    return adObj;
}

- (void)saveAdObject:(XYAdObject *)adObject adKey:(NSString *)adKey {
    NSParameterAssert(adObject);
    NSParameterAssert(adKey);
    [self.adObjetDictM setObject:adObject forKey:adKey];
}

- (void)deleteAdObjectWithKey:(NSString *)adKey {
    NSParameterAssert(adKey);
    [self.adObjetDictM removeObjectForKey:adKey];
}


- (NSNumber *)firstCount{
    if (!_firstCount) {
        _firstCount = [[NSNumber alloc]initWithInt:1];
    }
    return _firstCount ;
}

- (NSNumber *)intervalCount{
    if (!_intervalCount) {
        _intervalCount = [[NSNumber alloc]initWithInt:1];
    }
    return _intervalCount;
}

- (BOOL)isShouldShowInterstitialAd {
    NSDictionary *configDict = [self readAdConfig];
    
    // 云控首次启动次数展示广告
    NSNumber *firstTimes_ = configDict[@"discoveryFirstIntAdTimes"];
    
    // 首次启动次数小于云控,计数+1,返回NO
    if (self.firstCount.integerValue < firstTimes_.integerValue) {
        self.firstCount = @(self.firstCount.integerValue +1);
        return NO;
        
    } else if (self.firstCount.integerValue == firstTimes_.integerValue) { // 首次启动次数等于云控,返回YES,计数增大
        self.firstCount = @(100);
        return YES;
    }
    
    // 云控弹出广告次数
    NSNumber *times_ = configDict[@"discoveryIntAdTimes"];
    // 不符合弹出规则,计数+1,返回NO
    if (self.intervalCount.integerValue % (times_.integerValue) != 0) {
        self.intervalCount = @(self.intervalCount.integerValue + 1);
        return NO;
    } else {
        // 弹出广告计数清0
        self.intervalCount = @(self.intervalCount.integerValue + 1);
        return YES;
    }
}

- (NSString *)ad_timeString {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    return [formatter stringFromDate:date];;
}

- (NSString *)ad_versionCode {
    return (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)ad_versionString {
    return (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)ad_countryCode {
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countrycode = [locale localeIdentifier];
    if (countrycode.length >= 2) {
        return [countrycode substringFromIndex:countrycode.length - 2];
    }
    return @"US";
}



// 读取广告配置
- (NSDictionary *)readAdConfig {
    NSDictionary *configDict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey][@"cloud"];
    if (!configDict) {
        configDict = @{@"discoveryFirstIntAdTimes":@(2),
                       @"discoveryIntAdTimes":@(5),
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
    return configDict;
}

@end
