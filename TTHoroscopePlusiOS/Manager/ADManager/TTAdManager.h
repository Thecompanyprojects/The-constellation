//
//  XYAdManager.h
//  Horoscope
//
//  Created by KevinXu on 2018/10/10.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// ROI 配置URL
//#if DEBUG
//static NSString * const ios_horoscope_ad_config_url         = @"http://204.48.24.106:16010/api/v3/config/horoscope_plus_ios";
//#else
static NSString * const ios_horoscope_ad_config_url             = @"http://www.ihoroscopeone.com/api/v3/config/horoscope_plus_ios";
//#endif

// 广告版位标识:adKey
static NSString * const ios_horoscope_discover_interstitial     = @"ios_horoscope_plus_match_interstitial";
//{363,502}
static NSString * const ios_horoscope_match_interstitial        = @"ios_horoscope_plus_match_interstitial";
//{369,509}
static NSString * const ios_horoscope_discover_native           = @"ios_horoscope_plus_discover_native";
//{364,503}
static NSString * const ios_horoscope_home_native               = @"ios_horoscope_plus_home_native";
//{361,504}
static NSString * const ios_horoscope_home_news_navtive         = @"ios_horoscope_plus_home_news_navtive";
//{365,505}
static NSString * const ios_horoscope_home_news_tomorrow_native = @"ios_horoscope_plus_home_newstomorrow_native";

// Banner 新版本弃用
//{366,506}
static NSString * const ios_horoscope_benefactor_banner         = @"ios_horoscope_benefactor_banner";
//{362,501}
static NSString * const ios_horoscope_lucky_color_banner        = @"ios_horoscope_lucky_color_banner";
//{367,507}
static NSString * const ios_horoscope_lucky_number_banner       = @"ios_horoscope_lucky_number_banner";
//{368,508}
 //手相初次进入
static NSString * const ios_horoscope_plus_chirognomy_interstitial = @"ios_horoscope_plus_chirognomy_interstitial";
//切换星座
static NSString * const ios_horoscope_plus_select_horoscope_interstitial = @"ios_horoscope_plus_select_horoscope_interstitial";
//新闻返回
static NSString * const ios_horoscope_plus_check_news_back_interstitial =
@"ios_horoscope_plus_check_news_back_interstitial";
//激励视频
static NSString * const ios_horoscope_plus_button_reward = @"ios_horoscope_plus_button_reward";
//切换首页item
static NSString * const ios_horoscope_plus_select_date_interstitial = @"ios_horoscope_plus_select_date_interstitial";




// 广告请求场景
static NSString * const request_scene_discover_interstitial     = @"discover_interstitial";
static NSString * const request_scene_match_interstitial        = @"match_interstitial";
static NSString * const request_scene_match_pre_interstitial    = @"match_pre_interstitial";
static NSString * const request_scene_discover_native           = @"discover_native";


static NSString * const request_scene_plam_once_interstitial         = @"request_scene_plam_interstitial";// 新广告 手相解读一次展示

static NSString * const request_scene_switch_constellation_interstitial = @"request_scene_switch_interstitial";//切换星座界面（每次切换展示）

static NSString * const request_scene_look_news_interstitial         = @"request_scene_look_news_interstitial";// 查看新闻  （2 6 9篇 返回时展示）

static NSString * const request_scene_reward                        = @"request_scene_reward";// 激励视频

static NSString * const request_scene_select_date_interstitial       = @"select_date_interstitial"; //首页切换日期


static NSString * const request_scene_home_native               = @"home_native";
static NSString * const request_scene_home_news_native          = @"home_news_native";
static NSString * const request_scene_home_news_tomorrow_native = @"home_news_tomorrow_native";

//static NSString * const request_scene_home_native               = @"home_native";
//static NSString * const request_scene_home_news_native          = @"home_news_native";
//static NSString * const request_scene_home_news_tomorrow_native = @"home_news_tomorrow_native";

static NSString * const request_scene_benefactor_pre_banner     = @"benefactor_pre_banners";
static NSString * const request_scene_lucky_color_pre_banner    = @"lucky_color_pre_banner";
static NSString * const request_scene_lucky_number_pre_banner   = @"lucky_number_pre_banner";

static NSString * const request_scene_benefactor_banner         = @"benefactor_banner";
static NSString * const request_scene_lucky_color_banner        = @"lucky_color_banner";
static NSString * const request_scene_lucky_number_banner       = @"lucky_number_banner";




// 广告展示场景
static NSString * const show_scene_discover_interstitial        = @"discover_interstitial";
static NSString * const show_scene_match_interstitial           = @"match_interstitial";
static NSString * const show_scene_discover_native              = @"discover_native";
static NSString * const show_scene_home_native                  = @"home_native";
static NSString * const show_scene_home_news_native             = @"home_news_native";
static NSString * const show_scene_home_news_tomorrow_native    = @"home_news_tomorrow_native";

static NSString * const show_scene_benefactor_banner            = @"benefactor_banner";
static NSString * const show_scene_lucky_color_banner           = @"lucky_color_banner";
static NSString * const show_scene_lucky_number_banner          = @"lucky_number_banner";

///新广告 手相解读一次展示
static NSString * const show_scene_plam_once_interstitial            = @"plam_interstitial";
///切换星座界面（每次切换展示）
static NSString * const show_scene_switch_constellation_interstitial = @"switch_constellation_interstitial";
/// 查看新闻  （2 6 9篇 返回时展示）
static NSString * const show_scene_look_news_interstitial            = @"look_news_interstitial";

static NSString * const show_scene_select_date_interstitial_today_to_tomorrow       = @"select_date_interstitial_today_to_tomorrow";
static NSString * const show_scene_select_date_interstitial_tomorrow_to_week       = @"select_date_interstitial_tomorrow_to_week";
static NSString * const show_scene_select_date_interstitial_week_to_month       = @"select_date_interstitial_week_to_month";
static NSString * const show_scene_select_date_interstitial_month_to_year       = @"select_date_interstitial_month_to_year";

//// 首页运势按钮展示激励视频
//static NSString * const show_scene_reward_home  = @"reward_home";
//
//static NSString * const show_scene_reward_hand_answer = @"reward_hand_answer"; //手相占卜答题，下方按钮
//static NSString * const show_scene_reward_tarot  = @"scene_reward_tarot";//塔罗牌答题

// 广告请求场景
static NSString * const request_scene_requet_test1 = @"request_scene_requet_test1";
static NSString * const request_scene_requet_test2 = @"request_scene_requet_test2";

// 广告展示场景
static NSString * const show_scene_requet_test1 = @"show_scene_requet_test1";
static NSString * const show_scene_requet_test2 = @"show_scene_requet_test2";





@interface TTAdManager : NSObject


/**
 实例方法
 */
+ (instancetype)sharedInstance;



/**
 广告对象,adKey见顶部z定义
 */
- (XYAdObject *)adObjectWithKey:(NSString *)adKey;

- (void)saveAdObject:(XYAdObject *)adObject adKey:(NSString *)adKey;

- (void)deleteAdObjectWithKey:(NSString *)adKey;


/*
 判断是否展示插屏广告(发现页子页面返回时)
 */
- (BOOL)isShouldShowInterstitialAd;


/**
 ROI用当前时间
 */
- (NSString *)ad_timeString;

/**
 ROI用构建版本号
 */
- (NSString *)ad_versionCode;

/**
 暂未使用
 */
- (NSString *)ad_versionString;

/**
 设备所在国家的国家代码
 */
- (NSString *)ad_countryCode;

@end


