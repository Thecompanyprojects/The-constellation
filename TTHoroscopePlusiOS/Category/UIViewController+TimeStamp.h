//
//  UIViewController+TimeStamp.h
//  Horoscope
//
//  Created by KevinXu on 2018/9/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TimeStamp)

@property (nonatomic, copy) NSString *kEnterTimeStamp;    /**< 进入时间 */
@property (nonatomic, copy) NSString *kExitTimeStamp;     /**< 退出时间 */
@property (nonatomic, copy) NSString *kTimeDuration;      /**< 停留时间 */

@property (nonatomic, copy) NSString *kTagString;           /**< 标识 */

@end


