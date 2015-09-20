//
//  CollectionViewCell.h
//  MojiWeather
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modal.h"
#import "FutureWeatherView.h"

@interface CollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
{
    FutureWeatherView *weatherView;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UILabel *temperature1;
@property (strong, nonatomic) IBOutlet UILabel *week1;
@property (strong, nonatomic) IBOutlet UIImageView *weathImg1;
@property (strong, nonatomic) IBOutlet UILabel *weather1;



@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UILabel *week2;
@property (strong, nonatomic) IBOutlet UILabel *temperature2;
@property (strong, nonatomic) IBOutlet UIImageView *weathImg2;
@property (strong, nonatomic) IBOutlet UILabel *weather2;


@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UILabel *week3;
@property (strong, nonatomic) IBOutlet UILabel *temperature3;
@property (strong, nonatomic) IBOutlet UIImageView *weathImg3;
@property (strong, nonatomic) IBOutlet UILabel *weather3;



@property (strong, nonatomic) IBOutlet UILabel *weather;
@property (strong, nonatomic) IBOutlet UILabel *temp;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UILabel *humidity;

@property (strong, nonatomic) IBOutlet UILabel *wind_strength;

@property (strong, nonatomic) IBOutlet UILabel *wind_direction;

@property (strong, nonatomic) IBOutlet UILabel *date_y;



@property (strong, nonatomic) IBOutlet UILabel *city;



@property (nonatomic) Modal *modal;



@end
