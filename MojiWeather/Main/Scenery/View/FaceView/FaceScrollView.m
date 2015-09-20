//
//  FaceScrollView.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "FaceScrollView.h"
#import "Common.h"
#import "UIViewExt.h"

@implementation FaceScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createViews];
    }
    return self;
}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate{
    _faceView.delegate = delegate;
    
}
- (void)_createViews{
    //faceView创建完毕以后，宽高已经重新计算
    _faceView = [[FaceView alloc] initWithFrame:CGRectZero];
    _faceView.backgroundColor = [UIColor clearColor];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    //子视图超出父视图部分不裁剪
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), kScreenWidth, 20)];
    _pageControl.numberOfPages = _faceView.pageNumber;
    _pageControl.currentPage = 0;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControl];
    
    CGRect frame = self.frame;
    frame.size.width = _scrollView.width;
    frame.size.height = CGRectGetHeight(_scrollView.frame) + CGRectGetHeight(_pageControl.frame);
    self.frame = frame;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}

@end
