//
//  CommentModel.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/19.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import "CommentModel.h"
#import "Common.h"
#import "RegexKitLite.h"

@implementation CommentModel

- (void)setDate:(NSString *)date
{

    //转化成date
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:sourceTimeZone];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    NSDate *date1=[formatter dateFromString:date];
    
    //转换成string
    [formatter setDateFormat:@"MM月dd日HH:mm:ss"];
    _date= [formatter stringFromDate:date1];
    
}


-(void)setComment:(NSString *)comment
{
    _comment=comment;
    
    //   1) 根据comment  计算frame ;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize contenSize = [comment boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    _contentFrame=CGRectMake(10, 70, 300, contenSize.height);
    
    //加图片的高度 80 5 5 ＝＝90
    if (_commentUrl.length>0)
    {
        
        _zoomFrame=CGRectMake(10, 70+contenSize.height+5, 80, 80);
        _cellFrame=CGRectMake(0, 0, kWidth, contenSize.height+70+80+10);
    }
    else
    {
        //如果没有图片
        _zoomFrame=CGRectZero;
        _cellFrame=CGRectMake(0, 0, kWidth, contenSize.height+70+10);
    }
    
    //02处理图片  把[兔子] 转化成<image url = '%@'>
    NSString *regex=@"\\[\\w+\\]";
    NSArray *faceItems=[_comment componentsMatchedByRegex:regex];//[兔子] [微笑]
    
    NSString *configPath=[[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceConfigArray=[NSArray arrayWithContentsOfFile:configPath];
    
    
    for (NSString *faceName in faceItems)
    {
        
        // 对 faceConfigArray 进行筛选（其实只有一个）
        NSString *t=[NSString stringWithFormat:@"chs='%@'",faceName];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:t];
        NSArray *items=[faceConfigArray filteredArrayUsingPredicate:predicate];
        
        if (items.count>0) {
            
            //获取 @"1.png"
            NSDictionary *dicConfig=[items lastObject];
            
            
            NSString *imageName=[dicConfig objectForKey:@"png"];
            
            
            // <image url = '1.png'>
            NSString *replaceString=[NSString stringWithFormat:@"<image url = '%@'>",imageName];
            
            //[兔子]－－》<image url = '001.png'>
            _comment =   [_comment stringByReplacingOccurrencesOfString:faceName withString:replaceString];
 
        }

    }
    
}
@end
