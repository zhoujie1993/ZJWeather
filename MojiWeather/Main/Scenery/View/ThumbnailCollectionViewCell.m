//
//  ThumbnailCollectionViewCell.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/17.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"
#import "AVOSCloud.h"

@implementation ThumbnailCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(ImageModel *)model
{
    _model=model;
    [self setNeedsLayout];

}


-(void)layoutSubviews
{

    _location.text=_model.nowLocation;
    
    //缩略图
    AVFile *file = [AVFile fileWithURL:_model.imageUrl];
    [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        _imageView.image=image;
        
    }];
    
    
}

@end
