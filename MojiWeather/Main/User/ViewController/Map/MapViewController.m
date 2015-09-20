//
//  MapViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "MapModel.h"
@interface MapViewController ()
{
    
    MKMapView *_mapView;

    
    NSArray *nearUserArray;
    
    NSMutableArray *array;
    
    
}
@end

@implementation MapViewController


- (instancetype)init
{
    self=[super init];
    if (self) {

        self.hidesBottomBarWhenPushed=YES;
        
    }
    return self;
    
}


#pragma mark -  地图
- (void)_createViews
{
    
    _mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation=YES;
    //地图显示类型
    _mapView.mapType=MKMapTypeStandard;
    //代理
    _mapView.delegate=self;
    
    [self.view addSubview:_mapView];
}



- (void)_loadData
{
    
    AVUser *user=[AVUser currentUser];
    
    
    
    AVObject *userObject = user;
    AVGeoPoint *userLocation =  (AVGeoPoint *) [userObject objectForKey:@"location"];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"location" nearGeoPoint:userLocation];
    //获取10个最接近用户地点的用户
    query.limit = 10;
    nearUserArray = [query findObjects];
    
    
    array=[[NSMutableArray alloc]init];
    
    
    
    for (int i=0; i<nearUserArray.count; i++)
    {
        AVUser *user=nearUserArray[i];
        
        MapModel *model=[[MapModel alloc]init];
       
        model.title=user.username;
        [model setCoordinateFromAVPoint:user[@"location"]];
        
        
        [array addObject:model];
        
    }
      [_mapView addAnnotations:array];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"附近用户";
    [self _createViews];
    [self _loadData];

}

 //实现返回视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    //    MKUserLocation用户当前位置类(直接 return nil; 默认 当前用户是圈，其他是大头针 )
     if([annotation isKindOfClass:[MKUserLocation class]])
     {
         return nil;

     }

     MKPinAnnotationView *pinView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
     if (pinView==nil)
     {
         pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"view"];


         pinView.pinColor=MKPinAnnotationColorGreen;


         //2从天而降
         pinView.animatesDrop=YES;


         //3设置显示标题
         pinView.canShowCallout=YES;
         //添加辅助视图
         pinView .rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];





 }
    
 return pinView;
 
}





@end
