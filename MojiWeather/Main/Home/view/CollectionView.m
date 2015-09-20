//
//  CollectionView.m
//  MojiWeather
//
//  Created by Mac on 15/8/13.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "CollectionView.h"
#import "CollectionViewCell.h"
#import "Header.h"
#import "DataService.h"
#import "Common.h"


@implementation CollectionView
{
    NSMutableArray *arrayModal;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    
    
    self=[super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    
        
        
        UINib *nib=[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellWithReuseIdentifier:@"cell"];
        
        self.delegate=self;
        self.dataSource=self;
        
        self.pagingEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        

    }
    return self;
}



-(void)setModalArray:(NSArray *)modalArray
{
    _modalArray=modalArray;
    
    [self reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _modalArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{

    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.modal=_modalArray[indexPath.row];

    

    
    return cell;
}





@end
