//
//  UserViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "UserViewController.h"
#import <AVOSCloud.h>
#import "AVOSCloudSNS.h"
#import "UserTableViewCell.h"
#import "Common.h"
#import "LoginViewController.h"
#import "MapViewController.h"

@interface UserViewController ()
{
    UITableView *_tableView;
    UIButton *headView;
    UIImageView *userImgView;
    UILabel *userID;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"3385422392" andAppSecret:@"bd3c14e6b6436a9f2b560593c1d0a574" andRedirectURI:@"http://www.baidu.com"];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:@"100512940" andAppSecret:@"afbfdff94b95a2fb8fe58a8e24c4ba5f" andRedirectURI:nil];
    
    self.title = @"更多";
    [self _createTableView];
    [self _createHeadView];
    
}

#pragma mark - createTableView
- (void)_createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
}

#pragma mark - createHeadView按钮
- (void)_createHeadView
{
    
    headView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    [headView  setBackgroundImage:[UIImage imageNamed:@"account_bg@2x.png"] forState:UIControlStateNormal];
    
    _tableView.tableHeaderView=headView;
    headView.backgroundColor=[UIColor whiteColor];
    [headView addTarget:self action:@selector(headImageViewButoonAction) forControlEvents:UIControlEventTouchUpInside];
    
    userImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [headView addSubview:userImgView];
    userImgView.layer.cornerRadius=30;
    userImgView.layer.masksToBounds = YES;
    userImgView.layer.borderColor=[UIColor grayColor].CGColor;
    userImgView.layer.borderWidth=1;
    
    
    userID=[[UILabel alloc]initWithFrame:CGRectMake(80, 20, 200, 60)];
    userID.textAlignment=NSTextAlignmentCenter;
    
    [headView addSubview:userID];
    
    [self isEnter];
}

#pragma mark - headImageView按钮的Action
- (void)headImageViewButoonAction
{
    
    AVUser *user=[AVUser currentUser];
    
    if (user!=nil) {
        //有用户
        NSLog(@"已有用户");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已有用户" message:@"请退出再登入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {

        LoginViewController *vc=[[LoginViewController alloc]init];
        __weak UserViewController *vcc=self;
        
        vc.block=^{
            
            [vcc  isEnter];
            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

#pragma mark - 判断是否已经登陆
- (void)isEnter
{
    //当前用户
    AVUser *user=[AVUser currentUser];
    
    if (user!=nil) {
        //缩略图
        NSLog(@"%@",user[@"image"]);
        AVFile *file = [AVFile fileWithURL:user[@"image"]];
        [file getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
            
            userImgView.image=image;
            
        }];
        
        userID.text=user.username;
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:1];
        
        
        userImgView.frame=CGRectMake((kScreenWidth-60)/2, 10, 60, 60);
        userID.frame=CGRectMake((kScreenWidth-60)/2-70, 55, 200, 60);
        
        
        [UIView commitAnimations];
        
    }
    else
    {
        
        userID.text= @"请登入账号";
        userImgView.image=[UIImage imageNamed:@"ugc_face_default.png"];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        
        userImgView.frame=CGRectMake(20, 20, 60, 60);
        userID.frame=CGRectMake(80, 20, 200, 60);
        
        [UIView commitAnimations];
        
    }
    
}

#pragma mark -DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //section=0时候只有默认一个 而且高度为0也就是说只有头视图
    if (section == 1) {
        
        return 4;
        
    }
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section==0)
    {
        
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            cell.labelText.text=@"意见反馈";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        else if(indexPath.row==1)
        {
            cell.labelText.text=@"修改密码";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        else if(indexPath.row==2)
        {
            cell.labelText.text=@"上传头像";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        else if(indexPath.row==3)
        {
            cell.labelText.text=@"附近用户";
            cell.imageView.image=[UIImage imageNamed:@"cm_unfavorite_btn_normal.png"];
        }
        
        
    }
    else if(indexPath.section==2)
    {
        cell.labelText.text=@"退出当前登入";
        cell.labelText.center=cell.contentView.center;
        cell.labelText.textAlignment=NSTextAlignmentCenter;
        
    }

    //箭头
    if (indexPath.section != 2&&indexPath.section != 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            return 0;
        }
    }
    return 44;
    
}

#pragma mark - TableViewDidSelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后渐渐消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //意见反馈
    if(indexPath.section==1&&indexPath.row==0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"感谢您的支持" message:@"请发送邮件到675592655@qq.com" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];        
        [alert show];
        
    }
    
    //修改密码
    if(indexPath.section==1&&indexPath.row==1)
    {
        NSLog(@"修改密码");
        [self resetPassword];
        
    }
    
    //上传头像
    if(indexPath.section==1&&indexPath.row==2)
    {
        [self updateHeadImage];
    }
    
    //附近用户
    if(indexPath.section==1&&indexPath.row==3)
    {
        MapViewController *vc=[[MapViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    //用户退出
    if(indexPath.section==2&&indexPath.row==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认登出么?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    
 
    
}

#pragma mark - 修改密码

- (void)resetPassword
{
    
    AVUser *user=[AVUser currentUser];
    if(user!=nil)
    {
        if(user.email!=nil)
        {
            [AVUser requestPasswordResetForEmailInBackground:user.email block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发送注册邮箱" message:@"请在邮箱内查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    
                }
            }];
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"第三方登入" message:@"没有邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}


#pragma mark - 用户登出
//因为其他alert的buttonIndex = 1 的都是nil 所有这里可以直接这样判断
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {

        NSDictionary *authData = [[AVUser currentUser] objectForKey:@"authData"];
        //有三种不同登陆方式
        if (authData) {
            if ([authData objectForKey:AVOSCloudSNSPlatformQQ]) {
                [AVOSCloudSNS logout:AVOSCloudSNSQQ];
            }
            else if ([authData objectForKey:AVOSCloudSNSPlatformWeiBo]) {
                [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
            }
        }
        
        [AVUser logOut];
        
        //注销后要考虑头视图的变化
        [self isEnter];
        
    }
    
}

#pragma mark - 上传头像
- (void)updateHeadImage
{
    
    AVUser *user=[AVUser currentUser];
    NSLog(@"%@",user.username);
    
    if (user!=nil) {

        [self _selectPhoto];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}

#pragma mark - 选择照片
- (void)_selectPhoto
{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex==0)
    {
        //拍照
        sourceType=UIImagePickerControllerSourceTypeCamera;
        
        BOOL isCamera=[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (isCamera==NO)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
    }
    else if (buttonIndex==1)
    {
        //选择相册
        sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else if(buttonIndex==2)
    {
        return;
        
        
    }
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=sourceType;
    //这个delegate需要UIImagePickerControllerDelegate,UINavigationControllerDelegate 这2个
    picker.delegate=self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
 
}

#pragma mark - ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    AVUser *user=[AVUser currentUser];
    [self showHUD:@"正在上传"];
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);

    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"图片保存成功");
            NSLog(@"%@",imageFile.url);
            [user setObject: imageFile.url forKey:@"image"];
            [user saveInBackground];
            //及时修改头视图
            [self isEnter];


            [self completeHUD:@"上传完成"];
            
        }
    }];
    
}


@end
