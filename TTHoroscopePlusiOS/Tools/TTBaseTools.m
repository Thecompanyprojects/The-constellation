
#import "TTBaseTools.h"

@implementation TTBaseTools
#pragma mark -计算label的长度
+ (CGFloat)labelWidth:(NSString *)message andWithLabelFont:(UIFont *)font andWithHeight:(CGFloat)height{
    if ([message isEqualToString:@""]) {
        return 0;
    }
    CGFloat messageLableWidth = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:font}
                                                      context:nil].size.width;
    return messageLableWidth;
}
+(CGFloat)labelHeight:(NSString *)message andWithLabelFont:(UIFont *)font andWithWidth:(CGFloat)width{
    
    if ([message isEqualToString:@""]) {
        return 0;
    }
    CGFloat messageLableHeight = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:font}
                                                      context:nil].size.height;
    return messageLableHeight;
}

#pragma mark -文字水印
+ (UIImage *) imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font WithImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions([image size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    
    //原图
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //水印文字
    [markString drawInRect:rect withAttributes:@{NSFontAttributeName : font,
                                                 NSForegroundColorAttributeName : color}];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

#pragma mark -截屏
+ (void)ScreenShotWithView:(UIView *)shotView{
    
    CGSize size = shotView.bounds.size;
    CGRect rect = shotView.frame;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [shotView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(shotImage, nil, nil, nil);//保存图片到照片库
}
#pragma mark -计算时间
+ (NSString *)getMinuteSecondWithSecond:(int)time andHour:(BOOL)contentHours{
    if (time > 60*60*24) {
        return @"超过一天";
    }else{
        int seconds = time%60;
        int minit = time/60%60;
        int hours = time/(60*60)%60;
        if (contentHours) {
            return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minit,seconds];
        }else{
            if (hours == 0) {
                return [NSString stringWithFormat:@"%.2d:%.2d",minit,seconds];
            }else{
                return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minit,seconds];
            }
        }
    }
}

#pragma mark -字符串
+(NSString *)subStringToIndex:(NSString *)subStr WithRangeOfString:(NSString *)range{
    
    NSRange subRange = [subStr rangeOfString:range];
    NSString* resultStr = [subStr substringToIndex:subRange.location];
    return resultStr;
}
+(NSString *)subStringFromIndex:(NSString *)subStr WithRangeOfString:(NSString *)range{
    
    NSRange subRange = [subStr rangeOfString:range];
    NSString* resultStr = [subStr substringFromIndex:subRange.location + 1];
    return resultStr;
}
#pragma mark -描边
+(NSMutableAttributedString *)strokeTextViewWithFontAttributeName:(UIFont *)fontName ForegroundColorAttributeName:(UIColor *)textColor StrokeColorAttributeName:(UIColor *)storkeColor StrokeWidthAttributeName:(NSNumber *)strokeWidth WithMessage:(NSString *)message withTextAlignment:(NSTextAlignment)textAlignment{
    
    NSDictionary *dict = @{
                           NSFontAttributeName: fontName,
                           NSForegroundColorAttributeName : textColor,
                           NSStrokeColorAttributeName : storkeColor,
                           NSStrokeWidthAttributeName : strokeWidth,
                           NSWritingDirectionAttributeName:@[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)]
                           };
    
    NSMutableAttributedString *stokeStr = [[NSMutableAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@",message]
                                           attributes:dict];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = textAlignment;
    [stokeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, stokeStr.length)];
    return stokeStr;
}
#pragma mark -图片模糊
+ (UIImage *)filterGaussianBlur:(UIImage *)imagea WithInputRadius:(float)radius
{
    //创建CIContext对象
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取图片
    CIImage * image = [CIImage imageWithCGImage:[imagea CGImage]];
    //创建CIFilter
    CIFilter * gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    //设置滤镜输入参数
    [gaussianBlur setValue:image forKey:@"inputImage"];
    //设置模糊参数
    [gaussianBlur setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    
    //得到处理后的图片
    CIImage* resultImage = [gaussianBlur valueForKey:@"outputImage"];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:[image extent]];
    UIImage * imge = [[UIImage alloc] initWithCGImage:imageRef];
    return imge;
}
#pragma mark - TextView
+ (CGFloat)textViewHeight:(UITextView *)textView andWithTextViewFont:(UIFont *)font{
    textView.font = font;
    CGFloat height=[[textView layoutManager]usedRectForTextContainer:[textView textContainer]].size.height;
    return height;
}
//textView行间距
+(NSAttributedString *)textView:(NSString *)textMessage WithFont:(UIFont *)font ParagraphLlineSpacing:(int)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return [[NSAttributedString alloc] initWithString:textMessage attributes:attributes];
}
//字典转json字符串
+(NSString *)jsonStringWithDict:(NSDictionary *)dict{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return dataString;
}
+(NSString *)getStringWithDate:(NSDate *)date WithFormat:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    return [formatter stringFromDate:date];
}
+(NSDate *)getDateWithStr:(NSString *)dateStr WithFormat:(NSString *)formatterStr{
    NSDateFormatter *fromatter = [[NSDateFormatter alloc]init];
    [fromatter setDateFormat:formatterStr];
    return [fromatter dateFromString:dateStr];
}
+(float)textString:(NSString *)text FontOfSize:(float)fontSize withWidth:(float)width minHight:(float)minHight
{
    UIFont *tfont = kFontHeiTiLight(fontSize);//[UIFont systemFontOfSize:fontSize];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText1  = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (sizeText1.height<minHight) {
        return minHight;
    }
    return sizeText1.height + 10;
    
}


