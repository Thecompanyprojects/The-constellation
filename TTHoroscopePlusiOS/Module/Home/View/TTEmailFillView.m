//
//  EmailFillView.m
//  XToolWhiteNoiseIOS
//
//  Created by KevinXu on 2018/8/31.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTEmailFillView.h"

@interface TTEmailFillView ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TTEmailFillView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.text = NSLocalizedString(@"Email:", nil);
    self.textField.placeholder = NSLocalizedString(@"Optional, Convenient for us to contact you", nil);
    [self.textField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textField setValue:kHexColor(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark textDidChanged
- (void)textDidChanged:(UITextField *)sender {
    _email = sender.text;
}

@end
