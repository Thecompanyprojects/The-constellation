//
//  XYHtmlTableViewController.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/4.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHtmlTableViewController.h"
#import "TTHtmlTableViewCell.h"
#import "TTHtmlTableViewModel.h"
#import "TTHtmlListImageView.h"
#import "TTHtmlListLabelView.h"
@interface TTHtmlTableViewController ()
@property (nonatomic, strong) TTNewsModel *model;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<TTHtmlTableViewModel *>* dataSource;
@property (nonatomic, copy) NSString* wh_ratio;
@property (nonatomic, copy) NSString* time;
@property (nonatomic, copy) NSString* topTitle;
@property (nonatomic, copy) NSString* imgUrl;
@end

@implementation TTHtmlTableViewController

- (instancetype)initWithModel:(TTNewsModel *)model{
    self = [super init];
    self.model = model;
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if(!isVip){
            [[XYAdBaseManager sharedInstance]loadAdWithKey:ios_horoscope_plus_check_news_back_interstitial scene:request_scene_look_news_interstitial];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.model.position.integerValue % 2 == 0){
        NSLog(@"第%@篇新闻，需要弹出广告",self.model.position);
        XYAdObject *interstitialAdObj =  [[XYAdBaseManager sharedInstance] getAdWithKey:ios_horoscope_plus_check_news_back_interstitial showScene:show_scene_look_news_interstitial];
        [interstitialAdObj interstitialAdBlock:^(XYAdPlatform adPlatform, FBInterstitialAd *fbInterstitial, GADInterstitial *gadInterstitial, BOOL isClick, BOOL isLoadSuccess) {
            if ([TTPaymentManager shareInstance].isVip){
                
            }else if (isLoadSuccess) {
                if (adPlatform == XYFacebookAdPlatform) {
                    [fbInterstitial showAdFromRootViewController:self];
                    [XYAdEventManager addAdShowLogWithPlatform:XYFacebookAdPlatform adType:XYAdInterstitialType placementId:fbInterstitial.placementID upload:NO];
                } else if (adPlatform == XYAdMobPlatform) {
                    [gadInterstitial presentFromRootViewController:self];
                    [XYAdEventManager addAdShowLogWithPlatform:XYAdMobPlatform adType:XYAdInterstitialType placementId:gadInterstitial.adUnitID upload:NO];
                }
            }
        }];
    }
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYLogManager shareManager]uploadAllLog];
    });
    self.title = @"Article";
    self.backgroundImage = [UIImage imageNamed:@"背景图1125 2436"];
    self.scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.frame = CGRectMake(0, NAV_HEIGHT, KScreenWidth, KScreenHeight-NAV_HEIGHT- (isIPhoneX?34:0));
    [self.view addSubview:self.scrollView];    
    self.contentView = [UIView new];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.view.xy_width);
//        make.height.mas_equalTo(self.view.xy_height);
    }];
    self.dataSource = [NSMutableArray new];
    [self requestData];
}

- (void)reloadViewSelector{
    [self requestData];
    if (self.scrollView.superview == nil) {
        [self.view addSubview:self.scrollView];
    }
}

