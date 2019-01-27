//
//  XYHoroscopeModel.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface TTBaseModel : NSObject            // baseModel

@property (nonatomic, strong) FBNativeAd *nativeAd; /**< facebook广告 */
@property (nonatomic, strong) GADBannerView *gadBanner; /**< 谷歌广告 */
@property (nonatomic, assign) BOOL isAdCanClick; /**< 广告是否可以被点击 */



/// 2:评分 3:匹配 4:tips 5:news 6:星球 7:最佳匹配 8：每日名言 600001:幸运卡片 500001:手相引导 400001: 去订购VIP的卡片
@property (nonatomic, strong) NSNumber *cardType;
@property (nonatomic, strong) NSNumber *tipsType;
@property (nonatomic, assign) NSInteger index;//0 today  1 tomorrow  2 week

@end


@interface TTLuckModel : TTBaseModel
@property (nonatomic, strong) NSDictionary *dic;
@end

@interface TTHoroscopeModel : TTBaseModel            // cardTpye  1

//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSString *horoscrope;
//@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSNumber *zodiacIndex;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;



@end




//==================================================================





@interface TTScoreModel : TTBaseModel            // 评分

@property (nonatomic, strong) NSNumber *careerRating;
@property (nonatomic, strong) NSNumber *familyRating;
@property (nonatomic, strong) NSNumber *healthRating;
@property (nonatomic, strong) NSNumber *loveRating;
@property (nonatomic, strong) NSNumber *marriageRating;
@property (nonatomic, strong) NSNumber *totalRating;
@property (nonatomic, strong) NSNumber *wealthRating;
@property (nonatomic, strong) NSNumber *moneyRating;
@property (nonatomic, strong) NSNumber *moodRating;

/*
 careerRating = 4;
 loveRating = 4;
 moneyRating = 3;
 moodRating = 3;
 totalRating = "3.5";
 */
/*
 cardType = 2;
 careerRating = 2;
 familyRating = 5;
 healthRating = 3;
 loveRating = 2;
 marriageRating = 4;
 totalRating = 5;
 wealthRating = 4;
 */

@end


//==================================================================



@interface TTBestMacthModel : TTBaseModel      //  最佳匹配

@property (nonatomic, strong) NSNumber *careerZodiacIndex;
@property (nonatomic, strong) NSNumber *friendshipZodiacIndex;
@property (nonatomic, strong) NSNumber *loveZodiacIndex;

@end


//==================================================================




@interface XYTipsModel : TTBaseModel           //tips

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;

@end



//==================================================================

@interface TTNewsModel : TTBaseModel

@property (nonatomic, copy) NSString *article_date;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *target_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *article_id;
@property (nonatomic, strong) NSNumber *position;


/*
 {
 "article_date" = "2018-05-04 02:23:29";
 "article_id" = 2649;
 cardType = 5;
 imageUrl = "http://static.ohippo.com/read/content/13678/resources/cover.jpg?mw=400";
 title = "Seducing the Zodiac";
 }
 */

@end
//MARK:- 星球
@interface XYPlanetModel : TTBaseModel
@property (nonatomic, strong) NSArray *data;
//{
//    cardType = 6;
//    data =             (
//                        {
//                            content = "29\U00b0 26' 49\"";
//                            "planet_content" = "Moon in Sagittarius";
//                            "planet_id" = 1;
//                        },
//                        {
//                            content = "24\U00b0 28' 11\"";
//                            "planet_content" = "Sun in Virgo";
//                            "planet_id" = 2;
//                        },
//                        {
//                            content = "21\U00b0 15' 18\"";
//                            "planet_content" = "Mercury in Virgo";
//                            "planet_id" = 3;
//                        },
//                        {
//                            content = "05\U00b0 10' 01\"";
//                            "planet_content" = "Venus in Scorpio";
//                            "planet_id" = 4;
//                        },
//                        {
//                            content = "01\U00b0 27' 02\"";
//                            "planet_content" = "Mars in Aquarius";
//                            "planet_id" = 5;
//                        },
//                        {
//                            content = "19\U00b0 40' 10\"";
//                            "planet_content" = "Jupiter in Scorpio";
//                            "planet_id" = 6;
//                        },
//                        {
//                            content = "02\U00b0 38' 25\"";
//                            "planet_content" = "Saturn in Capricorn";
//                            "planet_id" = 7;
//                        },
//                        {
//                            content = "01\U00b0 55' 01\" R";
//                            "planet_content" = "Uranus in Taurus";
//                            "planet_id" = 8;
//                        },
//                        {
//                            content = "14\U00b0 48' 52\" R";
//                            "planet_content" = "Neptune in Pisces";
//                            "planet_id" = 9;
//                        },
//                        {
//                            content = "18\U00b0 48' 07\" R";
//                            "planet_content" = "Pluto in Capricorn";
//                            "planet_id" = 10;
//                        }
//                        );
//    title = "";
//},
@end

//MARK:- 每日匹配星座模型
@interface TTDailyCompatibilityModel : TTBaseModel

@property (nonatomic, strong) NSDictionary<NSString*,NSString*> *content;

@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, assign) NSInteger sign1;
@property (nonatomic, assign) NSInteger sign2;
@property (nonatomic, strong) NSString *title;
//cardType = 7;
//content =             {
//    Emotional = 76;
//    Intellectual = 100;
//    Physical = 98;
//    Social = 92;
//    Spiritual = 68;
//};
//percent = 86;
//sign1 = 6;
//sign2 = 10;
//title = "Daily Compatibility";
@end
//MARK:- 每日名言模型
@interface TTTodyPsychicTipModel : TTBaseModel       //  day  weeek month year

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *backgroup_url;
@property (nonatomic, copy) NSString *img_url;

//cardType = 8;
//content = " This is a great time to get out of the house and meet people in group settings. Perhaps you can volunteer to help others. Afer all, when do you ever meet anyone just sitting on the couch? ";
//date = "09.17.18";
//title = "Today's Psychic Tip";
// daily compatibility
@end



//=================================================================

@interface XYDayModel : TTBaseModel       //  day  weeek month year

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, copy) NSString *tabTitle;
@property (nonatomic, strong) TTHoroscopeModel *horoscopeModel;
@property (nonatomic, strong) TTScoreModel *scoreModel;
@property (nonatomic, strong) TTBestMacthModel *bestMacthModel;
@property (nonatomic, strong) XYTipsModel *tipsModel;

@property (nonatomic, strong) XYPlanetModel *planetModel;
@property (nonatomic, strong) TTTodyPsychicTipModel *todyPsychicTipModel;
@property (nonatomic, strong) TTDailyCompatibilityModel *dailyCompatibilityModel;

@property (nonatomic, strong) NSArray *newsArr;

@end
