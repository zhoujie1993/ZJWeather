//
//  ScrollPlayView.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/17.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollPlayView : UIView<UIScrollViewDelegate>
{
    
    UIScrollView *_scrollview;
    UIPageControl *_pageControl;
    NSMutableArray *_arrayImageView;
}

@property(nonatomic,strong)NSArray *array;
@end
