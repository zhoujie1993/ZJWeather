//
//  ScrollPlayView.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/17.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "ScrollPlayView.h"
#import "Common.h"
#import "ImageModel.h"
#import "UIImageView+WebCache.h"

@implementation ScrollPlayView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame ];
    if (self) {
        
        [self createScrollerView];
    
    }
    return self;
}


-(void)setArray:(NSArray *)array
{
    
    _array=array;
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews
{
    
    if (_array.count>=4)//如果超过4张就只显示4张
    {
        for (int i=0; i<4; i++)
        {
            ImageModel *model=_array[i];
            [_arrayImageView[i] sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        }
    }
    else//如果没有4张图 那么有几张显示几张
    {
        for (int i=0; i<_array.count; i++)
        {
            ImageModel *model=_array[i];
            [_arrayImageView[i] sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        }
    }
}

-(void)createScrollerView
{

    _scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollview.contentSize=CGSizeMake(kScreenWidth*4, 190);
    _scrollview.showsHorizontalScrollIndicator=NO;
    _scrollview.showsVerticalScrollIndicator=NO;
    _scrollview.backgroundColor=[UIColor grayColor];
    _scrollview.bounces=NO;
    _scrollview.pagingEnabled=YES;
    _scrollview.delegate=self;
    [self addSubview:_scrollview];
    

    _arrayImageView=[[NSMutableArray alloc]init];
    for (int i=0; i<4; i++)
    {
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 190)];
        
        [_scrollview addSubview:imageView];
        [_arrayImageView addObject:imageView];
        
    }
    
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth-50)/2, 170, 50, 15)];
    [self addSubview:_pageControl];
    
    _pageControl.numberOfPages=4;
    _pageControl.pageIndicatorTintColor=[UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    
    
    
}


//停止减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{

    _pageControl.currentPage=(_scrollview.contentOffset.x)/kScreenWidth;
    
}

@end
