//
//  XYLeftViewController.m
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTLeftViewController.h"
#import "TTLeftTableViewCell.h"
#import "TTPaymentManager.h"
#import "TTFeedbackViewController.h"
#import "TTAboutViewController.h"

#import <TTHoroscopePlusiOS-Swift.h>

#define ROWHEIGHT (50*KHEIGHT)
@interface TTLeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSArray* dataSource;
@property (nonatomic, strong)LeftAppPurchaseView *appPurchaseView;
@end

@implementation TTLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    /*
     @{@"className":@"nil",//评分
     @"image":@"rute us",
     @"title":@"Rate Us",
     @"value":@"1"},
     */
    
        self.dataSource = @[
            
            @{@"className":@"nil",//分享给朋友
              @"image":@"share",
              @"title":@"Share to Friends",
              @"value":@"2"},
            @{@"className":NSStringFromClass(TTFeedbackViewController.class),
              @"image":@"cebian yijian icon",
              @"title":@"Feedback",
              @"value":@""},
            @{@"className":NSStringFromClass(TTAboutViewController.class),
              @"image":@"图标 侧边 关于",
              @"title":@"About",
              @"value":@""},
            ];
//    }
 
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.appPurchaseView];
    __weak typeof(self)weakself = self;
    
    [self.appPurchaseView setClickPayBtn:^{
        NSDictionary *dic = @{@"className":@"nil",
                              @"image":@"",
                              @"title":@"pay",
                              @"value":@"3",
                              @"title":@""};
        weakself.selectBlock(dic);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make){
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(ROWHEIGHT*self.dataSource.count);
        make.width.mas_equalTo(KScreenWidth*0.7);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigUserDefaultLocalKey];
    NSDictionary *subscribe = dict[@"cloud"];
    [self.appPurchaseView setConfigDicWithDict: subscribe];
    
  
    self.appPurchaseView.frame = CGRectMake(0, 20*KWIDTH, self.view.xy_width, 440*KWIDTH);
    [self.appPurchaseView setHidden:false];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.left.mas_equalTo(self.view);
        make.height.mas_equalTo(ROWHEIGHT*self.dataSource.count);
        make.width.mas_equalTo(KScreenWidth*0.61);
    }];
    
    
    [[TTManager sharedInstance]checkVipStatusComplete:^(BOOL isVip) {
        if(isVip){//如果是vip
            [self.appPurchaseView.payBtn setHidden:YES];
        }else{//如果不是vip
           [self.appPurchaseView.payBtn setHidden:NO];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTLeftTableViewCell class])];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROWHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectBlock){
        self.selectBlock(self.dataSource[indexPath.row]);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TTLeftTableViewCell* tcell = (TTLeftTableViewCell *)cell;
    tcell.iconImageView.image = [[UIImage imageNamed:self.dataSource[indexPath.row][@"image"]] imageWithTintColor:[UIColor blackColor] blendMode:kCGBlendModeOverlay];
    tcell.titleLabel.text = self.dataSource[indexPath.row][@"title"];
}

- (CGSize)preferredContentSize{
    return CGSizeMake(KScreenWidth*0.7, KScreenHeight);
}
//MARK:- lazy

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =[UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLeftTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TTLeftTableViewCell class])];
    }
    return _tableView;
}

- (LeftAppPurchaseView *)appPurchaseView{
    if (!_appPurchaseView){
        _appPurchaseView = [LeftAppPurchaseView appPurchaseView];
    }
    return _appPurchaseView;
}


@end
