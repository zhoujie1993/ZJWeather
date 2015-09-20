//
//  UserTableViewCell.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UIViewExt.h"

@implementation UserTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {

        _labelText=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200, 44)];
        [self.contentView addSubview:_labelText];
 
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    
    [[UIImage imageNamed:@"account_bg@2x.png"] drawInRect:rect];
    
}


@end
