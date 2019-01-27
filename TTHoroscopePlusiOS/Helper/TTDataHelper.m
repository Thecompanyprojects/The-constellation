//
//  XYDataHelper.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/20.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTDataHelper.h"
#import "KeychainItemWrapper.h"
#import  <Security/Security.h>
@interface TTDataHelper ()

@property (nonatomic, strong) dispatch_queue_t serQueue;

@end
@implementation TTDataHelper
+ (instancetype) shareInstance{
    static TTDataHelper* _instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    }) ;
    return _instance ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _serQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


+(void)saveDataToKeyChainWithKey:(NSString *)key value:(id)value{//Receipt_data
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithAccount:key service:@"Constellation" accessGroup:nil];
    //    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    //    if([string isEqualToString:@""] || !string){
    [keychainItem setObject:value forKey:(__bridge id)kSecAttrGeneric];
    //    }
}

+(NSString *)readDataFromKeyChainWithKey:(NSString *)key{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:key service:@"Constellation" accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

//保存index
+(void)saveZodiacIndex:(NSString *)indexStr{
    [kUserDefaults setObject:indexStr forKey:@"zodiac_index_key"];
    [kUserDefaults synchronize];
}

+(NSString *)readZodiacIndex{
    return [kUserDefaults objectForKey:@"zodiac_index_key"];
}

#pragma mark - 保存和读取UUID
+(void)saveUUIDToKeyChain{
    NSString *string = [self readDataFromKeyChainWithKey:@"uuid_power_vpn"];
    if([string isEqualToString:@""] || !string){
        [[[KeychainItemWrapper alloc] initWithAccount:@"uuid_power_vpn" service:@"Constellation" accessGroup:nil] setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:@"uuid_power_vpn" service:@"Constellation" accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

+(NSArray *)readMonthArray{
    return @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
}

+(NSString *)readPrivacyStr{
    return [NSString stringWithFormat:@"You can subscribe to get access to all existing and future horoscopes and to remove all ads (every day many new horoscopes are added)\n- ** - free of charge; no commitment. After free trial period. it will be auto-renewed as **** Plan(***); cancel anytime\n- Length of subscription: ****\n- Price of subscription: ***.\n- Payment will be charged to iTunes Account at confirmation of purchase\n- Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period\n- Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal\n- Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase\n- No cancellation of the current subscription is allowed during active subscription period\nLEGAL:\nPlease see X Horoscope's \"Terms of Services\" and \"Privacy Policy\":\nTerms of Services: %@\nPrivacy Policy: %@\nCONTACT US:\nIf you have any questions or suggestions, feel free and send them to: support@xtoolapp.com.\nWe’d love to hear from you :)",TermHtml, PrivacyHtml];
}


+(NSArray *)readCharacteristicData{
    //JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"characteristic.json" ofType:nil];
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *array = dic[@"zodiacCharacterList"];
    if (error) {
        return nil;
    }else{
        return array;
    }
}

+(NSString *)readTipsImageStrIndex:(NSInteger)index{
    if (index<7) {
        if (index == 0) return @"";
        if (index == 1) return @"图标 插图里 爱情tips";
        if (index == 2) return @"图标 插图里 健康tips";
        if (index == 3) return @"图标 插图里 财运tips";
        if (index == 4) return @"图标 插图里 家庭tips";
        if (index == 5) return @"图标 插图里 事业tips";
        if (index == 6) return @"图标 插图里 婚姻tips";
    }
    return nil;
}
//保存最新的收据
+ (void)saveLatestReceiptStr:(NSString *)ReceiptStr{
    dispatch_async([TTDataHelper shareInstance].serQueue, ^{
        [self saveDataToKeyChainWithKey:@"latest_receipt" value:ReceiptStr];
    });
}

+ (NSString *)readLatestReceipt{
    return [self readDataFromKeyChainWithKey:@"latest_receipt"];
}

+(void)saveReceiptInfo:(NSString *)ReceiptInfo{
    [self saveDataToKeyChainWithKey:@"Receipt_data" value:ReceiptInfo];
}

+(void)saveTransactionInfo:(NSDictionary *)dic{
    [kUserDefaults setObject:dic forKey:@"TransactionInfo_key"];
    [kUserDefaults synchronize];
}

+(long long)getExpiresDate_ms{
    if ([self getLatestReceiptInfo]) {
        NSNumber *dateNum = [self getLatestReceiptInfo][@"expires_date_ms"];
        return dateNum.longLongValue;
    }
    return 0;
}

+(NSDictionary *)getLatestReceiptInfo{
    if ([TTDataHelper getTransactionInfo]) {
        NSArray *arr = [TTDataHelper getTransactionInfo][@"latest_receipt_info"];
        return arr.lastObject;
    }else{
        return nil;
    }
}

+(NSDictionary *)getTransactionInfo{
    return  [kUserDefaults objectForKey:@"TransactionInfo_key"];
}

#pragma mark - tarot

+(NSArray *)readTarotListArray{
    
    return @[@{@"title":@"Daily Tarot",@"image":@"图标 塔罗 每日",@"content":@"Starting each day with this Tarot reading is a terrific way to get psyched for all the possibilities - and avoid possible pitfalls."},
             @{@"title":@"Love Tarot",@"image":@"图标 塔罗 爱情",@"content":@"Know what's in store for you romantically each day with your Love Tarot reading."},
             @{@"title":@"Daily Career Tarot",@"image":@"图标 塔罗 事业",@"content":@"Before you go to work or pursue a job opportunity, get your Daily Career Tarot reading."},
             @{@"title":@"Yes / No Tarot",@"image":@"图标 塔罗 是否",@"content":@"Get the answer you need ASAP."},
             @{@"title":@"Love Potential Tarot",@"image":@"图标 塔罗 潜在",@"content":@"Before you get too invested in a romance, consult the cards."},
             @{@"title":@"Breakup Tarot",@"image":@"图标 塔罗 分手",@"content":@"Get the insight you're looking for as to why the relationship ended and how to move on."},
             @{@"title":@"Daily Flirt Tarot",@"image":@"图标 塔罗 调情",@"content":@"Crushing on someone but don't know what your next move should be?"}];
}

+(void)saveTarotType:(NSString *)type value:(id)value{
    NSDictionary *dic = [self readTarotListArray][type.integerValue-1];
    [kUserDefaults setObject:value forKey:dic[@"title"]];
    [kUserDefaults synchronize];
}

+(id)readTarotType:(NSString *)type{
    NSDictionary *dic = [self readTarotListArray][type.integerValue-1];
    return [kUserDefaults objectForKey:dic[@"title"]];
}

+(BOOL)tarotAvailableJudgeType:(NSString *)type{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    
    NSDictionary *dic = [self readTarotListArray][type.integerValue-1];
    NSString *oldTimeStr = [kUserDefaults objectForKey:[NSString stringWithFormat:@"%@time",dic[@"title"]]];
    if (!oldTimeStr) {
        return YES;
    }
    if ([oldTimeStr isEqualToString:dateString]) {
        return NO;
    }else{
        return YES;
    }
}

+(void)saveTarotTimeType:(NSString *)type{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    
    NSDictionary *dic = [self readTarotListArray][type.integerValue-1];
    [kUserDefaults setObject:dateString forKey:[NSString stringWithFormat:@"%@time",dic[@"title"]]];
    [kUserDefaults synchronize];
}

+(void)cleanTarotTime{
    for (int i=0; i<[self readTarotListArray].count; i++) {
        NSDictionary *dic = [self readTarotListArray][i];
        [kUserDefaults setObject:@"" forKey:[NSString stringWithFormat:@"%@time",dic[@"title"]]];
        [kUserDefaults synchronize];
    }
}

+(NSString *)readTarotTipsString{
    return @"Tips:\nCome back tomorrow divination your daily horoscope now!";
}

+(void)updateRedDot{
    [kUserDefaults setObject:@(1) forKey:@"tarot_red_dot_show"];
}

+(BOOL)readRedDotShow{
    NSNumber *num = [kUserDefaults objectForKey:@"tarot_red_dot_show"];
    if (!num) {
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)isFirst:(NSString *)classString assist:(NSString *)assist
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:assist] isEqualToString:classString]) {
        return NO;
    }
    [def setObject:classString forKey:assist];
    [def synchronize];
    return YES;
}

+(BOOL)isFirst:(NSString *)classString
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([def objectForKey:classString]) {
        return NO;
    }
    [def setObject:classString forKey:classString];
    [def synchronize];
    return YES;
}

@end
