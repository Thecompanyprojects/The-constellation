//
//  XYLocalDataManager.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTZodiacItemModel.h"
@interface TTLocalDataManager : NSObject
@property (nonatomic, strong)NSArray<TTZodiacItemModel *>* zodiacSignModels;
@end
