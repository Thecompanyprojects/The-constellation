//
//  XYBootProcessVC_Helper.m
//  Horoscope
//
//  Created by 郭连城 on 2018/8/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "XYBootProcessVC_Helper.h"

@interface XYBootProcessVC_Helper ()

@end

@implementation XYBootProcessVC_Helper



+ (void)paySourceBoot{
    [TTManager sharedInstance].paySource = @"boot";
}


+ (void)saveZodiacIndex:(NSDate *)selectDate{
    

//        [[XYLogTool sharedLogTool]addLog:[XYLog statisticsLogWithKey1:@"zodiacSelection" key2:@"didPickDate" jsonObjectContent:@{} jsonObjectUserInfo:@{@"date":[NSString stringWithFormat:@"%ld-%ld-%ld",(long)[selectDate year], [selectDate month], [selectDate day] ]}]];
//    
        [TTManager sharedInstance].zodiacManager.selectedDate = selectDate;
        [TTManager sharedInstance].zodiacManager.showZodiacSelection = false;
        [[TTManager sharedInstance].zodiacManager saveZodiacIdToKeychain];
    }


@end
