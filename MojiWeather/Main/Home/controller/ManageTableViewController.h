//
//  ManageTableViewController.h
//  MojiWeather
//
//  Created by zhoujie on 15/8/27.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockArray) (NSMutableArray *modalArray);

@interface ManageTableViewController : UITableViewController<UINavigationControllerDelegate>

@property(nonatomic) NSMutableArray *cityNameArray;
@property(nonatomic,strong)BlockArray block1;

@end
