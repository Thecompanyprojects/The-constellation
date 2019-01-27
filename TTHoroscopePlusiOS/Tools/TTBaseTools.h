#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCellularData.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>

@interface TTBaseTools : NSObject

//计算label的长度
+ (CGFloat)labelWidth:(NSString *)message andWithLabelFont:(UIFont*)font andWithHeight:(CGFloat)height;
//计算label的高度
+ (CGFloat)labelHeight:(NSString *)message andWithLabelFont:(UIFont *)font andWithWidth:(CGFloat)width;
//文字水印
+ (UIImage *) imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font WithImage:(UIImage *)image;
//截屏
+ (void)ScreenShotWithView:(UIView *)shotView;
//计算时间
+ (NSString *)getMinuteSecondWithSecond:(int)time andHour:(BOOL)contentHours;
//字符串
+(NSString *)subStringToIndex:(NSString *)subStr WithRangeOfString:(NSString *)range;
+(NSString *)subStringFromIndex:(NSString *)subStr WithRangeOfString:(NSString *)range;
//描边
+(NSMutableAttributedString *)strokeTextViewWithFontAttributeName:(UIFont *)fontName ForegroundColorAttributeName:(UIColor *)textColor StrokeColorAttributeName:(UIColor *)storkeColor StrokeWidthAttributeName:(NSNumber *)strokeWidth WithMessage:(NSString *)message withTextAlignment:(NSTextAlignment)textAlignment;
//图片模糊
+ (UIImage *)filterGaussianBlur:(UIImage *)imagea WithInputRadius:(float)radius;
//计算textView高度
+ (CGFloat)textViewHeight:(UITextView *)textView andWithTextViewFont:(UIFont *)font;
//textView行间距
+ (NSAttributedString *)textView:(NSString *)textMessage WithFont:(UIFont *)font ParagraphLlineSpacing:(int)lineSpacing;

//字典转json字符串
+ (NSString *)jsonStringWithDict:(NSDictionary *)dict;
+ (NSString *)getStringWithDate:(NSDate *)date WithFormat:(NSString *)formatterStr;

//字符串转时间
+ (NSDate *)getDateWithStr:(NSString *)dateStr WithFormat:(NSString *)formatterStr;
+(float)textString:(NSString *)text FontOfSize:(float)fontSize withWidth:(float)width minHight:(float)minHight;

+ (CTCellularData *)checkCTCellularData;
//获取带颜色富文本
+ (NSMutableAttributedString *)addColor:(UIColor *)color to:(NSString *)string WithFont:(CGFloat)font withLineSpace:(CGFloat)lineSpace withTextAlignment:(NSTextAlignment)textAlignment;
//富文本添加图片
+ (NSMutableAttributedString *)addImageWithString:(NSString*)string x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
+ (NSMutableAttributedString *)addImageWithImages:(NSArray*)images x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
//拼接富文本
+ (NSMutableAttributedString *)appendString:(NSAttributedString *)stringB to:(NSMutableAttributedString *)stringA;

//html文件转字符串
+(NSString *)loadWebDataWithFile:(NSString *)filePath;
+(NSString *)loadWebDataWithContent:(NSString *)content;

//十六进制转化颜色
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

// 设置文字中关键字高亮
+ (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor;
//时间戳转时间
+ (NSString *)getDateWithTimeInterval:(CGFloat)timeInterval WithFormatter:(NSString *)formatterStr;
//时间转时间戳
+ (NSInteger)getTimeIntervalWithDate:(NSDate *)date;
+ (void)settingIphone;
//打电话
+(void)callTell:(NSString *)phoneNumber;
//检查手机号
+ (BOOL)validateMobileNum:(NSString *)mobile;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (void)locationClose:(UIViewController *)vc;
+ (NSString *)md5:(NSString *)str;
+(NSString *)MD5:(NSString *)str;
+ (NSString *)publicBundleVersion;
+ (NSString *)internalBundleVersion;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (BOOL)isAllSpace:(NSString *)string;
+ (CGRect)contentSizeRectForTextView:(UITextView *)textView;
+ (NSMutableAttributedString *)addShadowTo:(NSMutableAttributedString *)attr;
+ (UIFont*)customFontWithPath:(NSURL*)fontUrl size:(CGFloat)size;
+ (CGFloat)viewHeightWithNavigationBar:(BOOL)hasNav withTabbar:(BOOL)hasTababr;
+ (NSString *)chineseWithArabString:(NSString *)arabStr;
+ (UIColor *)predominantColor;
+ (NSData *) stringToHexData:(NSString *)hexStr;
+ (NSString *)hexStringFromData:(NSData *)myD;
+ (NSString *)monthNameWithIndex_en:(NSInteger)index;
+ (UIView *)copyView:(UIView *)view;
+ (NSArray *)transferHexColorString:(NSString *)color;
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString;
@end
