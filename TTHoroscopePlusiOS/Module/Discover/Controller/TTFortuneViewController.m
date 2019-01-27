//
//  XYFortuneViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTFortuneViewController.h"
#import "TTPaymentManager.h"

@interface TTFortuneViewController () <XYAdObjectDelegate>

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *crystalBallImgV;
@property (nonatomic, strong) UILabel *luckyNumberL;
@property (nonatomic, strong) UILabel *tipsL;
@property (nonatomic, strong) UILabel *benefactorL;
@property (nonatomic, strong) UIImageView *luckyColorImgV;
@property (nonatomic, strong) UIView *luckyColorView;
@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) XYAdObject *interstitialAdObj; /**< 插屏广告对象 */
@property (nonatomic, strong) XYAdObject *bannerAdObj; /**< 插屏广告对象 */


@end

@implementation TTFortuneViewController


- (instancetype)initWithType:(XYFortuneLuckType)type{
    self = [super init];
    if (self) {
        _luckType = type;
    }
    return self;
}

- (void)dealloc{
    [[XYLogManager shareManager] uploadAllLog];
    
    if ([TTPaymentManager shareInstance].isVip) {
        return;
    }
    
    if ([[TTAdManager sharedInstance] isShouldShowInterstitialAd]) { // 判断是否应该弹出广告
        XYAdObject *interstitialAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_discover_interstitial showScene:show_scene_discover_interstitial];
        self.interstitialAdObj = interstitialAdObj;
        [interstitialAdObj interstitialAdBlock:^(XYAdPlatform adPlatform, FBInterstitialAd *fbInterstitial, GADInterstitial *gadInterstitial, BOOL isClick, BOOL isLoadSuccess) {
            if (isLoadSuccess) {
                
                if (adPlatform == XYFacebookAdPlatform) {
                    [fbInterstitial showAdFromRootViewController:[UIViewController currentViewController]];
                    [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdInterstitialType placementId:fbInterstitial.placementID upload:NO];
                } else if (adPlatform == XYAdMobPlatform) {
                    [gadInterstitial presentFromRootViewController:[UIViewController currentViewController]];
                    [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdInterstitialType placementId:gadInterstitial.adUnitID upload:NO];
                }
            }
        }];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* type;
    switch (self.luckType) {
        case LUCKY_COLOR_TYPE:
            type = @"luckyColor";
            break;
        case LUCKY_NUMBER_TYPE:
            type = @"luckyNum";
            break;
        case BENEFACTOR_TYPE:
            type = @"benefactor";
            break;
        default:
            type = @"none";
            break;
    }
    
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    [self setupUI];
    
    [[TTPaymentManager shareInstance] checkSubscriptionStatusComplete:^(BOOL isVip) {
        if (!isVip) {
            [self loadAd];
        }
    }];
}

- (void)setupUI{
    
    UIView *baseView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.baseView = baseView;
    [self.view addSubview:baseView];
    
    [baseView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView).offset(150*KWIDTH);
        make.centerX.equalTo(baseView);
    }];
    
    [baseView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleL.mas_bottom).offset(15*KHEIGHT);
        make.centerX.equalTo(self.titleL);
    }];
    
    [baseView addSubview:self.crystalBallImgV];
    //    self.crystalBallImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.crystalBallImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(baseView);//460  640
        if (self.luckType == BENEFACTOR_TYPE) {
            make.width.offset(460*0.32*KWIDTH);
            make.height.offset(640*0.32*KWIDTH);
        }
    }];
    
    [baseView addSubview:self.luckyNumberL];
    [self.luckyNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.crystalBallImgV);
    }];
    
    [baseView addSubview:self.luckyColorImgV];
    [self.luckyColorImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.crystalBallImgV);
        make.width.height.offset(60*KWIDTH);
    }];
    
    [self.luckyColorImgV addSubview:self.luckyColorView];
    [self.luckyColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.luckyColorImgV);
        make.width.offset(56*KWIDTH);
        make.height.offset(56*KWIDTH);
    }];
    
    [baseView addSubview:self.benefactorL];
    [self.benefactorL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.crystalBallImgV.mas_bottom).offset(30*KHEIGHT);
        make.centerX.equalTo(self.crystalBallImgV);
    }];
    
    [baseView addSubview:self.tipsL];
    [self.tipsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(baseView);
        make.bottom.equalTo(baseView).offset(- ([self getIsIpad]?10:100));
        make.left.offset(20);
        make.right.offset(-20);
    }];
}

