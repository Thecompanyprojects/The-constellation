//
//  VipPaymentCell.m
//  XToolWhiteNoiseIOS
//
//  Created by KevinXu on 2018/10/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

#import "TTVipPaymentCell.h"
#import "TTPaymentPriceModel.h"

@interface TTVipPaymentCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation TTVipPaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *grandColor = [UIColor colorGradientWithSize:CGSizeMake(70, 38) direction:GradientDirection_Horizontal startColor:kHexColor(0xFAD735) endColor:kHexColor(0xFFBD4A)];
    self.priceBtn.backgroundColor = grandColor;
    self.priceBtn.layer.cornerRadius = 38 / 2.0;
    self.priceBtn.layer.shadowColor = kHexColor(0x2E2E2E).CGColor;
    self.priceBtn.layer.shadowOffset = CGSizeMake(0, 4);
    self.priceBtn.layer.shadowOpacity = 0.2;
    self.priceBtn.layer.shadowRadius = 7;
    
    UIColor *grandColor_2 = [UIColor colorGradientWithSize:CGSizeMake(38, 38) direction:GradientDirection_Horizontal startColor:kHexColor(0xFAD735) endColor:kHexColor(0xFFBD4A)];
    self.numberLabel.layer.backgroundColor = grandColor_2.CGColor;
    self.numberLabel.layer.shadowOffset = CGSizeMake(0, 4);
    self.numberLabel.layer.shadowOpacity = 0.2;
    self.numberLabel.layer.shadowColor = kHexColor(0x2E2E2E).CGColor;
    self.numberLabel.layer.shadowRadius = 7;
    self.numberLabel.layer.cornerRadius = 38.0 / 2.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(TTPaymentPriceModel *)model {
    _model = model;
    
    _numberLabel.text = [NSString stringWithFormat:@"%02zd",model.index];
    _titleLabel.text = model.title;
    if ([[TTPaymentManager shareInstance].availableProductID isEqualToString:model.payment_id]) {
        [_priceBtn setTitle:@"Subscibed" forState:UIControlStateNormal];
    } else {
        [_priceBtn setTitle:model.price forState:UIControlStateNormal];
    }
}


- (IBAction)priceBtnAction:(UIButton *)sender {
    if ([[TTPaymentManager shareInstance].availableProductID isEqualToString:self.model.payment_id]) {
        return;
    }
    
    if (self.payButtonAction) {
        self.payButtonAction(self.model);
    }
}

@end
