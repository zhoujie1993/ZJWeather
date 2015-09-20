//
//  ManageTableViewController.m
//  MojiWeather
//
//  Created by zhoujie on 15/8/27.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "ManageTableViewController.h"
#import "PresentViewController.h"
#import "DataService.h"


@interface ManageTableViewController ()
{
    NSMutableArray *_arrayM;
}
@end

@implementation ManageTableViewController


- (void)setCityNameArray:(NSMutableArray *)cityNameArray
{
    _cityNameArray=cityNameArray;
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = @[addItem,editItem];
    
    self.navigationController.delegate =self;
    
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    _arrayM = [[NSMutableArray alloc]init];
    [_arrayM addObject:backItem];
    self.navigationItem.leftBarButtonItems = _arrayM;
    
}

#pragma mark - 编辑操作
- (void)editAction
{
    UIBarButtonItem *cancleItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(canclelAction)];
    if (_arrayM.count == 1) {
        
        [_arrayM addObject:cancleItem];
    }    
    self.navigationItem.leftBarButtonItems = _arrayM;
    
    //支持多选
    //self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES];
}

- (void)canclelAction
{
    
    [self.tableView setEditing:NO];
    [_arrayM removeLastObject];
    self.navigationItem.leftBarButtonItems = _arrayM;
}


- (void)backAction
{
    _block1(_cityNameArray);
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -添加城市
- (void)addCity
{
    //城市选项页面 不够完整因为可选城市太多尝试用程序从网上下载 但是由于城市数量太多
    PresentViewController *vc2=[[PresentViewController alloc]init];
    
    vc2.cityNameArray = [[NSMutableArray alloc]init];
    for (int i=0; i<_cityNameArray.count; i++) {
        NSString *city=_cityNameArray[i];
        [vc2.cityNameArray addObject:city];
    }
    
    [self presentViewController:vc2 animated:NO completion:nil];
    
    vc2.block=^(NSString *str)
    {
        [_cityNameArray addObject:str];
        [self.tableView reloadData];
    };
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _cityNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text =_cityNameArray[indexPath.row];

 
    return cell;
}


#pragma mark - TableViewEdit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return  UITableViewCellEditingStyleDelete;
}

//支持编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//编辑动作提交的时候调用的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_cityNameArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