- (void)requestData{
    [self setReloadViewHidden:YES];
    [TTLoadingHUD show];
    if (self.contentView.subviews.count) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [TTRequestTool requestWithURLType:Article params:[NSMutableDictionary dictionaryWithDictionary:@{@"article_id":self.model.article_id?self.model.article_id:@""}] success:^(NSDictionary* response){
        [TTLoadingHUD dismiss];
        if (response && [response[@"code"] integerValue] == 1) {
            self.topTitle = response[@"data"][@"title"];
            self.time = response[@"data"][@"update_time"];
            self.imgUrl = response[@"data"][@"cover"][@"url"];
            self.wh_ratio = response[@"data"][@"cover"][@"wh_ratio"];
            NSArray* arr = response[@"data"][@"paragraphs"];
            if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                self.dataSource = [NSMutableArray arrayWithArray:[TTHtmlTableViewModel mj_objectArrayWithKeyValuesArray:arr]];
            }
            
            UIImageView* topImageView = [UIImageView new];
            [self.contentView addSubview:topImageView];
            [topImageView mas_makeConstraints:^(MASConstraintMaker* make){
                make.top.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.contentView);
                make.height.mas_equalTo(KScreenWidth/(self.wh_ratio?self.wh_ratio.floatValue:1));
            }];
            [topImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
           
            UILabel* titleLb = [UILabel new];
            [self.contentView addSubview:titleLb];
            titleLb.font = kFontTitle_L_22;//[UIFont systemFontOfSize:22];
            titleLb.numberOfLines = 0;
            titleLb.textColor = [UIColor blackColor];
            [titleLb mas_makeConstraints:^(MASConstraintMaker* make){
                make.top.mas_equalTo(topImageView.mas_bottom);
                make.right.equalTo(self.contentView).with.offset(-15);
                make.left.equalTo(self.contentView).with.offset(15);
            }];
            titleLb.text = self.topTitle;
            
            UILabel* timeLabel = [UILabel new];
            timeLabel.textColor = [UIColor darkTextColor];
            timeLabel.font = kFontTitle_L_16;//[UIFont systemFontOfSize:16];
            [self.contentView addSubview:timeLabel];
            [timeLabel mas_makeConstraints:^(MASConstraintMaker* make){
                make.top.mas_equalTo(titleLb.mas_bottom).with.offset(15);
                make.right.equalTo(self.contentView).with.offset(-15);
                make.left.equalTo(self.contentView).with.offset(15);
                
            }];
            timeLabel.text = self.time;
            
            for (TTHtmlTableViewModel* model in self.dataSource) {
             
                UIView* view = [model.type isEqualToString:@"image"]?[[TTHtmlListImageView alloc]initWithModel:model]:[[TTHtmlListLabelView alloc]initWithModel:model];
                if (self.contentView.subviews.count) {
                    UIView* lastview = self.contentView.subviews.lastObject;
                    [self.contentView addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make){
                        make.top.mas_equalTo(lastview.mas_bottom);
                        make.left.mas_equalTo(self.contentView);
                        make.right.mas_equalTo(self.contentView);
                        if (model == self.dataSource.lastObject) {
                            make.bottom.mas_equalTo(self.contentView);
                        }
                    }];
                    
                }else{
                    [self.contentView addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make){
                        make.top.mas_equalTo(self.contentView).with.offset(NAV_HEIGHT);
                        make.left.mas_equalTo(self.contentView);
                        make.right.mas_equalTo(self.contentView);
                        if (model == self.dataSource.lastObject) {
                            make.bottom.mas_equalTo(self.contentView);
                        }
                    }];
                }
               
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Request Error:%@",response[@"code"]?response[@"code"]:@"codenone"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError* error){
        [TTLoadingHUD dismiss];
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            [self setReloadViewHidden:NO];
            [self.scrollView removeFromSuperview];
            return;
        }
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
/*{
    code = 1;
    data =     {
        "article_id" = "this-is-the-main-quality-that-attracts-your-soulmate-based-on-your-zodiac-sign-a13683";
        "article_type" = article;
        briefing = "Based on your zodiac sign, what is your main quality that attract your soulmate? ";
        cover =         {
            "s3_key" = "read/content/13683/resources/cover.jpg";
            url = "http://static.ohippo.com/read/content/13683/resources/cover.jpg";
            "wh_ratio" = "1.50093808630394";
        };
        "cover_image_height" = 533;
        "cover_image_width" = 800;
        "create_time" = "Thu, 03 May 2018 02:55:00 GMT";
        disable = 0;
        "disable_reason" = "<null>";
        "image_num" = "<null>";
        "json_path" = "read/content/13683/article.json";
        locale = "en_US";
        "normalized_title" = "this-is-the-main-quality-that-attracts-your-soulmate-based-on-your-zodiac-sign";
        "num_id" = 13683;
        "page_images" =         (
                                 "http://static.ohippo.com/read/content/13683/resources/cover.jpg",
                                 "http://static.ohippo.com/read/content/13683/resources/i10.jpg",
                                 "http://static.ohippo.com/read/content/13683/resources/i20.jpg"
                                 );
        paragraphs =         (
                              {
                                  content = "<h3><b>Aries</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>March 21st \U2013 April 19th</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Passion. You\U2019re literally down for anything and everything. Love with you has to be their greatest escapade as you inspire them to love bigger, harder, and in vivid intense that makes it so worthwhile.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Taurus</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>April 20th \U2013 May 20th</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Commitment. You don\U2019t rush into love yet when you find the one, they have your heart forever. You give your partner consistency, stability, and a love that endures the test of time.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Gemini</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>May 21st \U2013 June 20th</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Energy. You\U2019re the life of the party exuding charm that is so irresistible. You have a big heart constantly sharing your knowledge, your passion, and your inner feeling with your partner.";
                                  type = paragraph;
                              },
                              {
                                  "s3_key" = "read/content/13683/resources/i10.jpg";
                                  type = image;
                                  url = "http://static.ohippo.com/read/content/13683/resources/i10.jpg";
                                  "wh_ratio" = "1.50093808630394";
                              },
                              {
                                  content = "<h3><b>Cancer</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>June 21st \U2013 July 22nd</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Effort. You\U2019re so caring and protective of your love as it is second nature to you. Being with you is romantic on a mundane day, and feels like home even when crisis strike.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Leo</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>July 23rd \U2013 August 22nd</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Generosity. The way you love is like the sun, strong, confident, and unfaltering as through you can never get enough of your person and constraint the overflowing love inside you.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Virgo</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>August 23rd \U2013 September 22nd</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Attentiveness. You know your partner in and out, be it their strength or flaw, and you love them all the same. You accept them for who they\U2019re and in return, they won\U2019t trade you for the world.";
                                  type = paragraph;
                              },
                              {
                                  "s3_key" = "read/content/13683/resources/i20.jpg";
                                  type = image;
                                  url = "http://static.ohippo.com/read/content/13683/resources/i20.jpg";
                                  "wh_ratio" = "1.50093808630394";
                              },
                              {
                                  content = "<h3><b>Libra</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>September 23rd \U2013 October 22nd</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Harmony. You have so much love to give that you want to share every aspect of your exciting and fulfilling life with them. It\U2019s easy to be with you as there\U2019s no drama involved.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Scorpio</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>October 23rd \U2013 November 21st</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Devotion. You waste no time in eliminating all distraction and focus on who really matter to you. Your person can be reassured that they have all of you because you give nothing but your total best.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Sagittarius</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>November 22nd \U2013 December 21st</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Optimism. Cheerful and enthusiastic, it is a delight to be around you. Your strong faith and the ability to see the goodness in every situation encourages them to live their best with you by their side.";
                                  type = paragraph;
                              },
                              {
                                  "s3_key" = "read/content/13683/resources/i30.jpg";
                                  type = image;
                                  url = "http://static.ohippo.com/read/content/13683/resources/i30.jpg";
                                  "wh_ratio" = "1.50093808630394";
                              },
                              {
                                  content = "<h3><b>Capricorn</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>December 22nd \U2013 January 19th</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Stability. In your relationship, you never fail to be there for your partner in every way you can. You\U2019re their axis of support, their pillar of strength, and the unwavering love of their life.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Aquarius</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>January 20th \U2013 February 18th</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Honesty. Opening up with your feelings aren\U2019t easy for you, but what you can offer your partner is transparency, openness, and earnest sincerity that you care for them.";
                                  type = paragraph;
                              },
                              {
                                  content = "<h3><b>Pisces</b></h3>";
                                  type = paragraph;
                              },
                              {
                                  content = "<b>February 19th \U2013 March 20th</b>";
                                  type = paragraph;
                              },
                              {
                                  content = "Empathy. Gentle and soft, there are no boundaries in the warmth, compassion, and care that you shower upon your partner. You try to relate to their feeling and always have their best interest at heart.";
                                  type = paragraph;
                              }
                              );
        popular = 3883;
        tags =         (
                        {
                            id = 206;
                            name = "12 Zodiac Signs";
                            type = category;
                        },
                        {
                            id = 26;
                            name = Personality;
                            type = category;
                        },
                        {
                            id = 31;
                            name = Relationship;
                            type = category;
                        },
                        {
                            id = 32;
                            name = Marriage;
                            type = category;
                        }
                        );
        title = "This Is The Main Quality That Attracts Your Soulmate, Based On Your Zodiac Sign";
        "update_time" = "Fri, 04 May 2018 02:23:53 GMT";
        version = 1;
    };
}

*/
