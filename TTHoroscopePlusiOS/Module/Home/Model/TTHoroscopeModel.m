//
//  XYHoroscopeModel.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHoroscopeModel.h"

@implementation TTBaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end

@implementation TTHoroscopeModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSNull class]]) {
        return [super setValue:nil forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}

@end


@implementation XYDayModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSNull class]]) {
         [super setValue:nil forKey:key];
    }else{
        if ([key isEqualToString:@"cardList"]) {
            NSArray *arr = value;
            NSMutableArray *muArr = [NSMutableArray array];
            NSMutableArray *muNewsArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                NSNumber *cardType = dic[@"cardType"];
                if (cardType.integerValue == 1) {
                    TTHoroscopeModel *model = [TTHoroscopeModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    self.horoscopeModel = model;
                    [muArr addObject:model];
                }else if(cardType.integerValue == 2){
                    TTScoreModel *model = [TTScoreModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    self.scoreModel = model;
                    [muArr addObject:model];
                }else if (cardType.integerValue == 3){
                    TTBestMacthModel *model = [TTBestMacthModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    self.bestMacthModel = model;
                    [muArr addObject:model];
                }else if (cardType.integerValue == 4){
                    XYTipsModel *model = [XYTipsModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    self.tipsModel = model;
                    [muArr addObject:model];
                }else if (cardType.integerValue == 5){
                    TTNewsModel *model = [TTNewsModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [muArr addObject:model];
                    [muNewsArr addObject:model];
                }else if (cardType.integerValue == 6){
                    XYPlanetModel *model = [XYPlanetModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [muArr addObject:model];
                    self.planetModel = model;
                }else if (cardType.integerValue == 7){
                    TTDailyCompatibilityModel *model = [TTDailyCompatibilityModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [muArr addObject:model];
                    self.dailyCompatibilityModel = model;
                }else if (cardType.integerValue == 8){
                    TTTodyPsychicTipModel *model = [TTTodyPsychicTipModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [muArr addObject:model];
                    self.todyPsychicTipModel = model;
                }
            }
            self.newsArr = muNewsArr.copy;
            [super setValue:muArr.copy forKey:key];
        }else{
            [super setValue:value forKey:key];
        }
        
    }
}

/*
else if (cardType.integerValue == 3){
    XYBestMacthModel *model = [XYBestMacthModel new];
    [model setValuesForKeysWithDictionary:dic];
    self.bestMacthModel = model;
    [muArr addObject:model];
}*/

@end

@implementation TTScoreModel

@end

@implementation TTBestMacthModel

@end

@implementation XYTipsModel

@end

@implementation TTNewsModel

@end

@implementation XYPlanetModel

@end
@implementation TTDailyCompatibilityModel

@end
@implementation TTTodyPsychicTipModel

@end
@implementation TTLuckModel
@end
