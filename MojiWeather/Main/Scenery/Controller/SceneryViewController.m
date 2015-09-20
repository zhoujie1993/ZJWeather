//
//  SceneryViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//


#import "SceneryViewController.h"
#import "AVOSCloud.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocation.h>

#import "ScrollPlayView.h"
#import "Common.h"
#import "ThumbnailCollectionViewCell.h"
#import "ImageModel.h"
#import "CommentViewController.h"

@interface SceneryViewController ()
{
    NSString *_nowLocation;//当前地理位置
    ScrollPlayView  *_scrollPlayingView;
    UICollectionView *_collectionView;
    
    NSMutableArray *_arrayModel;//图片模型
    UIImagePickerController *_picker;
}
@end

@implementation SceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"实景";
    
 
   
    
    [self getGeoPoint];
    
    [self _createCollectionView];
    
    [self _createHeaderView];
    
    [self _createBarButtonItem];
    
    [self _createImagePicker];
    
    
    
    [self loadData];
    
    _collectionView .header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

#pragma  mark - 上传图片
- (void)selectImage
{
    
    [self getGeoPoint];

    AVUser *user=[AVUser currentUser];
    if (user!=nil) {
        
        [self presentViewController:_picker animated:YES completion:nil];

    }
    else
    {
        
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"请登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
    }

}

//关闭相册后  1）保存image  2）创建comment文件  3）获取url 4）model添加url和commentId  5）url添加到json并保存
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _nowLocation = @"";
    [self showHUD:@"正在上传"];
    [_picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"图片选择完毕");
    }];
    
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];

    
    NSData *imageData = UIImagePNGRepresentation(image);
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    

    //保存图片
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         
         if (succeeded)
         {
             
             NSLog(@"图片保存成功");
             [self completeHUD:@"上传完成"];
             
             //创建comment文件
             AVObject *comment = [AVObject objectWithClassName:@"Comment"];
             [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 
                 //  (1)查询基础文件
                 AVObject *post = [AVObject objectWithoutDataWithClassName:@"Post" objectId:baseInit];
                 AVUser *user=[AVUser currentUser];
                 
                 //  (2)_arrayModel添加
                 ImageModel *model=[[ImageModel  alloc]init];
                 model.imageUrl=imageFile.url;
                 model.commentId=comment.objectId;
                 model.useName=user.username;
                 model.nowLocation=_nowLocation;
                 [_arrayModel insertObject:model atIndex:0];
                 
                 NSLog(@"%@",model.imageUrl);
                 NSLog(@"%@",comment.objectId);
                 NSLog(@"%@",user.username);
                 
                 NSLog(@"%@11111",_nowLocation);
                 
                 // （3）设置 数据存储格式并保存
                 
                 NSDictionary *dic=@{@"url": model.imageUrl,
                                     @"commentId" :comment.objectId,
                                     @"userName":user.username,
                                     @"cityName":_nowLocation
                                     };
                 
                 [post addObject:dic forKey:@"images"];
                 
                 [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     NSLog(@"文件正在保存成功");
                     
                     if (succeeded)
                     {
                         NSLog(@"文件保存成功");
                     }
                 }];
                 
                 [_collectionView reloadData];
                 _scrollPlayingView.array=_arrayModel;
                 
             }];
         }
     }];
}

#pragma mark - loadData
- (void)loadData
{
    
    
    _arrayModel=[[NSMutableArray array]init];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:baseInit block:^(AVObject *object, NSError *error) {
        
        
        
        NSArray *array= object[@"images"];
        for (int i=0; i<array.count; i++)
        {
            ImageModel *model=[[ImageModel  alloc]init];
            model.imageUrl=array[i][@"url"];
            model.commentId=array[i][@"commentId"];
            model.useName=array[i][@"userName"];
            model.nowLocation=array[i][@"cityName"];
            
            
            
            [_arrayModel insertObject:model atIndex:0];
        }
        [_collectionView reloadData];
        
        _scrollPlayingView.array=_arrayModel;

        
        [_collectionView.header endRefreshing];
    }];
    
    
}



#pragma mark 初始化获取地理坐标

- (void)getGeoPoint
{
    
    [AVGeoPoint geoPointForCurrentLocationInBackground:^(AVGeoPoint *geoPoint, NSError *error) {
      
        
        
        if (error!=nil) {
            NSLog(@"%@",error);
            
            
            
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil   ,nil];
            
            [alterView show];
            
            _nowLocation=@"定位失败";
            
            
        }
        else
        {
            AVGeoPoint *  point=geoPoint;
            
            
            
            NSNumber *num2=[point valueForKey:@"longitude"];
            double longitude=[num2 longLongValue];
            NSNumber *num= [point valueForKey:@"latitude"];
            double latitude=[num doubleValue];
            
            //
            //    NSLog(@"%@",point);
            
            //
            //    NSLog(@"latitude=%lf longitude=%lf",latitude,longitude);
            //
            //进行反编码
            
            
            CLLocation *location=[[CLLocation alloc ]initWithLatitude:latitude longitude:longitude];
            CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error==nil) {
                    
                    CLPlacemark *place=[placemarks lastObject];
                    _nowLocation=place.locality;
                   
                    
                }
                else
                {
                    _nowLocation=@"定位失败";
                    
                }
            }];
            
            
            
        }
        
        
    }];
    

}


#pragma mark - CreateSubViews

- (void)_createBarButtonItem
{
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

//头视图轮播器
- (void)_createHeaderView
{
    
    _scrollPlayingView =[[ScrollPlayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    _scrollPlayingView.backgroundColor=[UIColor clearColor];
    
    [_collectionView addSubview:_scrollPlayingView];
}

//createpicker
- (void)_createImagePicker
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = sourceType;
}

- (void)_createCollectionView
{

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=10;
    layout.itemSize=CGSizeMake((kwidth-50)/4 ,(kwidth-50)/4);
//  考虑到下拉刷新数据的因素不能把头视图分离出collectionView
//    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 200, kWidth, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;


    //注册cell
    UINib *nib=[UINib nibWithNibName:@"ThumbnailCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
}


#pragma mark -  CollectiondDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayModel.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThumbnailCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor yellowColor];
    cell.model=_arrayModel[indexPath.row];
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size=CGSizeMake(kScreenWidth, 200);
    return size;
    
}

#pragma mark - 点击进入评论界面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    CommentViewController *vc = [[CommentViewController alloc]init];
    vc.model = _arrayModel[indexPath.row];

   [self.navigationController pushViewController:vc animated:YES];
    
}


@end
