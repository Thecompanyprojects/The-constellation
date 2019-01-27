//
//  NSObject+Swizzling.h
//  xk100
//
//  Created by xuyaguang on 2017/5/22.
//  Copyright © 2017年 xiaokang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Swizzling)
/**
 类方法交换
 
 @param originalSelector    原始类方法名
 @param newSelector         新类方法名
 */
+ (void)yg_swizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector;


/**
 实例方法交换
 
 @param originalSelector    原始实例方法名
 @param newSelector         新实例方法名
 */
+ (void)yg_swizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector;

@end