- (void)setLuckType:(XYFortuneLuckType)luckType{
    _luckType = luckType;
    if (luckType == LUCKY_COLOR_TYPE) {
        //        self.benefactorL.alpha = 0;
        self.luckyNumberL.alpha = 0;
        self.title = @"Lucky Color";
        
        
        [self setupLuckyColorData];
    }else if(luckType == LUCKY_NUMBER_TYPE){
        self.luckyColorImgV.alpha = 0;
        self.benefactorL.alpha = 0;
        self.title = @"Lucky Number";
        
        [self setupLuckyNumberData];
    }else if (luckType == BENEFACTOR_TYPE){
        self.luckyNumberL.alpha = 0;
        self.luckyColorImgV.alpha = 0;
        [self.crystalBallImgV setImage:[UIImage imageNamed:@"12宫水晶球 金牛"]];
        self.title = @"Benefactor";
        
        [self setupLuckyBenefactorData];
    }
    
}

- (void)setupLuckyColorData{
    NSDictionary *luckyDic = [TTManager sharedInstance].luckyData[@"lucky_color"];
    if (!luckyDic) return;
    NSNumber *colorNum = luckyDic[@"color"];
    NSString *title = luckyDic[@"color_name"];
    NSInteger colorHex = colorNum.integerValue;
    self.luckyColorView.backgroundColor = [self colorWithHexString:[NSString stringWithFormat:@"0x%@",[self ToHex:colorHex]] alpha:1];
    
    self.benefactorL.text = title;
    
    NSString *tips = luckyDic[@"tips"];
    if (![tips isKindOfClass:[NSNull class]]) {
        self.tipsL.text = [NSString stringWithFormat:@"Tips: %@",tips];
    }
    NSString *titleStr = [TTManager sharedInstance].itemModel.zodiacName;
    self.titleL.text = [NSString stringWithFormat:@"%@ Today's Lucky Color",titleStr];
}

- (void)setupLuckyNumberData{
    NSDictionary *luckyDic = [TTManager sharedInstance].luckyData[@"lucky_number"];
    if (!luckyDic) return;
    NSNumber *number = luckyDic[@"number"];
    self.luckyNumberL.text = [NSString stringWithFormat:@"%zd",number.integerValue];
    
    NSString *tips = luckyDic[@"tips"];
    if (![tips isKindOfClass:[NSNull class]]) {
        self.tipsL.text = [NSString stringWithFormat:@"Tips: %@",tips];
    }
    NSString *titleStr = [TTManager sharedInstance].itemModel.zodiacName;
    self.titleL.text = [NSString stringWithFormat:@"%@ Today's Lucky Number",titleStr];
}

- (void)setupLuckyBenefactorData{
    NSDictionary *luckyDic = [TTManager sharedInstance].luckyData[@"benefactor"];
    if (!luckyDic) return;
    NSNumber *index = luckyDic[@"zodiac_index"];
    TTZodiacItemModel *model = [TTManager sharedInstance].localDataManager.zodiacSignModels[index.integerValue-1];
    
    [self.crystalBallImgV setImage:[UIImage imageNamed:model.imageName]];
    self.benefactorL.text = model.zodiacName;
    
    NSString *tips = luckyDic[@"tips"];
    if (![tips isKindOfClass:[NSNull class]]) {
        self.tipsL.text = [NSString stringWithFormat:@"Tips: %@",tips];
    }
    NSString *titleStr = [TTManager sharedInstance].itemModel.zodiacName;
    self.titleL.text = [NSString stringWithFormat:@"%@ Today's Lucky Benefactor",titleStr];
}
/*
 {
 code = 1;
 data =     {
 benefactor =         {
 tips = "These today's benefactor just a suggestion for your new day.Use them with wisdom and responsibility";
 "zodiac_index" = 2;
 };
 "lucky_color" =         {
 color = 4278255487;
 "color_name" = mintcream;
 tips = "These lucky color just a suggestion for your new day.Use them with wisdom and responsibility";
 };
 "lucky_number" =         {
 number = 84;
 tips = "These lucky number just a suggestion for your new day.Use them with wisdom and responsibility";
 };
 };
 }
 */
- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    UIColor *defaultColor = [UIColor clearColor];
    
    if (hexString.length < 6) return defaultColor;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if ([hexString hasPrefix:@"0X"]) hexString = [hexString substringFromIndex:2];
    //    if (hexString.length != 6) return defaultColor;
    
    //method1
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int hexNumber;
    if (![scanner scanHexInt:&hexNumber]) return defaultColor;
    
    //method2
    const char *char_str = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    int hexNum;
    sscanf(char_str, "%x", &hexNum);
    
    return [UIColor colorWithHex:hexNumber alpha:alpha];
}

/*
 {
 code = 1;
 data =     {
 benefactor =         {
 tips = "These today's benefactor just a suggestion for your new day.Use them with wisdom and responsibility";
 "zodiac_index" = 2;
 };
 "lucky_color" =         {
 color = 4278255487;
 "color_name" = mintcream;
 tips = "These lucky color just a suggestion for your new day.Use them with wisdom and responsibility";
 };
 "lucky_number" =         {
 number = 84;
 tips = "These lucky number just a suggestion for your new day.Use them with wisdom and responsibility";
 };
 };
 }*/

- (NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

- (NSString*)weekDayStr:(NSString *)format
{
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSString *str = [self description];
    if (str.length >= 10) {
        NSString *nowString = [str substringToIndex:10];
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        if (array.count == 0) {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        if (array.count >= 3) {
            NSInteger year = [[array objectAtIndex:2] integerValue];
            NSInteger month = [[array objectAtIndex:0] integerValue];
            NSInteger day = [[array objectAtIndex:1] integerValue];
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger week = [weekdayComponents weekday];
    week ++;
    switch (week) {
        case 1:
            weekDayStr = @"Sunday";
            break;
        case 2:
            weekDayStr = @"Monday";
            break;
        case 3:
            weekDayStr = @"Tuesday";
            break;
        case 4:
            weekDayStr = @"Wednesday";
            break;
        case 5:
            weekDayStr = @"Thursday";
            break;
        case 6:
            weekDayStr = @"Friday";
            break;
        case 7:
            weekDayStr = @"Saturday";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}

- (BOOL)getIsIpad{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"Leo today's Lucky Number";
        _titleL.font = kFontTitle_M_15;//Font_HB(17);
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        NSDate *date = [NSDate date]; // 获得时间对象
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"EEEE,M/d/yyyy"];
        NSString *dateStr = [forMatter stringFromDate:date];
        _timeL.text = [NSString stringWithFormat:@"%@",dateStr];
        _timeL.font = kFontTitle_L_14;//[UIFont systemFontOfSize:14*KWIDTH];
        _timeL.textColor = [UIColor whiteColor];
    }
    return _timeL;
}

- (UIImageView *)crystalBallImgV{
    if (!_crystalBallImgV) {
        _crystalBallImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"水晶球 发现结果页"]];
    }
    return _crystalBallImgV;
}

- (UILabel *)luckyNumberL{
    if (!_luckyNumberL) {
        _luckyNumberL = [[UILabel alloc]init];
        _luckyNumberL.text = @"28";
        _luckyNumberL.font = kFontTitle_M_45;//Font_HB(45*KWIDTH);
        _luckyNumberL.textColor = [UIColor whiteColor];
    }
    return _luckyNumberL;
}

- (UILabel *)tipsL{
    if (!_tipsL) {
        _tipsL = [[UILabel alloc]init];
        _tipsL.text = @"Tips :";
        _tipsL.font = kFontTitle_L_12;//[UIFont systemFontOfSize:12];
        _tipsL.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _tipsL.textAlignment = NSTextAlignmentCenter;
        _tipsL.numberOfLines = 0;
    }
    return _tipsL;
}

- (UILabel *)benefactorL{
    if (!_benefactorL) {
        _benefactorL = [[UILabel alloc]init];
        _benefactorL.text = @"Virgo";
        _benefactorL.font = kFontTitle_M_23;//Font_HB(23*KWIDTH);
        _benefactorL.textColor = [UIColor whiteColor];
    }
    return _benefactorL;
}

- (UIImageView *)luckyColorImgV{
    
    if (!_luckyColorImgV) {
        _luckyColorImgV = [[UIImageView alloc]init];
        _luckyColorImgV.layer.masksToBounds = YES;
        _luckyColorImgV.backgroundColor = [UIColor whiteColor];
        _luckyColorImgV.layer.cornerRadius = 30*KWIDTH;
    }
    return _luckyColorImgV;
}

- (UIView *)luckyColorView{
    if (!_luckyColorView) {
        _luckyColorView = [[UIView alloc]init];
        _luckyColorView.layer.masksToBounds = YES;
        _luckyColorView.layer.cornerRadius = 28*KWIDTH;
    }
    return _luckyColorView;
}

- (void)loadAd {
    
    
    NSString *adKey = @"";
    NSString *adRequest = @"";
    NSString *adShow = @"";
    switch (_luckType) {
        case BENEFACTOR_TYPE: {
            adKey = ios_horoscope_benefactor_banner;
            adRequest = request_scene_benefactor_banner;
            adShow = show_scene_benefactor_banner;
        }; break;
        case LUCKY_COLOR_TYPE: {
            adKey = ios_horoscope_lucky_color_banner;
            adRequest = request_scene_lucky_color_banner;
            adShow = show_scene_lucky_color_banner;
        }; break;
        case LUCKY_NUMBER_TYPE: {
            adKey = ios_horoscope_lucky_number_banner;
            adRequest = request_scene_lucky_number_banner;
            adShow = show_scene_lucky_number_banner;
        }; break;
    }
    
    // 请求
    [[XYAdBaseManager sharedInstance] loadAdWithKey:adKey scene:adRequest];
    
    // 获取并展示
    @weakify(self);
    XYAdObject *bannerAdObj = [[XYAdBaseManager sharedInstance] getAdWithKey:adKey showScene:adShow];
    self.bannerAdObj = bannerAdObj;
    bannerAdObj.delegate = self;
    [bannerAdObj bannerAdBlock:^(XYAdPlatform adPlatform, FBAdView *fbBannerView, GADBannerView *gadBanner, BOOL isClick, BOOL isLoadSuccess) {
        @strongify(self);
        if (isLoadSuccess) {  
            if (adPlatform == XYFacebookAdPlatform) { // Facebook 广告
                fbBannerView.frame = CGRectMake(0, KScreenHeight - kFBAdSizeHeight50Banner.size.height, KScreenWidth, kFBAdSizeHeight50Banner.size.height);
                fbBannerView.userInteractionEnabled = isClick;
                [self.view addSubview:fbBannerView];
                [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdbannerType placementId:fbBannerView.placementID upload:NO];
            } else if (adPlatform == XYAdMobPlatform) { // AdMob 广告
                gadBanner.rootViewController = self;
                gadBanner.adSize = GADAdSizeFromCGSize(CGSizeMake(KScreenWidth, 50));
                gadBanner.frame = CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50);
                gadBanner.userInteractionEnabled = isClick;
                [self.view addSubview:gadBanner];
                [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdbannerType placementId:gadBanner.adUnitID upload:NO];
            }
        }
    }];
}

#pragma mark - XYAdObjectDelegate
- (void)adObjectDidClick:(XYAdObject *)adObject {
    [[TTAdManager sharedInstance] deleteAdObjectWithKey:@""];
    [self loadAd];
}

@end
