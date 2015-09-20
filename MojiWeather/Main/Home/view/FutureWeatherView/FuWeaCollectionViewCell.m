//
//  FuWeaCollectionViewCell.m
//  MojiWeather
//
//  Created by zhoujie on 15/8/30.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "FuWeaCollectionViewCell.h"

@implementation FuWeaCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _createSubViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _createSubViews];
    
    
}

- (void)_createSubViews
{
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark -layoutSubviews
-(void)setFuturemodal:(FutureModal *)futuremodal
{
    _futuremodal =futuremodal;
     [self setNeedsLayout];
}



- (void)layoutSubviews
{
    
    NSDictionary *futuredic = (NSDictionary*)_futuremodal;
    NSMutableDictionary *dic =[futuredic objectForKey:@"weather_id"];
    
    NSString *iconDay = [dic objectForKey:@"fa"];
    NSString *iconNight = [dic objectForKey:@"fb"];
    
    NSString *iconDay1 =[NSString stringWithFormat:@"/40x40/day/%@.png",iconDay];
    NSString *iconNight1 =[NSString stringWithFormat:@"/40x40/night/%@.png",iconNight];
    
    // 程序包根路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    // 主题包的完整路径
    NSString *path1 = [bundlePath stringByAppendingPathComponent:iconDay1];
    NSString *path2 = [bundlePath stringByAppendingPathComponent:iconNight1];
    
    _iconDay.image = [UIImage imageWithContentsOfFile:path1];
    _iconNight.image = [UIImage imageWithContentsOfFile:path2];
    
    
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"];
    NSDictionary *dic1=[NSDictionary dictionaryWithContentsOfFile:path];
    
    _weatherDay.text = [dic1 objectForKey:iconDay];
    _weatherNight.text = [dic1 objectForKey:iconNight];
    
    
    _week.text  = [futuredic objectForKey:@"week"] ;
    
    NSString *temperatureStr = [futuredic objectForKey:@"temperature"] ;
    NSArray  *array= [temperatureStr componentsSeparatedByString:@"~"];
    
    _maxTemperature.text = array[0];
    _minTemperature.text = array[1];
    NSString *b = [[futuredic objectForKey:@"date"] substringFromIndex:4];
    NSMutableString *c = [NSMutableString stringWithString:b];
    [c insertString:@"/" atIndex:2];
    _today.text = c;
    
    NSArray  *arrayWind= [[futuredic objectForKey:@"wind"] componentsSeparatedByString:@"风"];
    _wind_direction.text = [NSString stringWithFormat:@"%@风", arrayWind[0]];
    _wind_strength.text = arrayWind[1];
 
    
}
@end
