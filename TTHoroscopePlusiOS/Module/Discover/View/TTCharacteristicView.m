//
//  XYCharacteristicView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTCharacteristicView.h"
#import "TTCardFlowLayout.h"
#import "TTCharacteristicCell.h"

@interface TTCharacteristicView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    CGFloat _dragStartX;
    
    CGFloat _dragEndX;
}

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, assign, readwrite) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL pagingEnabled;

@end

@implementation TTCharacteristicView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageFloat = (scrollView.contentOffset.x + 1) / (self.collectionView.xy_width*0.914f);
    if (self.pageChanged) {
        self.pageChanged((NSInteger)pageFloat);
    }
    NSLog(@"scrollView == %f --- conoffsetX = %f page:%f",scrollView.frame.size.width*0.914, scrollView.contentOffset.x,pageFloat);
}

- (void)setupUI{
    TTCardFlowLayout *layout = [[TTCardFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.decelerationRate = 0.2;
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:collectionView];
    collectionView.delegate = self;
//    collectionView.pagingEnabled = YES;
    collectionView.bounces = YES;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[TTCharacteristicCell class] forCellWithReuseIdentifier:NSStringFromClass([TTCharacteristicCell class])];

}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = self.dataArray.count;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.7];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTCharacteristicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTCharacteristicCell class]) forIndexPath:indexPath];
    cell.model  = self.dataArray[indexPath.row];
    return cell;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat width = self.collectionView.frame.size.width*0.8;
    NSInteger index = scrollView.contentOffset.x/width;
    NSInteger mid = (NSInteger)scrollView.contentOffset.x% (NSInteger)width;
    NSLog(@"%zd ==== yushu = %zd  conwidth = %f",index,mid,scrollView.contentSize.width);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (mid>(width*0.5)) {
            [self.collectionView setContentOffset:CGPointMake(index+1*width, scrollView.contentOffset.y) animated:YES];
        }else{
            [self.collectionView setContentOffset:CGPointMake(index*width, scrollView.contentOffset.y) animated:YES];
        }
    });
    
}*/
/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
  //  NSLog(@"%@",NSStringFromCGPoint(velocity));
    //    NSLog(@"%@",targetContentOffset);
    ;
    CGPoint point = *targetContentOffset;
    CGFloat indx =  point.x/(KScreenWidth*0.8);
    NSLog(@"%@",NSStringFromCGPoint(point));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:point animated:YES];
    });
}
*/

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/10.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenter];
}

//滚动到中间
- (void)scrollToCenter {
    NSLog(@"代码滚动到%zd",_selectedIndex);

    [_collectionView setUserInteractionEnabled:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_collectionView setUserInteractionEnabled:YES];
    });
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    [_collectionView setUserInteractionEnabled:YES];
   // [_collectionView setContentOffset:CGPointMake(_selectedIndex*310.5, 0) animated:YES];
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {return;}
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}


- (void)setBestMacthType:(NSInteger)bestMacthType{
    _bestMacthType = bestMacthType;
    if (bestMacthType == 1) {
        _selectedIndex = 7;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        if (self.pageChanged) {
            self.pageChanged(7);
        }
    }else if (bestMacthType == 2){
        _selectedIndex = 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        if (self.pageChanged) {
            self.pageChanged(1);
        }
    }
}


@end
