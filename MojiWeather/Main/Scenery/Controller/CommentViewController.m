//
//  CommentViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/18.
//  Copyright © 2015年 zhoujie. All rights reserved.
//

#import "CommentViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "AVOSCloud.h"

#import "Common.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"

#import "SendCommentViewController.h"
#import "UserViewController.h"



@interface CommentViewController ()
{
    UITableView *_commentTableView;
    NSMutableArray *_arrayComment;
    
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_cityLabel;
    
    NSNumber *praiseNumber;//点赞数
    UIButton *buttonPraise;
    UILabel *commentNumber;
    UILabel *praiseLabel;
    
    NSDate *_localeDate;//时间
}
@end

@implementation CommentViewController

-(void)setModel:(ImageModel *)model
{
    
    _model=model;
    
    
    _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 170, 100, 30)];
    _cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 140, 100, 30)];
    
    //下载大图
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString: _model.imageUrl ] ];
    _nameLabel.text=_model.useName;
    _cityLabel.text=_model.nowLocation;

    
    
    [self loadCommentData];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self _createTableView];
    
    [self _createCommentBtn];
    
    [self _createHeader];
}

#pragma mark - CreateSubViews
- (void)_createCommentBtn
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(sendComment)];
    self.navigationItem.rightBarButtonItem = btn ;
//    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = back;
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_createTableView
{
    _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _commentTableView.delegate=self;
    _commentTableView.dataSource=self;
    _commentTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_commentTableView];

    UINib *nib = [UINib nibWithNibName:@"CommentTableViewCell" bundle:nil];
    [_commentTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    _commentTableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCommentData)];
    
    
}

- (void)_createHeader
{
    
    
    
    _commentTableView.tableHeaderView=_headerImageView;
    

    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.font=[UIFont systemFontOfSize:14];
    [_commentTableView addSubview:_nameLabel];
    
    
    _cityLabel.textColor=[UIColor blackColor];
    _cityLabel.font=[UIFont systemFontOfSize:14];
    [_commentTableView addSubview:_cityLabel];

}


#pragma mark - Action
- (void)sendComment
{
    AVUser *user=[AVUser currentUser];
    
    if (user==nil) {

        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
        return;
    }
    
    SendCommentViewController *sendVc = [[SendCommentViewController alloc]init];
    
    UINavigationController *navVc=[[UINavigationController alloc]initWithRootViewController:sendVc];
    
    
    __weak  CommentViewController *vcc=self;
    
    sendVc.block=^(NSString *string1,UIImage *image,NSString *geo)
    {
        
        
        [vcc commentAction:string1 andImage:image andGeo:geo];
        

    } ;
  
    [self presentViewController:navVc animated:YES completion:nil];
    

}

//上传 评论 和 图片
-(void)commentAction:(NSString *)string andImage:(UIImage *)image andGeo:(NSString *)geo
{
    
    
    
    //得到时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    _localeDate = [date  dateByAddingTimeInterval: interval];
    
    
    //分为 有图片传 没图片传
    if (image!=nil)
    {
       
        NSData *imageData = UIImagePNGRepresentation(image);
        AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];

        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            if (succeeded) {
 
                AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
                AVObject *comment = [query getObjectWithId:_model.commentId];
                
                AVUser *user=[AVUser currentUser];
                
                if(user == nil)
                {
                    //请登入;
                    UserViewController *vc=[[UserViewController alloc]init];
                    [self presentViewController:vc animated:YES completion:nil];
                    return;
                }
                
                //有user
                NSDictionary *dic = [[NSDictionary alloc]init];
                if (user[@"image"] == nil)
                {
        
                    //用户没上传头像 则默认
                    dic=@{ @"commentStr"  : string,
                           @"userName" : user.username,
                           @"userImageUrl" : @"http://ac-To7omRIV.clouddn.com/vSvplLLL3pKy0Jp1keomLNC.png",
                           @"date" : [NSString stringWithFormat:@"%@",_localeDate],
                           @"commentUrl": imageFile.url,
                           @"geo":geo
                           };
                    
                }
                else
                {
                    
                    
                    dic=@{  @"commentStr"  : string,
                            @"userName" :   user.username,
                            @"userImageUrl" : user[@"image"],
                            @"date" : [NSString stringWithFormat:@"%@",_localeDate],
                            @"commentUrl": imageFile.url,
                            @"geo":geo
                            
                            };
                    
                    
                }
                
                [comment addObject:dic forKey:@"com"];
                [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded)
                    {
                        [self loadCommentData];
                        [self showStatusTip:@"下载完毕" show:NO andInterger:100];
                    }
                }];
            }
            
        } progressBlock:^(NSInteger percentDone) {

            [self showStatusTip:@"正在下载..." show:YES andInterger:percentDone];
        }];
    }
    else
    {
        
        
        AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
        
        AVObject *post = [query getObjectWithId:_model.commentId];
        
        AVUser *user=[AVUser currentUser];

        
        if(user==nil)
        {
            //请登入;
            
            UserViewController *vc=[[UserViewController alloc]init];
            
            [self presentViewController:vc animated:YES completion:nil];

            return;
        }
        
        
        
        NSLog(@"%@",user.username);
        
        NSDictionary *dic;
        if (user[@"image"] == nil)
        {
            
            //用户没上传头像 则默认
            dic=@{ @"comment"  : string,
                   @"userName" :   user.username,
                   @"userImageUrl" : @"http://ac-To7omRIV.clouddn.com/vSvplLLL3pKy0Jp1keomLNC.png",
                   @"date" :  [NSString stringWithFormat:@"%@",_localeDate ],
                   @"commentUrl":@"",//暂时顶一下
                   @"geo":geo
                   };
            
        }
        else
        {
            
            
            dic=@{  @"comment"  : string,
                    @"userName" :   user.username,
                    @"userImageUrl" : user[@"image"],
                    @"date" :[NSString stringWithFormat:@"%@",_localeDate],
                    @"commentUrl":@"",//暂时顶一下]
                    @"geo":geo
                    };
            
            
        }
        
        
        [post addObject:dic forKey:@"com"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded)
            {
                NSLog(@"评论上传成功");
                [self loadCommentData];
            }
        }];
        
    }

}


