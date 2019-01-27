//
//  XYCompResultViewModel.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYCompResultModel.h"

@interface TTCompResultViewModel : NSObject
@property (nonatomic, weak) id <XYRequestToastProtocol> toastDelegate;
@property (nonatomic, strong) NSMutableArray <XYCompResultModel *> *models;
- (instancetype)initWithZodiacIndex_1:(NSInteger)firstIndex zodiacIndex_2:(NSInteger)secondIndex delegate:(id)delegate;
@end
