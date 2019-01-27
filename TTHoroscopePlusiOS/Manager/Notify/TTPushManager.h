//
//  RemoteNotifiManager.h
//  XToolWhiteNoiseIOS
//
//  Created by 郭连城 on 2018/8/30.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
@interface TTPushManager: NSObject

//+ (XYPushManager *)shared;

///注册通知
+ (void)registerForRemoteNotification;

///注册设备token
+(void)registerDeviceToken:(NSData *)deviceToken;

///收到推送
+(void)handleRemoteNotification:(NSDictionary *)dic;
@end
