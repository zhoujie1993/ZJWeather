//
//  CommentModel.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/19.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentModel : NSObject

@property (nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSString *userImageUrl;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *geo;
//评论中有图
@property(nonatomic,strong) NSString *commentUrl;

#warning mark - 考虑到方便因素在这里同时处理frame frame取决于comment内容
@property(nonatomic,assign) CGRect contentFrame;
@property(nonatomic,assign) CGRect cellFrame;
@property(nonatomic,assign)CGRect zoomFrame;

@end
