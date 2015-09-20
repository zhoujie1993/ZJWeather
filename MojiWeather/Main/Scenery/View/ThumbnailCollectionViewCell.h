//
//  ThumbnailCollectionViewCell.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/17.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

@interface ThumbnailCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *location;

@property(nonatomic,strong) ImageModel *model;

@end
