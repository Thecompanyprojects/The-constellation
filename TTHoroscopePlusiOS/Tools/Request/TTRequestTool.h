//
//  XYRequestTool.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/2.
//  Copyright © 2018年 xykj.inc All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestURLType) {
    Horoscopes,//首页
    Match,//匹配
    Lucky,
    Config,
    Article,
    Tarots,
    FeedBack,  // 用户反馈
    DeviceToken//deviceToken
};

@protocol XYRequestToastProtocol<NSObject>
@optional
- (void)requestDidStartShowToast:(BOOL)showToast;
- (void)requestDidFailWithErrorInfo:(NSString *)info showToast:(BOOL)showToast;
- (void)requestDidSuccessShowToast:(BOOL)showToast;
@end

@interface TTRequestTool : NSObject
+ (BOOL)requestWithURLType:(RequestURLType)urlType params:(NSMutableDictionary*)param success:(void (^)(NSDictionary *dictData))success failure:(void (^)(NSError *error))failure;
@end
