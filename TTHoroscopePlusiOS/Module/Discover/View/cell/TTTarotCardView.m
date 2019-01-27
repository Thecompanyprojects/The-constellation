//
//  XYTarotCardView.m
//  Horoscope
//
//  Created by PanZhi on 2018/5/14.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTTarotCardView.h"

@interface TTTarotCardView () <CAAnimationDelegate>
@property (nonatomic, strong) UIImageView *cardImgV;
@property (nonatomic, strong) MSWeakTimer *timer;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) CGFloat pointY;
@property (nonatomic, strong) NSNumber *scaleNum;
@end

@implementation TTTarotCardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.cardImgV];
}

- (UIImageView *)cardImgV{
    if (!_cardImgV) {
        _cardImgV = [[UIImageView alloc]init];
        _cardImgV.userInteractionEnabled = YES;
        _cardImgV.transform = CGAffineTransformMakeScale(-1, 1);
        _cardImgV.frame = self.bounds;
        [_cardImgV setImage:[UIImage imageNamed:@"塔罗 反"]];
    }
    return _cardImgV;
}

- (void)setImage:(UIImage *)image{
    _image = image;
}

- (void)setViewFrame:(CGRect)viewFrame{
    _viewFrame = viewFrame;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = viewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)startanimateFrame:(CGRect)frame duration:(CGFloat)duration animate:(void(^)(void))animate completion:(void(^)(void))completion{
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
        self.cardImgV.xy_height = frame.size.height;
        self.cardImgV.xy_width = frame.size.width;
        if (animate) {
            animate();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)startAnimatePoint:(CGPoint)point scale:(NSNumber *)scale{
    NSLog(@"动画开始 正");
    if (self.isShowing) return;
    self.isShowing = YES;
    self.isPositive = YES;
    self.scaleNum = scale;
    self.pointY = point.y;
    [self.layer removeAllAnimations];
    [self startRotationWithPosition:@[[NSValue valueWithCGPoint:self.center],[NSValue valueWithCGPoint:point]] rotation:@[@(0),@(M_PI)] scale:@[@(1),self.scaleNum]];
}

- (void)recoverAnimate{
    NSLog(@"复原动画 反");
    if (self.isShowing) return;
    self.isShowing = YES;
    self.isPositive = NO;
    [self.layer removeAllAnimations];
    [self startRotationWithPosition:@[[NSValue valueWithCGPoint:self.layer.presentationLayer.position],[NSValue valueWithCGPoint:self.center]] rotation:@[@(-M_PI),@(0)] scale:@[self.scaleNum,@(1)]];
}

- (void)startRotationWithPosition:(NSArray *)Position rotation:(NSArray *)rotation scale:(NSArray *)scale{
    
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnima.fromValue = Position.firstObject;
    positionAnima.toValue = Position.lastObject;
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnima.fromValue = rotation.firstObject;
    transformAnima.toValue = rotation.lastObject;
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = scale.firstObject;
    scaleAnimation.toValue = scale.lastObject;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = 0.5;
    animaGroup.delegate = self;
    animaGroup.animations = @[positionAnima,transformAnima,scaleAnimation];
//    animaGroup.autoreverses = YES;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.removedOnCompletion = NO;
    [self.layer addAnimation:animaGroup forKey:@"Animation"];
}

- (void)observeProgress{
    CGFloat pointY = self.center.y;
    CGFloat targetPointY = self.pointY;
    CGFloat allPointY = targetPointY-pointY;
    CGFloat progresszPointY = self.layer.presentationLayer.position.y-pointY;
    
    //============
//    CGFloat height = self.xy_height;
//    CGFloat targetHeight = self.xy_height*self.scaleNum.integerValue;
//    CGFloat allHeight = targetHeight-height;
//    CGFloat progresszHeight = self.layer.presentationLayer.frame.size.height-height;
//    CGFloat result = progresszHeight/allHeight;
    CGFloat result = progresszPointY/allPointY;
//    if (result > 0.5 && _isPositive) {
    if (self.layer.presentationLayer.frame.size.width < 15 && _isPositive) {
        [self.cardImgV setImage:self.image];
    }else if(result < 0.5 && !_isPositive){
        [self.cardImgV setImage:[UIImage imageNamed:@"塔罗 反"]];
    }
//    NSLog(@"%f",result);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardViewProgress:)] && _isShowing) {
        [self.delegate cardViewProgress:result];
    }
}

- (void)animationDidStart:(CAAnimation *)anim{
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(observeProgress) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    if (self.delegate && [self.delegate respondsToSelector:@selector(startAnimateCardView:)]) {
        [self.delegate startAnimateCardView:self];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.timer invalidate];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopAnimateCardView:)]) {
        [self.delegate stopAnimateCardView:self];
    }
    NSLog(@"动画结束");
    self.isShowing = NO;
}

- (void)reversalImageView{
    self.cardImgV.transform = CGAffineTransformMakeScale(1, 1);
}

@end
