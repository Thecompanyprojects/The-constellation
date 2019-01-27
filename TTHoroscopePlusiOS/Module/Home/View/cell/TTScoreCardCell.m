//
//  XYScoreCardCell.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/25.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTScoreCardCell.h"
#import "TTScoreCardView.h"

@implementation TTScoreCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    TTScoreCardView *view = [[TTScoreCardView alloc]init];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(335);
        make.height.offset(160*KHEIGHT);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-TOP_MARGIN);
        make.left.equalTo(self.contentView).offset(LEFT_MARGIN);
        make.right.equalTo(self.contentView).offset(-LEFT_MARGIN);
    }];
    
}

@end
