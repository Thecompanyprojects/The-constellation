//
//  XYZodiacItemModel.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/24.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTZodiacItemModel : NSObject
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* zodiacName;
@property (nonatomic, copy) NSString* titleImageName;
@property (nonatomic, copy) NSString* titleImageNameA;
@property (nonatomic, copy) NSString* transparentImageName;
@property (nonatomic, copy) NSString* backgroundImage;

@property (nonatomic, copy) NSString* dateString;
@property (nonatomic, copy) NSString* colorHexNum;
@property (nonatomic, strong) NSNumber* zodiacIndex;
@end
