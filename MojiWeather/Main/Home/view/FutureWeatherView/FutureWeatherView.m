//
//  FutureWeatherView.m
//  MojiWeather
//
//  Created by zhoujie on 15/8/30.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "FutureWeatherView.h"
#import "Common.h"

@implementation FutureWeatherView

#pragma mark -init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubViews];
    }
    return self;
}

- (void)awakeFromNib{
    [self _createSubViews];
    
}

- (void)setModal:(Modal *)modal
{

    _modal=modal;
    _fuWeaCollectionView.modal = _modal;
    
}

#pragma mark - createSubViews
- (void)_createSubViews{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake((kWidth)/6, (kHeight-64-49));
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=10;
    layout.sectionInset=UIEdgeInsetsMake(10, 0, 0, 10);
    layout.scrollDirection= UICollectionViewScrollDirectionHorizontal;
    
    _fuWeaCollectionView = [[FuWeaCollectionView alloc]initWithFrame:CGRectMake(0,-49, kWidth, kHeight) collectionViewLayout:layout];
    _fuWeaCollectionView.backgroundColor = [UIColor clearColor];

    [self addSubview:_fuWeaCollectionView];
}


@end
