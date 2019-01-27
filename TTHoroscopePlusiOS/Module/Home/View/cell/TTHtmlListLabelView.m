//
//  XYHtmlListLabelView.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/6.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHtmlListLabelView.h"

@implementation TTHtmlListLabelView
- (instancetype)initWithModel:(TTHtmlTableViewModel *)model{
    self = [super init];
    self.model = model;
    self.label = [UILabel new];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self).with.offset(15);
        make.right.mas_equalTo(self).with.offset(-15);
        make.top.mas_equalTo(self).with.offset(5);
        make.bottom.mas_equalTo(self).with.offset(-5);
    }];
    self.label.numberOfLines = 0;
    self.label.attributedText = [self attributedStringWithHTMLString:model.content];
    return self;
}

- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    if (htmlString == nil) {
        return [NSAttributedString new];
    }
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSMutableAttributedString* res = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:&error];
    if (res == nil || error) {
        return [NSAttributedString new];
    }
    NSRange range = NSMakeRange(0, 1);
    NSMutableDictionary* attribute = [NSMutableDictionary dictionaryWithDictionary:[res attributesAtIndex:0 effectiveRange:&range]];
    UIFont* font = [attribute objectForKey:NSFontAttributeName];
    NSLog(@"%@",font);
    if (font.pointSize >= 18) {
        [attribute setObject:[UIFont boldSystemFontOfSize:22] forKey:NSFontAttributeName];
    }else{
        [attribute setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    }
    NSAttributedString* fontAdjustedRes = [[NSAttributedString alloc]initWithString:res.string attributes:attribute];
    return fontAdjustedRes;
}
@end
