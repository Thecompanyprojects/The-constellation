//
//  TTPushManager+TTPushManager_Extension.h
//  XToolWhiteNoiseIOS
//
//  Created by 郭连城 on 2018/8/31.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTPushManager.h"

@interface TTPushManager (Extension)
+ (void)registLocalNotificationTitle:(NSString *)title
                          WithBody:(NSString *)subTitle
                          WithBody:(NSString *)body
                    WithIdentifier:(NSString *)identifier;
@end
