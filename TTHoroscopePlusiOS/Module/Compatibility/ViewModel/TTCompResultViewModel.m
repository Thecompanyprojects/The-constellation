//
//  XYCompResultViewModel.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/3.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCompResultViewModel.h"
#import "TTRequestTool.h"
#import "XYCompResultModel.h"
@implementation TTCompResultViewModel
- (instancetype)initWithZodiacIndex_1:(NSInteger)firstIndex zodiacIndex_2:(NSInteger)secondIndex delegate:(id)delegate{
    self = [super init];
    self.toastDelegate = delegate;
    self.models = [NSMutableArray new];
    if (self.toastDelegate && [self.toastDelegate respondsToSelector:@selector(requestDidStartShowToast:)]) {
        [self.toastDelegate requestDidStartShowToast:YES];
    }
    [TTRequestTool requestWithURLType:Match params:[NSMutableDictionary dictionaryWithDictionary:@{@"firstZodiacIndex":@(firstIndex), @"secondZodiacIndex":@(secondIndex)}] success:^(NSDictionary* response){
        if (!response) {
            if (self.toastDelegate && [self.toastDelegate respondsToSelector:@selector(requestDidFailWithErrorInfo:showToast:)]) {
                [self.toastDelegate requestDidFailWithErrorInfo:@"Request Failed" showToast:NO];
            }
            return;
        }
        if ([response[@"code"] integerValue] == 1 && response[@"data"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
            if (self.toastDelegate && [self.toastDelegate respondsToSelector:@selector(requestDidSuccessShowToast:)]) {
                [self.toastDelegate requestDidSuccessShowToast:NO];
            }
            self.models = [XYCompResultModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        }else{
            if (self.toastDelegate && [self.toastDelegate respondsToSelector:@selector(requestDidFailWithErrorInfo:showToast:)]) {
                [self.toastDelegate requestDidFailWithErrorInfo:[NSString stringWithFormat:@"Request Failed:(%@)",response[@"code"]] showToast:YES];
            }
        }
    } failure:^(NSError* error){
        if (self.toastDelegate && [self.toastDelegate respondsToSelector:@selector(requestDidFailWithErrorInfo:showToast:)]) {
            [self.toastDelegate requestDidFailWithErrorInfo:error.localizedDescription showToast:YES];
        }
    }];
    return self;
}



@end
