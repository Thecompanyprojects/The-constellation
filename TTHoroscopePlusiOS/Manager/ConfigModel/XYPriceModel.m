//
//  XYPriceModel.m
//  VPN
//
//  Created by 王文文 on 2018/3/13.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "XYPriceModel.h"

@implementation XYPriceModel

+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"payid" :@"id",
                        @"detail" : @"description"};
    return dic;
}

@end
