//
//  XYZodiacSelectionViewModel.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTZodiacSelectionViewModel.h"

@implementation TTZodiacSelectionViewModel

- (instancetype)init{
    self = [super init];
    return self;
}

- (CGSize)itemSize{
    return CGSizeMake(KScreenWidth*0.4, KScreenWidth*0.4);
}

- (CGSize)titleSize{
    return CGSizeMake(1/3.0f*KScreenWidth, 65);
}

- (CGFloat)titleGap{
    return 0;
}

- (CGFloat)itemGap{
    return 62*KWIDTH;
}

- (NSUInteger)numberOfItemPerScreen{
    return 3;
}

- (NSRange)stayRange{
    return NSMakeRange(self.dataArray.count/3, self.dataArray.count/3);
}

- (CGFloat)adjustY{
    return 170*KHEIGHT;
}

- (NSArray<TTZodiacItemModel *> *)dataArray{
    return [TTManager sharedInstance].localDataManager.zodiacSignModels;
}

@end