+ (CTCellularData *)checkCTCellularData{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    return cellularData;
}

#pragma mark - 富文本
+ (NSMutableAttributedString *)addColor:(UIColor *)color to:(NSString *)string WithFont:(CGFloat)font withLineSpace:(CGFloat)lineSpace withTextAlignment:(NSTextAlignment)textAlignment{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    [paragraphStyle setAlignment:textAlignment];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   [UIFont systemFontOfSize:font],
                                   kFontHeiTiLight(font),
                                   NSFontAttributeName,color,
                                   NSForegroundColorAttributeName,paragraphStyle,
                                   NSParagraphStyleAttributeName,nil];
    NSMutableAttributedString* attrstring = [[NSMutableAttributedString alloc]initWithString:@"error"];
    if (string) {
        attrstring  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",string]];
        NSRange range = NSMakeRange(0, [NSString stringWithFormat:@"%@",string].length);
        [attrstring addAttributes:attributeDict range:range];
    }
    return attrstring;
}
+ (NSMutableAttributedString *)addImageWithString:(NSString*)string x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:string];
    attach.bounds = CGRectMake( x, y, width, height);
    NSMutableAttributedString *attachString = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    return attachString;
}
+ (NSMutableAttributedString *)addImageWithImages:(NSArray *)images x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    NSMutableArray *im = [NSMutableArray array];
    for (int i = 0; i < images.count; i++) {
        NSString *a = images[i];
        UIImage *ima = [UIImage imageNamed:a];
        [im addObject:ima];
    }
    attach.image = [UIImage animatedImageWithImages:im duration:0.05];
    attach.bounds = CGRectMake( x, y, width, height);
    NSMutableAttributedString *attachString = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    return attachString;
}
+ (NSMutableAttributedString *)appendString:(NSAttributedString *)stringB to:(NSMutableAttributedString *)stringA{
    if(stringA&&stringB){
        [stringA insertAttributedString:stringB atIndex:stringA.string.length];
    }else{
        stringA = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    return stringA;
}
#pragma mark - html文件转字符串
+(NSString *)loadWebDataWithFile:(NSString *)filePath{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    filePath = [resourcePath stringByAppendingPathComponent:@"newsyule.html"];
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
//    htmlString = [NSString stringWithFormat: @"<html><head><style>img{width:100%%;}></style></head><body bgcolor=%@>%@</body></html>",@"#FFFFFF",htmlString];
    return htmlString;
}
+(NSString *)loadWebDataWithContent:(NSString *)content{
    NSString *htmlString = [NSString stringWithFormat: @"<html><head><style>img{width:100%%;}></style></head><body bgcolor=%@>%@</body></html>",@"#FFFFFF",content];
    return htmlString;
}
#pragma mark - 十六进制转化颜色
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSArray *)transferHexColorString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return @[@0,@0,@0];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6){
        return @[@0,@0,@0];
    }
        
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return @[@((float) r),@((float) g),@((float) b)];
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    if ([cString length] == 8) {
        //a
        NSString *aString = [cString substringWithRange:range];
        cString = [cString substringFromIndex:range.length];
        // Scan values
        unsigned int a;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        
        alpha = ((float) a / 255.0f) ;
    }
    
    if ([cString length] != 6)
        return [UIColor clearColor];
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
#pragma mark - 设置文字中关键字高亮
+ (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    
    NSMutableString *xxstr = [NSMutableString new];
    for (int i = 0; i < key.length; i++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}
#pragma mark - 时间戳转时间
+ (NSString *)getDateWithTimeInterval:(CGFloat)timeInterval WithFormatter:(NSString *)formatterStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLog(@"======%@",formatter.locale);
    formatter.dateFormat = formatterStr;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [formatter stringFromDate:date];
}
+ (NSInteger)getTimeIntervalWithDate:(NSDate *)date{
    NSInteger timeSp = [date timeIntervalSince1970];
    return timeSp;
}

