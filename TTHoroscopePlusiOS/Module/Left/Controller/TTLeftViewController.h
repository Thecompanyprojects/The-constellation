//
//  XYLeftViewController.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/27.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLeftViewController : UIViewController
@property (nonatomic, copy) void (^selectBlock)(NSDictionary* info);
@end
