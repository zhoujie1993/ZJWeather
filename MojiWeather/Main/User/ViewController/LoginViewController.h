//
//  LoginViewController.h
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(void);

@interface LoginViewController : UIViewController

@property (nonatomic,strong) Block block;

//界面
@property (nonatomic,strong)UILabel *userLabel;
@property (nonatomic,strong)UILabel *passLabel;

@property (nonatomic,strong)UIImageView *LogInImgView;
@property (nonatomic,strong)UITextField *userName;
@property (nonatomic,strong)UITextField *passWord;


//按钮
@property (nonatomic,strong)UIButton *LogInBtn;
@property (nonatomic,strong)UIButton *CancelBtn;
@property (nonatomic,strong)UIButton *RegisterBtn;

@property (nonatomic,strong)UIButton *QQLogInBtn;
@property (nonatomic,strong)UIButton *WeiboLogInBtn;

@end
