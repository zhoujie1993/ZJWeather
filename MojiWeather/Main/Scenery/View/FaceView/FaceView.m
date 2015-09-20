//
//  FaceView.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/16.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "FaceView.h"
#import "Common.h"
#import "UIViewExt.h"


#define item_width  (kScreenWidth/7.0)  //单个表情占用的区域宽度
#define item_height 45   //单个表情占用的区域高度

#define face_height 30   //表情图片的宽度
#define face_width 30   //表情图片的高度

@implementation FaceView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initData];
    }
    return self;
}

- (NSInteger)pageNumber {
    return _items.count;
}


- (void)_initData{
 
    
    _items = [[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    //一页的表情数
    NSInteger pageCount = 28;
    //页数
    NSInteger page = emoticons.count/28;
    for (int i=0; i<=page; i++) {
        NSInteger sub = emoticons.count - i * 28;
        if (sub < pageCount) {
            pageCount = sub;
        }
        NSRange range = NSMakeRange(pageCount*i, pageCount);
        
        NSArray *item2D = [emoticons subarrayWithRange:range];
        [_items addObject:item2D];
    }
    
    
    
    //计算当前视图的宽度、高度
    CGRect frame = self.frame;
    frame.size.width = _items.count * kScreenWidth;
    frame.size.height = item_height*4;
    self.frame = frame;
    
    //创建放大镜视图
    _magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    _magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    _magnifierView.backgroundColor = [UIColor clearColor];
    _magnifierView.hidden = YES;
    [self addSubview:_magnifierView];
    
    
    //放大镜中的表情
    UIImageView *faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((_magnifierView.width-face_width)/2, 15, face_width, face_height)];
    faceImgView.backgroundColor = [UIColor clearColor];
    faceImgView.tag = 100;
    [_magnifierView addSubview:faceImgView];
    

}



//绘制表情
- (void)drawRect:(CGRect)rect
{
    
    //定义列数、行数
    /**
     *  row : 0-3     4行
     *  colum : 0-6   7列
     */
    int row = 0,colum = 0;
    
    for (int i=0; i<_items.count; i++) {
        
        NSArray *item2D = _items[i];
        
        for (int j=0; j<item2D.count; j++) {
            
            //表情
            NSDictionary *item = item2D[j];
            //1.取得表情名
            NSString *imgName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imgName];
            
            /**
             2.计算表情的坐标
             通过colum计算出x坐标：colum ---> x
             通过row计算出Y坐标：row --> y
             */
            CGFloat x = colum * item_width + (item_width-face_width)/2 + i*kScreenWidth;
            CGFloat y = row * item_height + (item_height-face_height)/2;
            
            
            

            CGRect imgFrame = CGRectMake(x, y, face_width, face_height);
            
            //3.绘制表情
            [image drawInRect:imgFrame];
            
            
            //4.更新列与行
            colum++;  //更新列
            if (colum % 7 == 0) {
                colum = 0;
                row++;  //更新行
            }
            if (row == 4) {
                row = 0;
            }
        }
        
    }
    
}

//计算触摸点(x,y) ----> (列、行)

//CGFloat x = colum * item_width + (item_width-face_width)/2 + i*kScreenWidth;
//CGFloat y = row * item_height + (item_height-face_height)/2;

- (void)touchFace:(CGPoint)point {
    
    //1.计算页数
    NSInteger page = point.x / kScreenWidth;
    if (page >= _items.count) {
        return;
    }
    
    //2.计算row、colum
    NSInteger colum = (point.x - ((item_width-face_width)/2 + page*kScreenWidth))/item_width;
    NSInteger row = (point.y -  (item_height-face_height)/2)/item_height;
    
    //3.范围处理
    /**
     row:0-3
     colum : 0-6
     */
    if (colum > 6) colum = 6;
    if (colum < 0) colum = 0;
    if (row < 0) row = 0;
    if (row > 3) row = 3;
    
    //4.通过row,列colum， 计算出表情在此页中的索引index
    // row=1,colum=2  ---> row*7+2
    NSInteger index = row * 7 + colum;
    NSArray *item2D = [_items objectAtIndex:page];
    
    if (index >= item2D.count) {
        return;
    }
    
    //5.取得表情
    NSDictionary *item = [item2D objectAtIndex:index];
    //表情的图片名
    NSString *imgName = [item objectForKey:@"png"];
    NSString *faceName = [item objectForKey:@"chs"];
    
    //6.放大镜中显示选中的表情
    //计算表情的中心点的坐标
    if (![_selectedFaceName isEqualToString:faceName]) {
        //        NSLog(@"%@,%@",imgName,faceName);
        
        CGFloat x = colum*item_width + item_width/2 + page*kScreenWidth;
        CGFloat y = row*item_height + item_height/2;
        
        _magnifierView.center = CGPointMake(x, 0);
        _magnifierView.bottom = y;
        
        UIImageView *faceImgView = (UIImageView *)[_magnifierView viewWithTag:100];
        faceImgView.image = [UIImage imageNamed:imgName];
        
        _selectedFaceName = faceName;
    }
    
}


#pragma mark - UITouch method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //1.显示放大镜
    _magnifierView.hidden = NO;
    
    //2.禁止滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        //禁止滑动
        scrollView.scrollEnabled = NO;
    }
    
    //3
    UITouch *touch = [touches anyObject];
    //触摸点
    CGPoint point = [touch locationInView:self];
    
    //计算触摸点(x,y) ----> (列、行)
    [self touchFace:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    //触摸点
    CGPoint point = [touch locationInView:self];
    
    //计算触摸点(x,y) ----> (列、行)
    [self touchFace:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //1.隐藏放大镜
    _magnifierView.hidden = YES;
    
    //2.开启滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        //开启滑动
        scrollView.scrollEnabled = YES;
    }
    
    //3 通知代理
    if ([self.delegate respondsToSelector:@selector(faceDidSelect:)]) {
        [self.delegate faceDidSelect:_selectedFaceName];
    }

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}








@end
