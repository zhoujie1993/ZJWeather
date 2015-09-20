//
//  FutureModal.h
//  02天气
//
//  Created by zhoujie on 15/8/30.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <Foundation/Foundation.h>
//                   {
//                       "temperature": "28℃~36℃",
//                       "weather": "晴转多云",
//                       "weather_id": {
//                           "fa": "00",
//                           "fb": "01"
//                       },
//                       "wind": "南风3-4级",
//                       "week": "星期一",
//                       "date": "20140804"
//                   }
@interface FutureModal : NSObject

@property (nonatomic,strong) NSString *week;
@property (nonatomic,strong) NSString *temperature;
@property (nonatomic) NSDictionary *weather_id;
@property (nonatomic,strong) NSString *weather;
@property (nonatomic,strong) NSString *wind;
@property (nonatomic,strong) NSString *date;

@end
