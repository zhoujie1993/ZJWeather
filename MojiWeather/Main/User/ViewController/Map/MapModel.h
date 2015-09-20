//
//  MapModel.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MapModel : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;



- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate NS_AVAILABLE(10_9, 4_0);

-(void) setCoordinateFromAVPoint:(AVGeoPoint *)geoPoint;



@end
