//
//  XYCardFlowLayout.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCardFlowLayout.h"

//居中卡片宽度与据屏幕宽度比例
static float CardWidthScale = CARD_WIDTH_SCALE;
static float CardHeightScale = CARD_HEIGHT_SCALE;

@implementation TTCardFlowLayout

//初始化方法
- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(-45*KWIDTH, [self collectionInset], 0, [self collectionInset]);
}

//设置缩放动画
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //扩大控制范围，防止出现闪屏现象
    CGRect bigRect = rect;
    bigRect.size.width = rect.size.width + 2*[self cellWidth];
    bigRect.origin.x = rect.origin.x - [self cellWidth];
    
    NSArray *arr = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:bigRect]];
    //屏幕中线
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attributes in arr) {
        CGFloat distance = fabs(attributes.center.x - centerX);
        //移动的距离和屏幕宽度的的比例
        CGFloat apartScale = distance/self.collectionView.bounds.size.width;
        //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
        CGFloat scale = fabs(cos(apartScale * M_PI/6));// 4
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arr;
}

#pragma mark -
#pragma mark 配置方法

//卡片宽度
- (CGFloat)cellWidth {
    return self.collectionView.bounds.size.width * CardWidthScale;
}

//卡片间隔
- (float)cellMargin {
    NSLog(@"%f",(self.collectionView.bounds.size.width - [self cellWidth])/7);
    return (self.collectionView.bounds.size.width - [self cellWidth])/7;
    
}

//设置左右缩进
- (CGFloat)collectionInset {
    return self.collectionView.bounds.size.width/2.0f - [self cellWidth]/2.0f;
    
}

#pragma mark -
#pragma mark 约束设定
//最小纵向间距
- (CGFloat)minimumLineSpacing {
    return [self cellMargin];
}
//cell大小
- (CGSize)itemSize {
    return CGSizeMake([self cellWidth],self.collectionView.bounds.size.height * CardHeightScale);
}

#pragma mark -
#pragma mark 其他设定
//是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

//防止报错 先复制attributes
- (NSArray *)getCopyOfAttributes:(NSArray *)attributes {
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}

/*
 - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
 // 计算出最终显示的矩形框
 CGRect rect;
 rect.origin.y = 0;
 rect.origin.x = proposedContentOffset.x;
 rect.size = self.collectionView.frame.size;
 
 // 获得super已经计算好的布局属性
 NSArray *array = [super layoutAttributesForElementsInRect:rect];
 
 // 计算collectionView最中心点的x值
 CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
 
 // 存放最小的间距值
 CGFloat minDelta = MAXFLOAT;
 for (UICollectionViewLayoutAttributes *attrs in array) {
 if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
 minDelta = attrs.center.x - centerX;
 }
 }
 
 // 修改原有的偏移量
 proposedContentOffset.x += minDelta;
 return proposedContentOffset;
 
 }*/
 
@end
