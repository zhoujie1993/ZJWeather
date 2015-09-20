//
//  SendCommentViewController.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/19.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"

typedef void(^Block) (NSString *string1,UIImage *image,NSString *geo);


@interface SendCommentViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>
{
    //1 文本编辑栏
    UITextView *_textView;
    
    
    //2 工具栏
    UIView *_editorBar;
    
    
    //3 显示缩略图
    ZoomImageView *_zoomImageView;
    
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
    
    
    
    UIImage *_sendImage;
    
    FaceScrollView *_faceViewPanel;
    
    //地点
    UILabel *geoLable;
}

@property(nonatomic,copy)  Block block;
@end
