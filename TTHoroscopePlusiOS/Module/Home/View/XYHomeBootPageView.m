//
//  XYHomeBootPageView.m
//  Horoscope
//
//  Created by 郭连城 on 2018/11/12.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "XYHomeBootPageView.h"

@implementation XYHomeBootPageView

+ (XYHomeBootPageView *)getView{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"XYHomeBootPageViewIsShowed"]){
        return nil;
    }else{
        XYHomeBootPageView *v = [[self alloc]initWithFrame:kKeyWindow.bounds];
        [kKeyWindow addSubview:v];
        return v;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIImageView *v = [[UIImageView alloc]init];
    
    if(isIPhoneX){
        [v setImage:[UIImage imageNamed:@"bootPageX"]];
    }else{
        [v setImage:[UIImage imageNamed:@"bootPage"]];
    }
    
    v.frame = self.bounds;
    [self addSubview:v];

    
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"OK" forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 2;
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(53);
        make.width.mas_equalTo(186);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-50);
    }];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickBtn{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"XYHomeBootPageViewIsShowed"];
    [self removeFromSuperview];
}

@end
