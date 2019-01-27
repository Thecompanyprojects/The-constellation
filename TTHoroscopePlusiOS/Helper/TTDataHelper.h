//
//  XYDataHelper.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/20.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDataHelper : NSObject
+ (void)saveDataToKeyChainWithKey:(NSString *)key value:(id)value;
+ (NSString *)readDataFromKeyChainWithKey:(NSString *)key;
+ (NSArray *)readMonthArray;
+ (NSString *)readPrivacyStr;
+ (NSString *)readUUIDFromKeyChain;
+ (void)saveUUIDToKeyChain;
+ (void)saveZodiacIndex:(NSString *)indexStr;
+ (NSString *)readZodiacIndex;
+ (NSArray *)readCharacteristicData;
+ (NSString *)readTipsImageStrIndex:(NSInteger)index;
+ (void)saveLatestReceiptStr:(NSString *)ReceiptStr;
+ (NSString *)readLatestReceipt;
+ (void)saveReceiptInfo:(NSString *)ReceiptInfo;
+ (void)saveTransactionInfo:(NSDictionary *)dic;
+ (long long)getExpiresDate_ms;
+ (NSDictionary *)getLatestReceiptInfo;
+ (NSDictionary *)getTransactionInfo;

#pragma mark - tarot
//塔罗牌列表数据
+ (NSArray *)readTarotListArray;
//保存塔罗牌数据
+ (void)saveTarotType:(NSString *)type value:(id)value;
//读取塔罗牌数据
+ (id)readTarotType:(NSString *)type;
//判断当天卡罗牌是否可用
+ (BOOL)tarotAvailableJudgeType:(NSString *)type;
//保存塔罗牌查看日期
+ (void)saveTarotTimeType:(NSString *)type;
//清空tarot时间
+ (void)cleanTarotTime;
+ (NSString *)readTarotTipsString;

+ (void)updateRedDot;
+ (BOOL)readRedDotShow;



/**
 第一次执行某事件
 
 @param classString 类的字符串名
 @param assist 记录的key,辅助记录
 @return 返回是否是第一次
 */
+ (BOOL)isFirst:(NSString *)classString assist:(NSString *)assist;


/**
 第一次执行某事件
 
 @param classString 类的字符串名字 作为key
 @return 返回是否是第一次
 */
+ (BOOL)isFirst:(NSString *)classString;

@end
