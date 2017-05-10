//
//  lhMainView.m
//  SCFinance
//
//  Created by bosheng on 16/5/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMainView.h"

@interface lhMainView()
{
    UIViewController * tempVC;
}

@end

@implementation lhMainView

- (instancetype)initWithFrame:(CGRect)frame imgageArray:(NSArray *)imgArray controller:(UIViewController *)VC
{
    self = [super initWithFrame:frame];
    
    if (self) {
        tempVC = VC;

        _maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-49)];
        _maxScrollView.backgroundColor = [UIColor clearColor];
        _maxScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_maxScrollView];
        
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, -DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_maxScrollView addSubview:whiteView];
        
        [self firmInit:imgArray];
    }
    
    return self;
}

- (void)firmInit:(NSArray *)imgArray
{
    _topScrollView = [[lhLunBoScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 210*widthRate) imageArray:imgArray controller:tempVC];
    [_maxScrollView addSubview:_topScrollView];
    
    _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 210*widthRate, DeviceMaxWidth, DeviceMaxHeight-49-210*widthRate) style:UITableViewStylePlain];
    _shopTableView.scrollEnabled = NO;
    _shopTableView.separatorColor = [UIColor clearColor];
    _shopTableView.backgroundColor = [UIColor clearColor];
    [_maxScrollView addSubview:_shopTableView];
}

- (void)moveCount
{
    [_topScrollView moveCount];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
