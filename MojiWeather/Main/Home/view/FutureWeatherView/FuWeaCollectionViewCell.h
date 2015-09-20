//
//  FuWeaCollectionViewCell.h
//  MojiWeather
//
//  Created by zhoujie on 15/8/30.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

//@property (nonatomic,strong) NSString *wind_direction;
//@property (nonatomic,strong) NSString *wind_strength;


#import <UIKit/UIKit.h>
#import "FutureModal.h"

@interface FuWeaCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)  FutureModal *futuremodal;

@property (strong, nonatomic) IBOutlet UILabel *week;
@property (strong, nonatomic) IBOutlet UILabel *weatherDay;
@property (strong, nonatomic) IBOutlet UILabel *weatherNight;
@property (strong, nonatomic) IBOutlet UIImageView *iconDay;
@property (strong, nonatomic) IBOutlet UIImageView *iconNight;


@property (strong, nonatomic) IBOutlet UILabel *maxTemperature;
@property (strong, nonatomic) IBOutlet UILabel *minTemperature;
@property (strong, nonatomic) IBOutlet UILabel *today;

@property (strong, nonatomic) IBOutlet UILabel *wind_direction;
@property (strong, nonatomic) IBOutlet UILabel *wind_strength;

@end
