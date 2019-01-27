//
//  IMB_TableViewController.h
//  Horoscope
//
//  Created by PanZhi on 2018/4/19.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "IMB_TableViewController.h"
//#import "IMB_TableDataSource.h"

@interface IMB_TableViewController : UITableViewController

{
    /**
     *  数据集合
     */
    NSMutableArray *dataArr_;
    
    // 数据源
//    IMB_TableDataSource *dataSource_;
}

/**
 *  数据源
 */
//@property (nonatomic, strong) IMB_TableDataSource *myDataSource;

/**
 *  数据初始化
 */
- (void)dataConfig;

/**
 *  界面初始化
 */
- (void)uiConfig;

/**
 *  快捷push
 *
 *  @param viewController 要push到的视图控制器
 */
- (void)pushTo:(UIViewController *)viewController;
// 快捷返回
- (void)pop;

- (void)backToPrevious;

@end
