//
//  CommentTableViewCell.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/18.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "ZoomImageView.h"
#import "WXLabel.h"


@interface CommentTableViewCell : UITableViewCell<WXLabelDelegate>
@property(nonatomic,strong) CommentModel *commentModel;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UILabel *geoLabel;

@property (strong, nonatomic)  WXLabel *comment;
@property(strong,nonatomic)ZoomImageView *zoomImageView;
@end
