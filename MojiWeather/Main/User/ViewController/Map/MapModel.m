//
//  MapModel.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "MapModel.h"

@implementation MapModel




-(void) setCoordinateFromAVPoint:(AVGeoPoint *)geoPoint
{
    NSNumber *num2=[geoPoint valueForKey:@"longitude"];
    double longitude=[num2 longLongValue];
    NSNumber *num= [geoPoint valueForKey:@"latitude"];
    double latitude=[num doubleValue];

    _coordinate.longitude=longitude;
    _coordinate.latitude=latitude;
}


@end
