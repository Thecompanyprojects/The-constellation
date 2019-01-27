//
//  XYRequestTool.m
//  Horoscope
//
//  Created by zhang ming on 2018/5/2.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTRequestTool.h"


extern NSString * URLStringFromType(RequestURLType type){
    NSString* typeString = @"";
    switch (type) {
        case Horoscopes:
            typeString = @"horoscopes/horoscope_plus_ios";
            break;
        case Match:
            typeString = @"horoscopes_match/horoscope_plus_ios";
            break;
        case Lucky:
            typeString = @"horoscopes_lucky/horoscope_plus_ios";
            break;
        case Config:
            typeString = @"config/horoscope_plus_ios";
            break;
        case Article:
            typeString = @"horoscopes_article/horoscope_plus_ios";
            break;
        case Tarots:
            typeString = @"tarots/horoscope_plus_ios";
            break;
        case FeedBack:
            typeString = @"feedback/horoscope_plus_ios";
            break;
        case DeviceToken:
            typeString = @"device_token/horoscope_plus_ios";
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@%@", MAINURL, typeString];
}

@implementation TTRequestTool



+ (BOOL)requestWithURLType:(RequestURLType)urlType params:(NSMutableDictionary *)param success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    if (param && param.allKeys.count >= 1) {
        [TTRequestTool encryptAllValues:param];
    }
    
    return  [TTRequestTool postWithURL:URLStringFromType(urlType) params:param success:success failure:failure];
}

+ (void)encryptAllValues:(NSMutableDictionary *)param{
    if (!param.allKeys.count) {
        return;
    }
    for (NSString* key in param.allKeys) {
        
        id value = [param objectForKey:key];
        
        if ([value isKindOfClass:NSDictionary.class]){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value
                                                    options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            value = str;
        }else if (![value isKindOfClass:NSString.class]){
            //            NSAssert(false, @"这个参数要转换为str类型，不然下一行加密方法就会崩溃");
            value = [NSString stringWithFormat:@"%@",value];
        }
//        NSString* value = [NSString stringWithFormat:@"%@",[param objectForKey:key]];
        
        NSString *value_bf_base64 = [value xy_blowFishEncodingWithKey:kBlowFishKey];
        NSData *value_bf_data = [[NSData alloc] initWithBase64EncodedString:value_bf_base64 options:0];
        NSString *value_bf_hex_str = [TTBaseTools hexStringFromData:value_bf_data];
        
        [param setObject:value_bf_hex_str forKey:key];
    }
}

+(BOOL)postWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    if (params == nil || url == nil) {
        
        [[XYLogManager shareManager] addLogKey1:@"network" key2:@"request" content:@{@"state":@"stop", @"nonvalue":(params == nil ? @"param":@"url")} userInfo: nil upload:NO];
        
        return NO;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 需要先转十六进制的data
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [TTBaseTools stringToHexData:responseString];
        // 解密需要时Base64的字符串
        NSString *base64Str = [data base64EncodedStringWithOptions:0];
        // 使用秘钥进行解密,得到的是结果字符串
        NSString *resultStr = [base64Str xy_blowFishDecodingWithKey:kBlowFishKey];
        // 解密完成后转成Data以便之后进行序列化
        NSData *data_dec = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data_dec) {
            NSError* serializeError;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data_dec options:0 error:&serializeError];
            if (!serializeError) {
                
                [[XYLogManager shareManager] addLogKey1:@"network" key2:@"request" content:@{@"state":@"success", @"url":url} userInfo: nil upload:NO];
                
                if (success) {
                    success(responseDict);
                }
            }else{
                
                [[XYLogManager shareManager] addLogKey1:@"network" key2:@"request" content:@{@"state":@"failed", @"url":url, @"code":@"0" ,@"message":serializeError.localizedDescription?serializeError.localizedDescription:@""} userInfo: nil upload:NO];
                
                if (failure) {
                    failure(serializeError);
                }
            }
        }else{
            NSError* error_dec = [NSError errorWithDomain:NSCocoaErrorDomain code:-999 userInfo:@{@"reason":@"Decrypt Failed"}];
            
            [[XYLogManager shareManager] addLogKey1:@"network" key2:@"request" content:@{@"state":@"failed", @"url":url, @"code":@(error_dec.code) ,@"message":error_dec.localizedDescription?error_dec.localizedDescription:@""} userInfo: nil upload:NO];
            
            if (failure) {
                failure(error_dec);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[XYLogManager shareManager] addLogKey1:@"network" key2:@"request" content:@{@"state":@"failed", @"url":url, @"code":@(error.code) ,@"message":error.localizedDescription?error.localizedDescription:@""} userInfo: nil upload:NO];
        if (error) {
            failure(error);
        }
    }];
    return YES;
}

@end