//点赞
-(void)buttonAction:(UIButton *)button
{
    
    
    if (button.tag==1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该账号已点过👍了" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
        
    }
    
    AVUser *user=[AVUser currentUser];
    if (user!=nil) {
        
        [buttonPraise setBackgroundImage:[UIImage imageNamed:@"btn_starred@2x.png"] forState:UIControlStateNormal];
        
        button.tag=1;
        
        
        AVObject *post = [AVObject objectWithoutDataWithClassName:@"Comment" objectId:_model.commentId];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // 增加点赞的人数
            post.fetchWhenSave = YES;
            [post incrementKey:@"upvotes"];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"%@", post[@"upvotes"]) ;
                NSNumber *temp1=post[@"upvotes"];
                praiseLabel.text = [temp1 stringValue];

                
                
            }];
        }];
        
        //保存id号 标示点过赞了
        [post addObject:user.objectId forKey:@"prise"];
        [post saveInBackground];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
    
}


#pragma mark -LoadData
-(void)loadCommentData
{
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query getObjectInBackgroundWithId:_model.commentId block:^(AVObject *object, NSError *error) {

        NSArray *array=  object[@"com"];
        _arrayComment=[[NSMutableArray alloc]init];
        
        for (int i=0; i<array.count; i++)
        {
            
            NSDictionary *dic= array[i];
            CommentModel *commentModel=[[CommentModel alloc]init];
            
            commentModel.commentUrl=dic[@"commentUrl"];
            commentModel.geo=dic[@"geo"];
            commentModel.userName=dic[@"userName"];
            commentModel.comment=dic[@"comment"];    //此处计算frame高度
            commentModel.userImageUrl=dic[@"userImageUrl"];
            commentModel.date=dic[@"date"];
            

            
            [_arrayComment insertObject:commentModel atIndex:0];
            
        }
        
        //获取点赞数
        praiseNumber= object[@"upvotes"];
        [_commentTableView reloadData];
        
        

        [_commentTableView.header endRefreshing];
    }];
}



#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrayComment.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.commentModel=_arrayComment[indexPath.row];
    
    return cell;
}

//返回Row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model=_arrayComment[indexPath.row];
    return model.cellFrame.size.height;
    
    
}

//用来显示点赞
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 44)];
    view.backgroundColor=[UIColor grayColor];
    
    commentNumber=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 44)];
    commentNumber.text=[NSString stringWithFormat:@"评论数:%li", _arrayComment.count];
    [view addSubview:commentNumber];
    
    buttonPraise=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-65, 10, 30, 30)];
    [buttonPraise addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonPraise];
    
    
    
    AVObject *post = [AVObject objectWithoutDataWithClassName:@"Comment" objectId:_model.commentId];
    [post fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSArray *array=  post[@"praise"];
        
        AVUser *user=[AVUser currentUser];
        NSString *str=[NSString stringWithFormat:@"self='%@'",user.objectId];
        NSPredicate*  predicate=[NSPredicate predicateWithFormat:str];
        
        NSArray *filterArray=[array filteredArrayUsingPredicate:predicate];
        

        if (filterArray != nil)
        {
            
            [buttonPraise setBackgroundImage:[UIImage imageNamed:@"btn_starred@2x.png"] forState:UIControlStateNormal];
            buttonPraise.tag=1;
            
        }
        else
        {
            [buttonPraise setBackgroundImage:[UIImage imageNamed:@"btn_unstarred@2x.png"] forState:UIControlStateNormal];
            buttonPraise.tag=2;
            
        }
    }];
    
    
    
    
    
    praiseLabel=[[UILabel  alloc]initWithFrame:CGRectMake(kwidth-25, 0, 50, 44)];
    [view addSubview:praiseLabel];
    if (praiseNumber==nil) {
        praiseLabel.text=@"0";
    }
    else
    {
        praiseLabel.text =[praiseNumber  stringValue];
    }

    return view;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
