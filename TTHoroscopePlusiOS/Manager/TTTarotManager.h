//
//  XYTarotManager.h
//  Horoscope
//
//  Created by PanZhi on 2018/5/15.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTarotManager : NSObject

@property (nonatomic, strong) NSArray *randArr;
@property (nonatomic, strong) NSArray *breakupArr;

+(instancetype)shareInstance;
- (void)randomArray;
- (void)breakupRandomArray;
- (void)loadTarotDataWithType:(NSInteger)type Index:(NSInteger)index Complete:(void(^)(NSArray *array,BOOL isSuccess))complete;
- (void)loadTarotDataWithType:(NSInteger)type Index:(NSInteger)index index2:(NSInteger)index2 Complete:(void(^)(NSArray *array,BOOL isSuccess))complete;

@end
