//
//  FutureWeatherView.h
//  MojiWeather
//
//  Created by zhoujie on 15/8/30.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modal.h"
#import "FuWeaCollectionView.h"

@interface FutureWeatherView : UIView
{
    FuWeaCollectionView *_fuWeaCollectionView;
}

@property (nonatomic, strong) Modal *modal;

@end