+(void)settingIphone{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - 打电话
+(void)callTell:(NSString *)phoneNumber{
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]]]];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if (!jsonData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (void)locationClose:(UIViewController *)vc{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在系统设置在开启定位服务\n设置 -> 隐私 -> 定位服务 -> 卡神帮" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [vc presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 检查手机号
+ (BOOL)validateMobileNum:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
//        /**
//         * 移动号段正则表达式
//         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
//
//        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
//        }else{
//            return NO;
//        }
    }
}


//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[32];
    
    //    CC_MD5( cStr, strlen(cStr), result );
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15]];
    
}



//md5 16位加密 （大写）

+(NSString *)MD5:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[16];
    
    
    
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    
    
    return [NSString stringWithFormat:
            
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            
            
            result[0], result[1], result[2], result[3],
            
            
            
            result[4], result[5], result[6], result[7],
            
            
            
            result[8], result[9], result[10], result[11],
            
            
            
            result[12], result[13], result[14], result[15]
            
            
            
            ];
    
    
    
}

+ (NSString *)publicBundleVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"]?[infoDictionary objectForKey:@"CFBundleShortVersionString"]:@"";
}

+ (NSString *)internalBundleVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"]?[infoDictionary objectForKey:@"CFBundleVersion"]:@"";
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (BOOL)isAllSpace:(NSString *)string{
    if (!string) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
}

+ (NSMutableAttributedString *)addShadowTo:(NSMutableAttributedString *)attr{
    NSShadow* shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 0.4f;
    shadow.shadowOffset = CGSizeMake(0.3,0.8);
    shadow.shadowColor = RGBA(0, 0, 0, 0.5);
    [attr addAttribute: NSShadowAttributeName value:shadow range:NSMakeRange(0, attr.length)];
    return attr;
}

+ (UIFont*)customFontWithPath:(NSURL*)fontUrl size:(CGFloat)size
{
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

+ (CGFloat)viewHeightWithNavigationBar:(BOOL)hasNav withTabbar:(BOOL)hasTababr{
    CGFloat height;
    height = KScreenHeight;
    CGFloat navHeight = 64;
    CGFloat tabbarHeight = 49;
    if (isIPhoneX) {
        navHeight = 88;
        tabbarHeight = 83;
    }
    if (hasNav) {
        height -= navHeight;
    }
    if (hasTababr) {
        height -= tabbarHeight;
    }
    return height;
}

+ (NSString *)chineseWithArabString:(NSString *)arabStr {
    NSArray *arab_numbers = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_strs = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"〇"];
    NSArray *digits = @[@"", @"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *tranDict = [NSDictionary dictionaryWithObjects:chinese_strs forKeys:arab_numbers];
    NSString *chineseStr = @"";
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < arabStr.length; i++) {
        NSString *subStr = [arabStr substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [tranDict objectForKey:subStr];
        NSString *b = digits[arabStr.length - i - 1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_strs[9]]) {
            if ([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_strs[9]]) {
                    [sums removeLastObject];
                }
            } else {
                sum = chinese_strs[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        [sums addObject:sum];
    }
    chineseStr = [sums componentsJoinedByString:@""];
    
    return chineseStr;
}
+(UIColor *)predominantColor{
    return [TTBaseTools colorWithHexString:@"#ff9cb8"];
}

+ (NSData *) stringToHexData:(NSString *)hexStr
{
    unsigned long len = [hexStr length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [hexStr length] / 2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf ); 
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    NSMutableString *hexStr=[NSMutableString new];
    @autoreleasepool{
        for(int i=0;i<[myD length];i++){
            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
            if([newHexStr length]==1){
                [hexStr appendString:[NSString stringWithFormat:@"0%@",newHexStr]];
            }else{
                [hexStr appendString:[NSString stringWithFormat:@"%@",newHexStr]];
            }
        }
    }
    return hexStr;
}


+ (NSString *)monthNameWithIndex_en:(NSInteger)index{
    NSString* monthName = @"";
    switch (index) {
        case 1:
            monthName = @"Jan";
            break;
        case 2:
            monthName = @"Feb";
            break;
        case 3:
            monthName = @"Mar";
            break;
        case 4:
            monthName = @"Apr";
            break;
        case 5:
            monthName = @"May";
            break;
        case 6:
            monthName = @"Jun";
            break;
        case 7:
            monthName = @"Jul";
            break;
        case 8:
            monthName = @"Aug";
            break;
        case 9:
            monthName = @"Sep";
            break;
        case 10:
            monthName = @"Oct";
            break;
        case 11:
            monthName = @"Nov";
            break;
        case 12:
            monthName = @"Dec";
            break;
        default:
            break;
    }
    return monthName;
}

+ (UIView *)copyView:(UIView *)view{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString{
    if (!htmlString) {
        return [NSAttributedString new];
    }
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSAttributedString* res = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:&error];
    return (error || (res == nil)) ? [NSAttributedString new] : res;
}


@end
