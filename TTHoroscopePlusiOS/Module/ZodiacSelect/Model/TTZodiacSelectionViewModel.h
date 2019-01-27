//
//  XYZodiacSelectionViewModel.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTZodiacItemModel.h"

@interface TTZodiacSelectionViewModel : NSObject
@property (nonatomic, strong) NSArray<TTZodiacItemModel *>* dataArray;
@property (nonatomic, assign) NSRange stayRange;
@property (nonatomic, assign) NSUInteger numberOfItemPerScreen;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemGap;
@property (nonatomic, assign) CGFloat titleGap;
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) CGFloat adjustY;
@end
