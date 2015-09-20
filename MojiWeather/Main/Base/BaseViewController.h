//
//  BaseViewController.h
//  MojiWeather
//
//  Created by Mac on 15/9/15.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface BaseViewController : UIViewController
{
    MBProgressHUD *_hud;
    UIWindow *_tipWindow;

}


- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
          andInterger:(NSInteger)integer;




//显示hud提示-开源代码
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
//完成的提示
- (void)completeHUD:(NSString *)title;


@end
