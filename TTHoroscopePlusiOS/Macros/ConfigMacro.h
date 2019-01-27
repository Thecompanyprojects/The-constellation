//
//  configMacro.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#ifndef ConfigMacro_h
#define ConfigMacro_h

// AppKey
#define kBuglyApID  @"30e8d217d6"
#define kBuglyAppKey  @"7dc4220d-9f9a-4c13-8666-b3d74ba3af3a"

// AppStore AppID
#define kAppID  @"1442752222"

// 加密
#define kBlowFishKey   @"2GIMeS%aJ%"

// 配置本地存储key
#define kConfigUserDefaultLocalKey @"kConfigUserDefaultLocalKey"


//通知
#define PAYMENT_SUCCEED_NOTIFICATION  @"payment_succeed_notification"
#define PAYMENT_FAIL_NOTIFICATION     @"payment_fail_notification"
#define ENTER_FOREGROUND_NOTIFICATION @"enter_foreground_notification"


#define TermHtml                     @"https://dailyhoroscope2019.weebly.com/term-of-service.html"
#define PrivacyHtml                  @"https://dailyhoroscope2019.weebly.com/"

#define MAINURL                      @"http://www.ihoroscopeone.com/api/v3/"
//ihoroscopeone.com
// 打点上传链接
#define StatisticsLogURL    @"http://www.ihoroscopeone.com/api/v3/statistics_log/horoscope_plus_ios"
#define CrashLogURL         @"http://www.ihoroscopeone.com/api/v3/crash_log/horoscope_plus_ios"

//灰色
#define COLOR_GRAY                   [UIColor colorWithWhite:1 alpha:0.5]
//按钮背景色
#define COLOR_BTN                    [UIColor colorWithHex:0xBE5099]

#define LEFT_MARGIN (0)
#define TOP_MARGIN (8*KHEIGHT)
#define CELL_TOP_MARGIN (10*KHEIGHT)
#define CARD_WIDTH_SCALE 0.9;
#define CARD_HEIGHT_SCALE 0.73;

#endif /* configMacro_h */
