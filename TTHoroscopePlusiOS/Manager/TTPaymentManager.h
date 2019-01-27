//
//  XYPaymentManage.h
//  VPN
//
//  Created by PanZhi on 2018/3/8.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYPaymentStatus) {
    payment_succeed_status = 0, //购买成功
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
};

@protocol XYPaymentManageDelegate <NSObject>

- (void)paymentTransactionSucceedType:(XYPaymentStatus)SucceedType;
- (void)paymentTransactionFailureType:(XYPaymentStatus)failtype;

@end

@interface TTPaymentManager : NSObject

@property (nonatomic, weak)   id<XYPaymentManageDelegate>delegate;
@property (nonatomic, assign) BOOL                       isVip;

@property (nonatomic, copy) NSString *availableProductID; /**< 可用的产品ID */
@property (nonatomic, strong) NSArray <NSString *>*productIdArray;// 有效的订阅ID数组
@property (nonatomic, strong) NSArray <NSNumber *>*applyCladdID;// 解锁的功能ID

+ (instancetype) shareInstance;

- (void)addPayTransactionObserver;
- (void)removePayTransactionObserver;
- (void)paymentWithProductID:(NSString *)ProductID;
- (void)refreshReceipt;


- (void)checkSubscriptionStatusComplete:(void(^)(BOOL isVip))complete;

@end
