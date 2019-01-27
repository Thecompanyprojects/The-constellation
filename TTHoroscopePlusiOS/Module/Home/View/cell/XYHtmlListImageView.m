//
//  XYHtmlListImageView.m
//  XToolConstellationIOS
//
//  Created by zhang ming on 2018/5/6.
//  Copyright © 2018年 小叶科技. All rights reserved.
//

#import "TTHtmlListImageView.h"

@implementation TTHtmlListImageView
- (instancetype)initWithModel:(XYHtmlTableViewModel *)model{
    self = [super init];
    self.model = model;
    self.imgView = [UIImageView new];
    [self addSubview:self.imgView];
    if (model.wh_ratio && model.url) {
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.mas_equalTo(self);
            make.height.mas_equalTo(KScreenWidth/model.wh_ratio.floatValue);
        }];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"new新闻默认图"]];
    }
    return self;
}
@end
