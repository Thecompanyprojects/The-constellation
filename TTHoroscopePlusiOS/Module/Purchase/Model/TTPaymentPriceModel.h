//
//  XTPaymentPriceModel.h
//  XToolSocialContactIOS
//
//  Created by KevinXu on 2018/10/30.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPaymentPriceModel : NSObject

@property (nonatomic, assign) NSInteger index;              /**< 下标 */

@property (nonatomic, copy) NSString *title;                /**< 标题说明 */
@property (nonatomic, copy) NSString *price;                /**< 按钮价格 */
@property (nonatomic, copy) NSString *payment_id;           /**< 订阅ID */
@property (nonatomic, strong) NSArray <NSNumber *>*apply;   /**< 解锁ID */

@end


