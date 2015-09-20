//
//  BaseViewController.m
//  MojiWeather
//
//  Created by Mac on 15/9/15.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "BaseViewController.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
  self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home.jpg"]];
    
    
    
}

#pragma mark - 状态栏提示

- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            andInterger:(NSInteger)integer
{
    
    
    if (_tipWindow == nil) {
        //创建window
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        //创建Label
        UILabel *tpLabel = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tpLabel.backgroundColor = [UIColor clearColor];
        tpLabel.textAlignment = NSTextAlignmentCenter;
        tpLabel.font = [UIFont systemFontOfSize:13.0f];
        tpLabel.textColor = [UIColor whiteColor];
        tpLabel.tag = 100;
        [_tipWindow addSubview:tpLabel];
        
        
        //进度条
        UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progress.frame = CGRectMake(0, 20-3, kScreenWidth, 5);
        progress.tag = 101;
        progress.progress = 0.0;
        [_tipWindow addSubview:progress];
        progress.tintColor=[UIColor blueColor];
        progress.progressTintColor=[UIColor redColor];
   
    }
    
    UILabel *tpLabel = (UILabel *)[_tipWindow viewWithTag:100];
    tpLabel.text = title;
    
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    
    if (show) {
        _tipWindow.hidden = NO;
        if (integer != 0) {
            progressView.hidden = NO;
           
            progressView.progress=integer*0.01;
            
            
        }else{
            progressView.hidden = YES;
        }
        
        
    }else{
        
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
}


- (void)removeTipWindow
{
    
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}




#pragma mark 使用三方库实现加载提示
//显示hud提示
- (void)showHUD:(NSString *)title {
    
    
   
    _hud = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
  
    
    [_hud show:YES];
    _hud.labelText = title;
    //_hud.detailsLabelText  //子标题
    
    //灰色的背景盖住其他视图
    _hud.dimBackground = YES;
}

- (void)hideHUD {
    
    //延迟隐藏
    //[_hud hide:YES afterDelay:(NSTimeInterval)]
    
    [_hud hide:YES];

}

//完成的提示
- (void)completeHUD:(NSString *)title {
    
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    //延迟隐藏
    [_hud hide:YES afterDelay:1.5];
}



@end
