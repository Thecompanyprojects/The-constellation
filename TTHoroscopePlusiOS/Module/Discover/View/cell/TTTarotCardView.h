//
//  XYTarotCardView.h
//  Horoscope
//
//  Created by PanZhi on 2018/5/14.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <UIKit/UIKit.h>
#define cardScale 2.0

@class TTTarotCardView;

@protocol XYTarotCardViewDelegate <NSObject>
- (void)startAnimateCardView:(TTTarotCardView *)cardView;
- (void)stopAnimateCardView:(TTTarotCardView *)cardView;
- (void)cardViewProgress:(CGFloat)progress;
@end

@interface TTTarotCardView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, weak) id<XYTarotCardViewDelegate>delegate;
@property (nonatomic, assign) BOOL autoreverses;
@property (nonatomic, assign) BOOL isPositive;//yes正面  no反面

- (void)startanimateFrame:(CGRect)frame duration:(CGFloat)duration animate:(void(^)(void))animate completion:(void(^)(void))completion;

//- (void)startRotationWithPoint:(CGPoint)point size:(CGSize)size;

- (void)startAnimatePoint:(CGPoint)point scale:(NSNumber *)scale;
- (void)recoverAnimate;

- (void)reversalImageView;

@end
