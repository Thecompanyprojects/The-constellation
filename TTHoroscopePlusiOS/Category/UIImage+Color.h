//


#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 指定尺寸的纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 改变图片的透明度
 */
- (UIImage *)changeImageAlpha:(CGFloat)alpha;



- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;


@end
