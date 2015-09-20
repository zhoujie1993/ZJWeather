//
//  DataService.m
//  微博
//
//  Created by Mac on 15/8/12.
//  Copyright (c) 2015年 zhoujie. All rights reserved.

//

#import "DataService.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
@implementation DataService



//专门处理授权回调页
//+(void)requestUrl:(NSString *)urlString
//       httpMethod:(NSString *)method
//           params:(NSMutableDictionary *)params
//            block:(BlcokType)block
//{
//    
//    
//    //01  url
//    NSString *fullString=[BaseUrl stringByAppendingString:urlString];//1
//    NSURL *url=[NSURL    URLWithString:fullString];
//    
//    
//    //02 request
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];//注意 此时 url还没给request
//    [request setTimeoutInterval:60];
//    [request setHTTPMethod:method];
//    
//    
//    
//    //把params  转换格式
//    
//    
//    
//    NSArray *array=[params allKeys];
//    NSMutableString *string=[[NSMutableString alloc]init];//3
//    
//    for (int i=0; i<array.count; i++) {
//        
//        
//        NSString *key=array[i];
//        NSString *value=params[key];
//        
//        [string appendFormat:@"%@=%@",key,value];
//        
//        if (i<array.count-1) {
//            [string appendString:@"&"];
//        }
//        
//    }
//    //    NSLog(@"%@", [params JSONString]);
//    
//    
//    
//    
//    
//    //结合所有字符串
//    if ([method isEqualToString:@"GET"]) {
//        
//        NSString *seperation=url.query?@"&":@"?";//2
//        
//        NSString *paraUrlString=[NSString stringWithFormat:@"%@%@%@",fullString,seperation,string];
//        
//        NSLog(@"%@",paraUrlString);
//        
//        
//        request.URL=[NSURL URLWithString:paraUrlString];
//        
//    }
//    else if([method isEqualToString:@"POST"])
//    {
//        
//        
//        NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data];
//        request.URL=url;
//    }
//    
//    
//    
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        
//        
//        if (connectionError!=nil) {
//            NSLog(@"网络请求失败");
//            
//        }
//
//        
//        //返回一个 url地址 需要登入
//      NSLog(@"%@",response.URL);
//        NSString *urlStr=[NSString stringWithFormat:@"%@",response.URL];
//        
//        if (block)
//        {
//            block(urlStr);
//        }
//        
//    
//        
//    }];
//    
//    
//    
//}
//
//
//
//+(AFHTTPRequestOperation *)requestAFUrl:(NSString *)urlString
//         httpMethod:(NSString *)method
//             params:(NSMutableDictionary *)params
//              datas:(NSMutableDictionary *)dicData 
//              block:(BlcokType)block
//{
//    
//
//    
//    NSString *fullUrlString=[BaseUrl stringByAppendingString:urlString];
//    
//
//    
//    
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//    
//    
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    
//    
// 
//    manager.responseSerializer.acceptableContentTypes=
//     [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
//  
//    
//    if ([method isEqualToString:@"GET"])
//    {
//        
//     AFHTTPRequestOperation *operation=   [manager GET:fullUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSLog(@"上传成功");
//            block(responseObject);
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        
//            NSLog(@"%@",error);
//        }];
//        
//        
//        return operation;
//        
//        
//    }
//    else if( [method isEqualToString:@"POST"])
//    {
//        if (dicData !=nil) {
//            
//            
//            
//            AFHTTPRequestOperation *operation=[manager POST:fullUrlString parameters:params     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                
//                
//                for (NSString *name in dicData)
//                {
//                    NSData *data=dicData[name];
//                    [formData appendPartWithFileData:data name:name fileName:@"1.png" mimeType:@"image/jpeg"];
//                    
//                    
//                }
//                
//            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                NSLog(@"上传成功");
//                block(responseObject);
//                
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"失败");
//
//            }];
//            
//            //监控下载
//            [operation setDownloadProgressBlock:^void(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead  ) {
//                NSLog(@"下载 %li  %lld %lld",bytesRead,totalBytesRead,totalBytesExpectedToRead);
//            }];
//            
//            //监控上传
//            [operation setUploadProgressBlock:^void(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//                NSLog(@"上传 %li %lld  %lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//                
//            }];
//            
//            return operation;
//            
//            
//
//
//            
//        }
//        else
//        {
//            AFHTTPRequestOperation *operation=[manager POST:fullUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"上传成功");
//                block(responseObject);
//                
//
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                 NSLog(@"失败");
//            }];
//            
//            
//            
//          
//            return operation;
//            
//            
//
//            
//        }
//        
//    }
//    
//
//    return nil;
//    
//    
//    
//    
//}



+(void)requestAFUrl:(NSString *)urlString httpMethod:(NSString *)method params:(NSMutableDictionary *)params data:(NSMutableDictionary *)datas block:(BlockType)block
{
    
    //01 构建urlString
    NSString *fullUrlString = [BaseUrl stringByAppendingString:urlString];
    //02 构建manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    if ([method isEqualToString:@"GET"]) {
        [manager GET:fullUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            block(responseObject);
            
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"传输失败");
        }];
        
        
    }else if([method isEqualToString:@"POST"]) {
        //datas存储图片 相关信息
        if (datas != nil) {
            
            AFHTTPRequestOperation *operation = [manager  POST:fullUrlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //图片添加到body 就由这个block来完成
                for (NSString *name in datas){
                    NSData *data = [datas objectForKey:name];
                    [formData appendPartWithFileData:data name:name fileName:@"1.png" mimeType:@"image/jpeg"];
                    
                }
                
            } success:^(AFHTTPRequestOperation * operation, id responseObject) {
                NSLog(@"上传成功");
                block(responseObject);
                
            } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                NSLog(@"上传失败");
            }];
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"上传进度,已经上传 %lld",totalBytesWritten);
                
            }];
            
        }else{
            //不带图片
            [manager POST:fullUrlString parameters:params success:^void(AFHTTPRequestOperation *operation , id responseObject ) {
                NSLog(@"POST成功");
                
                block(responseObject);
                
            } failure:^void(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }
        
    }
    
}




//读取plist文件
+ (id)loadData:(NSString *)string
{
    
    NSString *path=[[NSBundle mainBundle] pathForResource:string ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    id arrayOrDic=[NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
    
    
    
    
    
    
    return arrayOrDic;
}



@end
