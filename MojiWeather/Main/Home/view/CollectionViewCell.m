//
//  CollectionViewCell.m
//  MojiWeather
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "CollectionViewCell.h"

#import "Common.h"

@implementation CollectionViewCell


//后于xib调用  简单地说如果你的——scrollView是从XIB里面拉出来的 ，那么你调用initWithCoder:的时候scrollView还是空得会形成错误
- (void)awakeFromNib {
    [self _createSubViews];

    
}



- (void)_createSubViews
{
    
    
    self.backgroundColor=[UIColor clearColor];
    
    
    _scrollView.frame =CGRectMake(0, 0,kWidth, kHeight);
    //_scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.contentSize = CGSizeMake(kWidth, (kHeight-64-40)*2);
    
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.delegate =self;
    _scrollView.backgroundColor=[UIColor clearColor];
    
    



    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,kHeight-64-40, kWidth, kHeight)];
    imgView.image = [UIImage imageNamed:@"bg_fog.jpg"];
    [_scrollView addSubview:imgView];
    
    
    
    weatherView = [[FutureWeatherView alloc]initWithFrame:CGRectMake(0,kHeight-40 , kWidth, kHeight)];
    weatherView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:weatherView];
    


}
-(void)setModal:(Modal *)modal
{
    
    
    _modal=modal;
    


    weatherView.modal = _modal;

    
    
    [self setNeedsLayout];
    
    
}




- (void)layoutSubviews
{
    
    NSString *fa1 = [_modal.weather_id1 objectForKey:@"fa"];

    NSString *iconDay1 =[NSString stringWithFormat:@"/40x40/day/%@.png",fa1];
    
    NSString *fa2 = [_modal.weather_id2 objectForKey:@"fa"];

    NSString *iconDay2 =[NSString stringWithFormat:@"/40x40/day/%@.png",fa2];
    
    NSString *fa3 = [_modal.weather_id3 objectForKey:@"fa"];

    NSString *iconDay3 =[NSString stringWithFormat:@"/40x40/day/%@.png",fa3];
    
    // 程序包根路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    // 主题包的完整路径
    NSString *path1 = [bundlePath stringByAppendingPathComponent:iconDay1];
    NSString *path2 = [bundlePath stringByAppendingPathComponent:iconDay2];
    NSString *path3 = [bundlePath stringByAppendingPathComponent:iconDay3];

    
    
    
    self.temperature1.text =  _modal.temperature1;
    self.week1.text = _modal.week1;
    self.weather1.text = _modal.weather;
    
    
    self.weathImg1.image = [UIImage imageWithContentsOfFile:path1];
    
    self.temperature2.text =  _modal.temperature2;
    self.week2.text = _modal.week2;
    self.weather2.text = _modal.weather2;

    
    self.weathImg2.image = [UIImage imageWithContentsOfFile:path2];
    
    self.temperature3.text =  _modal.temperature3;
    self.week3.text = _modal.week3;
    self.weather3.text = _modal.weather3;
    
    self.weathImg3.image = [UIImage imageWithContentsOfFile:path3];
    
    self.time.text =_modal.time;
    self.weather.text =_modal.weather;
    self.humidity.text = _modal.humidity;
    self.wind_strength.text = _modal.wind_strength;
    self.wind_direction.text = _modal.wind_direction;
    self.date_y.text=_modal.date_y;

    self.city.text =_modal.city;

}


@end
