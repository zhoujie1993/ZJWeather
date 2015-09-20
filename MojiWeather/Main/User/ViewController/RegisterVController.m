//
//  RegisterVController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/17.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "RegisterVController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RegisterVController ()

@end

@implementation RegisterVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册
- (IBAction)certainAction:(id)sender {
    AVUser *user = [AVUser user];
    
    
    user.username =_userName.text;
    user.password =  _password.text;
    user.email = _email.text;
    [user setObject:_phoneNumber.text forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"注册失败");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
            
        }
    }];
    
    
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
