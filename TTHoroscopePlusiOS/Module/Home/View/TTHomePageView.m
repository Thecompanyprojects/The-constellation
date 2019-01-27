//
//  XYHomePageView.m
//  Horoscope
//
//  Created by PanZhi on 2018/4/23.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import "TTHomePageView.h"

@interface TTHomePageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UIScrollView *topicScrollView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, assign) CGFloat lastOffsetX;

@end

@implementation TTHomePageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _array = @[@"title1",@"title2",@"title3",@"title4",@"title5",@"title6",@"title7",@"title8",@"title9"];
        _lastOffsetX = 0;
        [self setupUI];
    }
    return self;
}

#define itemW (KScreenWidth * 0.25)
#define itemH 50.0
- (void)setupUI{
    [self setupTopBarView];
    [self setupCollectionView];
}

- (void)setupTopBarView{
    UIScrollView *topicScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemH)];
    self.topicScrollView = topicScrollView;
    topicScrollView.backgroundColor = [UIColor whiteColor];
    topicScrollView.contentSize = CGSizeMake(_array.count * itemW, 0);
    topicScrollView.showsVerticalScrollIndicator = NO;
    topicScrollView.showsHorizontalScrollIndicator = NO;
    topicScrollView.scrollEnabled = YES;
    topicScrollView.bounces = NO;
    [self addSubview:topicScrollView];
    
    for (int i=0; i<_array.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor randomColor];
        btn.frame = CGRectMake(i*itemW, 0, itemW, itemH);
        [topicScrollView addSubview:btn];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, itemH-3, itemW*_array.count, 3)];
    lineView.backgroundColor = [UIColor cyanColor];
    [topicScrollView addSubview:lineView];
    
    UIView *indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 3)];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.center = CGPointMake(itemW*0.5, indicatorView.center.y);
    [lineView addSubview:indicatorView];
    
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(KScreenWidth, self.frame.size.height-itemH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, itemH, KScreenWidth, self.frame.size.height-itemH) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    
    [self addSubview:collectionView];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSInteger index = offsetX/KScreenWidth;
//    NSLog(@"%zd",index);
    
    
   // [self.topicScrollView setContentOffset:CGPointMake(itemW/KScreenWidth*offsetX, 0) animated:NO];
    CGFloat itemOffsetX = itemW/KScreenWidth*offsetX;
    
//    NSLog(@"%f",offsetX);
    CGFloat relativeOffset = scrollView.contentOffset.x - _lastOffsetX;
    self.indicatorView.center = CGPointMake(itemW/KScreenWidth*offsetX + itemW*0.5, self.indicatorView.center.y);
  
    if (relativeOffset>0) {
        if (itemOffsetX>310.5) {
            [self.topicScrollView setContentOffset:CGPointMake(itemW/KScreenWidth*offsetX-310.5, 0) animated:NO];
        }
    }else{
        if(itemOffsetX < (_array.count * itemW- 414) ){
            [self.topicScrollView setContentOffset:CGPointMake(itemOffsetX, 0) animated:NO];
        }
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _lastOffsetX = scrollView.contentOffset.x;
}

@end
