//
//  XYForecastViewController.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTForecastViewController.h"
#import "TTLuckCardView.h"

@interface TTForecastViewController ()

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) TTHoroscopeModel *model;

@end

@implementation TTForecastViewController

- (instancetype)initWithType:(NSInteger)type model:(TTHoroscopeModel *)model{
    self = [super init];
    if (self) {
        _model = model;
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.title = @"Forecast";
    
    CGRect rect;
    if (_type == 0) {
        rect = CGRectMake(10,
                          NAV_HEIGHT + 10,
                          self.view.bounds.size.width-20,
                          self.view.bounds.size.height - NAV_HEIGHT -20);
    }else if (_type == 1){
        rect = CGRectMake(LEFT_MARGIN,
                          CELL_TOP_MARGIN+TOP_MARGIN,
                          self.view.bounds.size.width-LEFT_MARGIN*2,
                          self.view.bounds.size.height - NAV_HEIGHT - 44 - TABBAR_HEIGHT - (CELL_TOP_MARGIN+TOP_MARGIN)*2);
    }else{
        NSAssert(false, @"未处理这个rect");
        rect = CGRectMake(0, 0, 0, 0);
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    scrollView.frame = rect;
    scrollView.layer.masksToBounds = YES;
    scrollView.layer.cornerRadius = 5;
    scrollView.bounces = YES;
    
    TTLuckCardView *cardView = [[TTLuckCardView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) cardType:FORECAST_TYPE];
//    XYLuckCardView *cardView = [[XYLuckCardView alloc]initWithFrame:CGRectMake(10,   10, self.view.bounds.size.width-20, self.view.bounds.size.height - NAV_HEIGHT - 44 - TABBAR_HEIGHT -20) cardType:FORECAST_TYPE];
//    [self.view addSubview:cardView];
    TTHoroscopeModel *model = [[TTHoroscopeModel alloc]init];
    model.title = @"ttttttttttt";
    model.content = @"\"Harmony \" is the keyword for this sign. For the Libran, maintaining this is of the utmost importance. They can be excellent leaders, and will work hard to earn - and deserve - the privilege. Truth and justice always prevail for the Libran as they go about their days. Working with others or in a partnership is ideal for this social sign. Artistic and persuasive, these folks are gifted talkers who do well in any position that provides a platform for them to chat.\n\nCareers that involve justice such as police officer, lawyer, or judge are excellent choices for the Libran. They will also succeed at such occupations as diplomat, civil servant, interior decorator, composer and fashion designer. Group settings pose no challenge for the Libran - in fact, the more the merrier. Their strong sense of diplomacy serves well in almost anything they do.\n\nIf you go shopping with a Libran, best to plan some extra time! This sign can be terribly indecisive when it comes to purchasing. Balancing their money, however, is a snap for the Libran. Keeping a good balance between savings and spending money is a real talent for these folks. Their love of fashion and housewares can see them out and about in stores quite often. One of the Libran's favorite pastimes is to shop for someone special.in fact, the more the merrier. Their strong sense of diplomacy serves well in almost anything they do.\n\nIf you go shopping with a Libran, best to plan some extra time! This sign can be terribly indecisive when it comes to purchasing. Balancing their money, however, is a snap for the Libran. Keeping a good balance between savings and spending money is a real talent for these folks. Their love of fashion and housewares can see them out and about in stores quite often. One of the Libran's favorite pastimes is to shop for someone special.";
    model = [TTManager sharedInstance].todayModel.horoscopeModel;
    cardView.model = self.model;
    [scrollView addSubview:cardView];
    scrollView.contentSize = CGSizeMake(0, cardView.frame.size.height);
//    scrollView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
}

- (void)dealloc{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYLogManager shareManager]uploadAllLog];
    });
}


@end
