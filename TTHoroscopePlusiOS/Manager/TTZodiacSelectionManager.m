//
//  XYZodiacSelectionManager.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTZodiacSelectionManager.h"
#import "TTDataHelper.h"
#import "NSDate+Extension.h"
@implementation TTZodiacSelectionManager
- (instancetype)init{
    self = [super init];
    NSString* selectedZodiacIndexString = [TTDataHelper readZodiacIndex];
    self.showZodiacSelection = selectedZodiacIndexString == nil;
    self.zodiacIndex = selectedZodiacIndexString?selectedZodiacIndexString.integerValue:6;
    return self;
}

- (void)saveZodiacIdToKeychain{
    [TTDataHelper saveZodiacIndex:[NSString stringWithFormat:@"%ld",self.zodiacIndex]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zodiacSelectionDidChange:)]) {
        [self.delegate zodiacSelectionDidChange:self.zodiacIndex];
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    self.zodiacIndex = [self getZodiacIndexWithDate:selectedDate];
}

- (NSInteger)getZodiacIndexWithDate:(NSDate *)selectedDate{
    return [self getZodiacIndexWithMonth:selectedDate.month day:selectedDate.day];
}

- (NSInteger)getZodiacIndexWithMonth:(NSInteger)month day:(NSInteger)day{
    
    /*
     
     3.21——4.19 白羊座
     4.20——5.20 金牛座
     5.21——6.20 双子座
     6.21——7.22 巨蟹座
     7.23——8.22 狮子座
     8.23——9.22 处女座
     9.23——10.22 天秤座
     10.23——11.21 天蝎座
     11.22——12.21 射手座
     12.22——1.19摩羯座
     1.20——2.18 水瓶座
     2.19——3.20 双鱼座
     */
    
    NSArray<NSString *>* zodiacDates = @[
                                         @"03210419",
                                         @"04200520",
                                         @"05210620",
                                         @"06210722",
                                         @"07230822",
                                         @"08230922",
                                         @"09231022",
                                         @"10231121",
                                         @"11221221",
                                         @"12220119",
                                         @"01200218",
                                         @"02190320",
                                         ];
    for (NSInteger i = 0; i<zodiacDates.count; i++) {
        NSString* dateRange = zodiacDates[i];
        NSString* startMonth = [dateRange substringWithRange:NSMakeRange(0, 2)];
        NSString* startDay = [dateRange substringWithRange:NSMakeRange(2, 2)];
        NSString* endMonth = [dateRange substringWithRange:NSMakeRange(4, 2)];
        NSString* endDay = [dateRange substringWithRange:NSMakeRange(6, 2)];
        if ((month == startMonth.integerValue && day >= startDay.integerValue)||(month == endMonth.integerValue && day <= endDay.integerValue)) {
            return i+1;
        }else{
            continue;
        }
    }
    return 0;
}

@end
