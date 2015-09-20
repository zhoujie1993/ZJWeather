//
//  DataService.h
//  微博
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Header.h"



typedef void(^BlockType)(id result);

@interface DataService : NSObject


+(void)requestAFUrl:(NSString *)urlString httpMethod:(NSString *)method params:(NSMutableDictionary *)params data:(NSMutableDictionary *)datas block:(BlockType)block;

+ (id)loadData:(NSString *)string;
@end
