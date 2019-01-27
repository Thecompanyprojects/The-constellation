//
//  XYNetWorkReloadView.h
//  Horoscope
//
//  Created by zhang ming on 2018/5/2.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NOT_NEIWORK,
    SERVICE_ERROR,
} XYReloadViewNetworkStatus;

@protocol XYNetWorkReloadViewDelegate<NSObject>
- (void)reloadViewSelector;
@end
@interface TTNetWorkReloadView : UIView
@property (nonatomic, weak) id<XYNetWorkReloadViewDelegate> delegate;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UILabel* subLabel;
@property (nonatomic, strong) UIButton* reloadButton;
@end
