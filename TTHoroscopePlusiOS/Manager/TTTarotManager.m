//
//  XYTarotManager.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/15.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotManager.h"

@interface TTTarotManager ()


@end

@implementation TTTarotManager

+(instancetype)shareInstance{
    static TTTarotManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TTTarotManager alloc]init];
    });
    return _instance;
}

- (void)loadTarotDataWithType:(NSInteger)type Index:(NSInteger)index Complete:(void(^)(NSArray *array,BOOL isSuccess))complete{
    [self loadTarotDataWithType:type Index:index index2:0 Complete:complete];
    /*
    {
        cardType =     (
                        {
                            cardExplanation = "Be organized, stick to your personal routine, and don't gloss over any steps if you want to get the results you have in mind. This could be a day better for practice than for performance. Do your best, be forgiving of yourself about any minor slip-ups, and have no regrets. You know what you're already good at, so focus on that and glide through the day.";
                            cardName = "THE MAGICIAN";
                        }
                        );
        code = 1;
    }
*/
}

- (void)loadTarotDataWithType:(NSInteger)type Index:(NSInteger)index index2:(NSInteger)index2 Complete:(void(^)(NSArray *array,BOOL isSuccess))complete{

    NSMutableDictionary *muDic;
    if (!index2) {
        muDic = [NSMutableDictionary dictionaryWithDictionary:@{@"cardindex":@(index).stringValue,@"tarottype":@(type).stringValue}];
    }else{
        muDic = [NSMutableDictionary dictionaryWithDictionary:@{@"cardindex":@(index).stringValue,@"tarottype":@(type).stringValue,@"cardindex2":@(index2).stringValue}];
    }
    
    [TTRequestTool requestWithURLType:Tarots params:muDic success:^(NSDictionary *dictData) {
        NSNumber *code = dictData[@"code"];
        if (code.integerValue == 1) {
            NSArray *arr = dictData[@"cardType"];
            
            NSMutableArray *muarr = [NSMutableArray array];
            
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:dic];
                if (i==0) {
                    [mudic setValue:@(index) forKey:@"cardindex"];
                }else{
                    [mudic setValue:@(index2) forKey:@"cardindex"];
                }
                [muarr addObject:mudic.copy];
            }
            
            [TTDataHelper saveTarotTimeType:@(type).stringValue];
            [TTDataHelper saveTarotType:@(type).stringValue value:muarr.copy];
            
            [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
                if (isVip) {
                }
            }];
            if (complete) {
                complete(muarr.copy,true);
            }
        }else{
            if (complete) {
                complete(nil,false);
            }
        }
    } failure:^(NSError *error) {
        if (complete) {
            complete(nil,false);
        }
    }];
}


- (void)randomArray{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@1,@2,@3,@4,@5,@6,@7,@(8),@(9),@(10),@(11),@(12),@(13),@(14),@(15),@(16),@(17),@(18),@(19),@(20),@(21),@(22), nil];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=12;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    self.randArr = resultArray;
}

- (void)breakupRandomArray{
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@1,@2,@3,@4,@5,@6,@7,@(8),@(9),@(10),@(11),@(12),@(13),@(14),@(15),@(16),@(17),@(18),@(19),@(20),@(21),@(22), nil];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    NSInteger m=2;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject];
        [startArray removeLastObject];
    }
    self.breakupArr = resultArray;
}

@end
