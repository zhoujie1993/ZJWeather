//
//  SendCommentViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/19.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import "SendCommentViewController.h"
#import "DataService.h"
#import "AVOSCloud.h"

#import "Common.h"
#import "UIViewExt.h"


@interface SendCommentViewController ()

@end

@implementation SendCommentViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return  self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createNavItems];
    [self _createEditorViews];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated];
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.translucent =NO;
    _textView.frame = CGRectMake(0, 0, kWidth, 120);
    _textView.contentInset= UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_textView becomeFirstResponder];
}

#pragma  mark - 创建子视图
- (void)_createNavItems{
    //1.关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeButton setBackgroundImage:[UIImage imageNamed: @"button_icon_close.png" ] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    //2.发送按钮
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setBackgroundImage:[UIImage imageNamed: @"button_icon_ok.png" ] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
}

- (void)_createEditorViews{
    
    //1 文本输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.editable = YES;
    _textView.backgroundColor = [UIColor lightGrayColor];
    
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_textView];
    
    //2 编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15+(kWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [_editorBar addSubview:button];
    }
    
    geoLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    geoLable.text=@"该用户未定位";
    geoLable.hidden=YES;
    geoLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:geoLable];
    
}

- (void)buttonAction:(UIButton*)button{
    if (button.tag == 10) {
        [self _selectPhoto];
    }
    else  if (button.tag==11)//加个#
    {
        //加个#
        NSMutableString *mString=[[NSMutableString alloc]initWithString:_textView.text];
        _textView.text= [mString stringByAppendingString:@"#"];
    }
    else  if (button.tag==12)//@谁 没研究过补全 所以直接名字列出来
    {
        
        
    }
    else if(button.tag == 13)
    {
        [self _location];
        
    }  else if(button.tag == 14) {  //显示、隐藏表情
        
        BOOL isFirstResponder = _textView.isFirstResponder;
        
        //输入框是否是第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder) {
            //隐藏键盘
            [_textView resignFirstResponder];
            //显示表情
            [self _showFaceView];
            //隐藏键盘
            
        } else {
            //隐藏表情
            [self _hideFaceView];
            
            //显示键盘
            [_textView becomeFirstResponder];
        }
        
    }
    
    
}


#pragma mark - 表情处理

- (void)_showFaceView{
    
    //创建表情面板
    if (_faceViewPanel == nil) {
        
        
        _faceViewPanel = [[FaceScrollView alloc] init];
        [_faceViewPanel setFaceViewDelegate:self];
        //放到底部
        _faceViewPanel.top  = kHeight-64;
        [self.view addSubview:_faceViewPanel];
    }
    
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        
        _faceViewPanel.bottom = kHeight-64;
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPanel.top;
        
    }];
}

//隐藏表情
- (void)_hideFaceView {
    
    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.top = kHeight-64;
        
    }];
    
}


- (void)faceDidSelect:(NSString *)text{
   
    NSMutableString *mString=[[NSMutableString alloc]initWithString:_textView.text];
    
    _textView.text= [mString stringByAppendingString:text];
}

#pragma mark - 地理位置
- (void)_location
{
    /*
     修改 info.plist 增加以下两项
     NSLocationWhenInUseUsageDescription  BOOL YES
     NSLocationAlwaysUsageDescription         string “提示描述”
     */
    
    
    
    if (_locationManager == nil ) {
        _locationManager = [[CLLocationManager alloc]init];
        if (kVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精确定位
    _locationManager.delegate =self;
    [_locationManager startUpdatingLocation];
    
}

//代理获取定位数据
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [_locationManager stopUpdatingLocation];
    //取得位置信息
    CLLocation *location = [locations lastObject];
    
    
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度%lf纬度%lf",coordinate.longitude,coordinate.latitude);
    
    
    
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:coordinateStr forKey:@"coordinate"];
    
    __weak SendCommentViewController *weakSelf =self;
    
    //二 IOS 自己内置
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        __strong SendCommentViewController *strongSelf=weakSelf;
        
        CLPlacemark *place = [placemarks lastObject];
        NSLog(@"%@",place.name);
        
        strongSelf->geoLable.hidden=NO;
        
        strongSelf->geoLable.bottom=strongSelf->_editorBar.top;
        
        if (error==nil) {
            strongSelf->geoLable.text=place.locality;
            
        }
        else
        {
            strongSelf->geoLable.text=@"定位失败";
            
        }
        
        
        
    }];
}


- (void)sendAction{
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }
    else if(text.length > 140) {
        error = @"微博内容大于140字符";
    }
    
    if (error != nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

     _block(text,_zoomImageView.image,geoLable.text);

    [self closeAction];
    
}

- (void)closeAction{
    
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}



#pragma mark - 键盘弹出通知

- (void)keyBoardWillShow:(NSNotification *)notification{
    
    //    NSLog(@"%@",notification);
    //1 取出键盘frame
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    
    CGRect frame = [bounsValue CGRectValue];
    //2 键盘高度
    //CGFloat height = frame.size.height;
    //_editorBar.bottom = kHeight -height -60;
    
    _editorBar.bottom = frame.origin.y - 64;
}

#pragma mark -选择照片
- (void)_selectPhoto{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    //选择相机 或者 相册
    if (buttonIndex == 0) {
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    }else if(buttonIndex == 1){
        
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }else{
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    //2 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //3 显示缩略图
    
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc]initWithImage:image];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView];
        
        _zoomImageView.delegate = self;
    }
    _zoomImageView.image = image;
    _sendImage = image;
}

#pragma mark - 放大缩小图片 代理

//当图片放大时候键盘隐藏,缩小的时候键盘恢复
- (void)imageWillZoomOut:(ZoomImageView *)imageView{
    
    [_textView becomeFirstResponder];
    
}
- (void)imageWillZoomIn:(ZoomImageView *)imageView{
    [_textView resignFirstResponder];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
