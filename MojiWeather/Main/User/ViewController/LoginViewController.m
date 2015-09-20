//
//  LoginViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "AVOSCloudSNS.h"
#import "UserViewController.h"
#import "RegisterVController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self _createView];
}

#pragma mark - CreateSubViews
- (void)_createView
{
    //背景设置
    UIImage *image=[UIImage imageNamed:@"login_background.png"];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image=image;
    [self.view addSubview:imageView];
    
    //登陆图片
    _LogInImgView=[[UIImageView alloc]initWithFrame:CGRectMake(140, 90, 100, 100)];
    _LogInImgView.image=[UIImage imageNamed:@"rounded_icon.png"];
    [self.view addSubview:_LogInImgView];
    
    
    _userLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 230, 80, 20)];
    _userLabel.text=@"用户名";
    [self.view addSubview:_userLabel];
    _passLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 280, 80, 20)];
    _passLabel.text=@"密码";
    [self.view addSubview:_passLabel];
    
    //账号密码
    _userName=[[UITextField alloc]initWithFrame:CGRectMake(150,225,150,30)];
    _userName.borderStyle=UITextBorderStyleRoundedRect;
    _userName.text=@"周杰";
    [self.view addSubview:_userName];
    
    _passWord=[[UITextField alloc]initWithFrame:CGRectMake(150, 275, 150, 30)];
    _passWord.borderStyle=UITextBorderStyleRoundedRect;
    _passWord.secureTextEntry=YES;
    _passWord.text=@"123456789";
    [self.view addSubview:_passWord];
    
    
    //按钮
    
    _LogInBtn=[[UIButton alloc]initWithFrame:CGRectMake(70, 340, 250, 40)];
    [_LogInBtn setImage:[UIImage imageNamed:@"login_disabled@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:_LogInBtn];
    [_LogInBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _RegisterBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-40,kScreenWidth/2-2, 40)];
    [_RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_RegisterBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_RegisterBtn];
    [_RegisterBtn addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _CancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight-40, kScreenWidth/2, 40)];
    [_CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_CancelBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_CancelBtn];
    [_CancelBtn addTarget:self action:@selector(CancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    //三方登入
    _QQLogInBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight-150, 50, 50)];
    [_QQLogInBtn setImage:[UIImage imageNamed:@"sns_qq@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:_QQLogInBtn];
    [_QQLogInBtn addTarget:self action:@selector(QQbtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _WeiboLogInBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2+50, kScreenHeight-150, 50, 50)];
    [_WeiboLogInBtn setImage:[UIImage imageNamed:@"sns_weibo@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:_WeiboLogInBtn];
    [_WeiboLogInBtn addTarget:self action:@selector(WeibobtnAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 键盘隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
    
}

#pragma - 登入Action
- (void)LoginAction
{
   

    
    [AVUser logInWithUsernameInBackground:_userName.text password:_passWord.text block:^(AVUser *user, NSError *error)
     {
         if (user != nil)
         {
             NSLog(@"登入成功");
             NSLog(@"用户为 %@",user.username);
             
             //给用户添加location
             [AVGeoPoint geoPointForCurrentLocationInBackground:^(AVGeoPoint *geoPoint, NSError *error) {
                 
                 //模拟器的话 定位失败也没事，这2行不会运行
                 [user setObject:geoPoint forKey:@"location"];
                 [user save];
                 
             }];
             
             //保障不管定位成不成功 都save
             [user save];

             [self dismissViewControllerAnimated:YES completion:nil];
            
             _block();
             
         } else {
             NSLog(@"登入失败");
             
         }
         
         
     }];
    
    
}

#pragma mark -注册Action
- (void)RegisterAction
{

    RegisterVController *vc=[[RegisterVController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

#pragma mark -取消Action
- (void)CancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -第三方登陆方法
- (void)QQbtnAction
{
    [self dismissViewControllerAnimated:NO completion:^{
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                NSLog(@"failed to get authentication from weibo. error: %@", error.description);
            } else {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                    }
                }];
            }
        } toPlatform:AVOSCloudSNSQQ];
    }];


    
    
}

- (void)WeibobtnAction
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                NSLog(@"failed to get authentication from weibo. error: %@", error.description);
            } else {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                    }
                }];
            }
            
        } toPlatform:AVOSCloudSNSSinaWeibo];
    }];


    
    
    
}

#pragma mark -登陆结果
- (void)alert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


- (BOOL)filterError:(NSError *)error {
    if (error) {
        [self alert:[error localizedDescription]];
        return NO;
    }
    return YES;
}

- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData{
    
    NSLog(@"%@&&&&&",authData);
    _block();
    
}

@end
