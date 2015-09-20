//
//  Modal.h
//  02天气
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FutureModal.h"

@interface Modal : NSObject

@property (nonatomic,strong) NSString *city;
@property (nonatomic, copy)  NSArray *futureArray;

//实况
@property (nonatomic,strong) NSString *weather;
@property (nonatomic,strong) NSString *temp;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *humidity;
@property (nonatomic,strong) NSString *wind_direction;
@property (nonatomic,strong) NSString *wind_strength;
@property (nonatomic,strong) NSString *date_y;



@property (nonatomic,strong) NSString *temperature1;
@property (nonatomic,strong) NSString *week1;
@property (nonatomic) NSDictionary *weather_id1;
@property (nonatomic,strong) NSString *weather1;
@property (nonatomic,strong) NSString *wind1;
@property (nonatomic,strong) NSString *date1;

@property (nonatomic,strong) NSString *week2;
@property (nonatomic,strong) NSString *temperature2;
@property (nonatomic) NSDictionary *weather_id2;
@property (nonatomic,strong) NSString *weather2;
@property (nonatomic,strong) NSString *wind2;
@property (nonatomic,strong) NSString *date2;

@property (nonatomic,strong) NSString *week3;
@property (nonatomic,strong) NSString *temperature3;
@property (nonatomic) NSDictionary *weather_id3;
@property (nonatomic,strong) NSString *weather3;
@property (nonatomic,strong) NSString *wind3;
@property (nonatomic,strong) NSString *date3;

@property (nonatomic,strong) NSString *week4;
@property (nonatomic,strong) NSString *temperature4;
@property (nonatomic) NSDictionary *weather_id4;
@property (nonatomic,strong) NSString *weather4;
@property (nonatomic,strong) NSString *wind4;
@property (nonatomic,strong) NSString *date4;

@property (nonatomic,strong) NSString *week5;
@property (nonatomic,strong) NSString *temperature5;
@property (nonatomic) NSDictionary *weather_id5;
@property (nonatomic,strong) NSString *weather5;
@property (nonatomic,strong) NSString *wind5;
@property (nonatomic,strong) NSString *date5;

@property (nonatomic,strong) NSString *week6;
@property (nonatomic,strong) NSString *temperature6;
@property (nonatomic) NSDictionary *weather_id6;
@property (nonatomic,strong) NSString *weather6;
@property (nonatomic,strong) NSString *wind6;
@property (nonatomic,strong) NSString *date6;

@property (nonatomic,strong) NSString *week7;
@property (nonatomic,strong) NSString *temperature7;
@property (nonatomic) NSDictionary *weather_id7;
@property (nonatomic,strong) NSString *weather7;
@property (nonatomic,strong) NSString *wind7;
@property (nonatomic,strong) NSString *date7;






@end
