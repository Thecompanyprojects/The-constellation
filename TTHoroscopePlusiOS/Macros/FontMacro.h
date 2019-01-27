//
//  FontMacro.h
//  BlockKan
//
//  Created by Kevin on 2018/3/15.
//  Copyright © 2018年 北京块易科技有限公司. All rights reserved.
//

#ifndef FontMacro_h
#define FontMacro_h

//加粗
#define Font_HB(fontSize)            [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize)]
#define FONT_TITLE_HB                Font_HB(15*KWIDTH)


// 系统字体
#define kFont(_size_)           [UIFont systemFontOfSize:_size_]
#define kFontBold(_size_)       [UIFont boldSystemFontOfSize:_size_]
#define kFontThin(_size_)       [UIFont systemFontOfSize:_size_ weight:UIFontWeightThin]
#define kFontLight(_size_)      [UIFont systemFontOfSize:_size_ weight:UIFontWeightLight]
#define kFontRegular(_size_)    [UIFont systemFontOfSize:_size_ weight:UIFontWeightRegular]
#define kFontMedium(_size_)     [UIFont systemFontOfSize:_size_ weight:UIFontWeightMedium]
#define kFontSemibold(_size_)   [UIFont systemFontOfSize:_size_ weight:UIFontWeightSemibold]
#define kFontHeavy(_size_)      [UIFont systemFontOfSize:_size_ weight:UIFontWeightHeavy]
#define kFontBlack(_size_)      [UIFont systemFontOfSize:_size_ weight:UIFontWeightBlack]



// 自定义字体
#define kFontTitle_L_22  kFontHeiTiLight(22)
#define kFontTitle_L_19  kFontHeiTiLight(19)
#define kFontTitle_L_18  kFontHeiTiLight(18)
#define kFontTitle_L_17  kFontHeiTiLight(17)
#define kFontTitle_L_16  kFontHeiTiLight(16)
#define kFontTitle_L_15  kFontHeiTiLight(15)
#define kFontTitle_L_14  kFontHeiTiLight(14)
#define kFontTitle_L_13  kFontHeiTiLight(13)
#define kFontTitle_L_12  kFontHeiTiLight(12)
#define kFontTitle_L_11  kFontHeiTiLight(11)
#define kFontTitle_L_10  kFontHeiTiLight(10)
#define kFontTitle_L_8   kFontHeiTiLight(8)

#define kFontTitle_M_45  kFontHeiTiMedium(45)
#define kFontTitle_M_23  kFontHeiTiMedium(23)
#define kFontTitle_M_18  kFontHeiTiMedium(18)
#define kFontTitle_M_17  kFontHeiTiMedium(17)
#define kFontTitle_M_15  kFontHeiTiMedium(15)
#define kFontTitle_M_13  kFontHeiTiMedium(13)
#define kFontTitle_M_12  kFontHeiTiMedium(12)
#define kFontTitle_M_10  kFontHeiTiMedium(10)
#define kFontTitle_M_8   kFontHeiTiMedium(8)


#define kFontHeiTiLight(_size_)    [UIFont fontWithName:@"PingFangSC-Regular" size:_size_*KWIDTH]
#define kFontHeiTiMedium(_size_)   [UIFont fontWithName:@"PingFangSC-Medium" size:_size_*KWIDTH]


/**
 
 iOS 苹方字体使用说明
 
 
 苹方提供了六个字重，font-family 定义如下：
 苹方-简 常规体
 font-family: PingFangSC-Regular, sans-serif;
 苹方-简 极细体
 font-family: PingFangSC-Ultralight, sans-serif;
 苹方-简 细体
 font-family: PingFangSC-Light, sans-serif;
 苹方-简 纤细体
 font-family: PingFangSC-Thin, sans-serif;
 苹方-简 中黑体
 font-family: PingFangSC-Medium, sans-serif;
 苹方-简 中粗体
 font-family: PingFangSC-Semibold, sans-serif;
 
 苹方除了简体的：苹方-简（PingFang SC），还为繁体用户提供有：苹方-繁（PingFang TC） ，苹方-港（PingFang HK）
 
 苹方-繁 的 CSS font-family 使用：
 font-family: PingFangTC-Regular, sans-serif;
 font-family: PingFangTC-Ultralight, sans-serif;
 font-family: PingFangTC-Light, sans-serif;
 font-family: PingFangTC-Thin, sans-serif;
 font-family: PingFangTC-Medium, sans-serif;
 font-family: PingFangTC-Semibold, sans-serif;
 
 苹方-港 的 CSS font-family 使用：
 font-family: PingFangHK-Regular, sans-serif;
 font-family: PingFangHK-Ultralight, sans-serif;
 font-family: PingFangHK-Light, sans-serif;
 font-family: PingFangHK-Thin, sans-serif;
 font-family: PingFangHK-Medium, sans-serif;
 font-family: PingFangHK-Semibold, sans-serif;
 
 
 使用示例  [UIFont fontWithName:@"PingFangSC-Regular" size:12]
 */


#endif /* FontMacro_h */
