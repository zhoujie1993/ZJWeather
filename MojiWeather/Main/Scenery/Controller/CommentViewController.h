//
//  CommentViewController.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/18.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import "ViewController.h"
#import "ImageModel.h"

@interface CommentViewController : ViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy)  ImageModel *model;

@end
