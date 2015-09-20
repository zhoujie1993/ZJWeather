//
//  ZoomImageView.m
//  01ZJWeibo
//
//  Created by zhoujie on 15/8/29.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "ZoomImageView.h"

#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
#import "UIViewExt.h"

#import "Common.h"




@implementation ZoomImageView{
    double _length;//总长度
    NSMutableData *_data;//下载的数据
    
    UIProgressView *_progressView;
    NSURLConnection *_connection;
    
    
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if ([super initWithImage:image]) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
}

//gif处理
- (void)_createGifIcon{
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.hidden = YES;
    _iconImageView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconImageView];
    
}


- (void)_initTap
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomIn)];
    
    [self addGestureRecognizer:tap];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    
}

//点击放大
- (void)zoomIn{
    //隐藏原图
    self.hidden = YES;
    
    //02创建大图浏览_scrollView;
    [self _createView];
    
    //03计算出_fullImageView.frame
    //计算出小图self 相对于 window坐标
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    //04放大
    [UIView animateWithDuration:0.5 animations:^{
        _fullImageView.frame =_scrollView.bounds;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
    }];
    
    //05请求网络 下载大图
    if (self.fullImageUrlString.length > 0) {
        NSURL *url = [NSURL URLWithString:self.fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        
         _connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
    
    }
    
}
//缩小
- (void)zoomOut{
    
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        
        [self.delegate imageWillZoomOut:self];
        
    }
    
    
    //取消网络下载
    [_connection cancel];
    
    //缩小动画效果
    self.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.backgroundColor = [UIColor clearColor];
                         CGRect frame = [self convertRect:self.bounds  toView:self.window];
                         _fullImageView.frame = frame;
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [_scrollView removeFromSuperview];
                         _scrollView = nil;
                         _fullImageView = nil;
                         _progressView = nil;
                         _data = nil;
                     }];
    
}

- (void)_createView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
    
        _fullImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _fullImageView.contentMode =UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOut)];
        
        [_scrollView addGestureRecognizer:tap];
        
        
        //02长按进度条
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(savePhoto:)];
        //longPress.minimumPressDuration =1.5;
        [_scrollView addGestureRecognizer:longPress];
        
        
        //4 添加进度条
        _progressView = [[UIProgressView alloc] init];
        _progressView.frame = CGRectMake(10, kHeight/2, kWidth-20, 50);

        _progressView.hidden = YES;
        
        [_scrollView addSubview:_progressView];
    }
}

- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex ==1) {
        UIImage *img = [UIImage imageWithData:_data];
        //1.提示保存
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"正在保存";
        hud.dimBackground = YES;
        
        //2.将大图图片保存相册
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)(hud));
        
        
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //提示保存成功
    MBProgressHUD *hud = (__bridge MBProgressHUD*)(contextInfo);
    
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText =@"保存成功";
    
    [hud hide:YES afterDelay:1.5];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    //响应,length
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    //01取得响应头信息
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    
    NSString *size = [allHeaderFields objectForKey:@"Content-Length"];
    
    _length = [size doubleValue];
    
    _data = [[NSMutableData alloc]init];
    _progressView.hidden = NO;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    CGFloat progress = _data.length/_length;
    _progressView.progress = progress;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _progressView.hidden = YES;
    
    
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    //处理imageView尺寸
    // 图片的长/图片的宽 ==  ImageView.长（？）/屏幕宽
    [UIView animateWithDuration:0.5 animations:^{
        
        CGFloat length = image.size.height/image.size.width * kWidth;
        if (length < kHeight) {
            _fullImageView.top = (kHeight-length)/2;
        }
        _fullImageView.height = length;
        _scrollView.contentSize = CGSizeMake(kWidth, length);
        
        
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        
    }];
    
    if (self.isGif) {
        [self gifImageShow];
    }
}

- (void)gifImageShow{
    //1.-----------------webView播放---------------------
    //            UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
    //            webView.userInteractionEnabled = NO;
    //            webView.backgroundColor = [UIColor clearColor];
    //            webView.scalesPageToFit = YES;
    //
    //            //使用webView加载图片数据
    //            [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //            [_scrollView addSubview:webView];
    
    
    //2. ---------使用ImageIO 提取GIF中所有帧的图片进行播放---------------
    //#import <ImageIO/ImageIO.h>
    
    //
    //    //1>创建图片源
    //    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(_data), NULL);
    //
    //    //2>获取图片源中图片的个数
    //    size_t count = CGImageSourceGetCount(source);
    //
    //    NSMutableArray *images = [NSMutableArray array];
    //
    //    NSTimeInterval duration = 0;
    //
    //    for (size_t i=0; i<count; i++) {
    //
    //        //3>取得每一张图片
    //        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
    //        UIImage *uiImg = [UIImage imageWithCGImage:image];
    //        [images addObject:uiImg];
    //
    //        //0.1 是一帧播放的时间，累加每一帧的时间
    //        duration += 0.1;
    //    }
    //
    //    //>4-1.或者将所有帧的图片集成到一个动画UIImage对象中
    //    UIImage *imgs = [UIImage animatedImageWithImages:images duration:duration];
    //    _fullImageView.image = imgs;
    //
    //    //        //>4-2.或者将播放的图片组交给_fullImageView播放
    //    //        _fullImageView.animationImages = images;
    //    //        _fullImageView.animationDuration = duration;
    //    //        [_fullImageView startAnimating];
    
    
    //3 -------------SDWebImage 封装的GIF播放------------------
    //#import "UIImage+GIF.h"
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    
}


@end
