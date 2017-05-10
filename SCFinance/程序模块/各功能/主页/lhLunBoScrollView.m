//
//  lhLunBoScrollView.m
//  SCFinance
//
//  Created by bosheng on 16/5/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhLunBoScrollView.h"
#import "lhUserProtocolViewController.h"

static const CGFloat lunBoAutoTime = 5.0f;

@interface lhLunBoScrollView()
{
    CGFloat countM;
    UIViewController * tempVC;
}

@end

@implementation lhLunBoScrollView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imgArray controller:(UIViewController *)VC
{
    self = [super initWithFrame:frame];
    
    if (self) {
        countM = 0.0f;
        
        _lunBoView = [[UIScrollView alloc]initWithFrame:frame];
        _lunBoView.scrollEnabled = NO;
        _lunBoView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
        _lunBoView.pagingEnabled = YES;
        _lunBoView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_lunBoView];
        
        _lunboPC = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 190*widthRate, DeviceMaxWidth, 20*widthRate)];
        _lunboPC.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
        _lunboPC.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_lunboPC];
        
        UISwipeGestureRecognizer * swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
        UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
        swip.direction = UISwipeGestureRecognizerDirectionLeft;
        UIButton * topUrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topUrlButton.frame = _lunBoView.frame;
        [topUrlButton addTarget:self action:@selector(topUrlButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [topUrlButton addGestureRecognizer:swipLeft];
        [topUrlButton addGestureRecognizer:swip];
        [self addSubview:topUrlButton];
        
        self.imageArray = imgArray;
        tempVC = VC;
        
    }
    
    return self;
}

//初始化轮播
- (void)initLunBoView
{
    NSMutableArray * viewArray = [NSMutableArray array];
    
    if (_lunBoView) {
        for (UIView * view in _lunBoView.subviews) {
            [viewArray addObject:view];
        }
    }
    
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView * foodimg = [[UIImageView alloc]initWithFrame:CGRectMake(i*DeviceMaxWidth, 0, DeviceMaxWidth, _lunBoView.frame.size.height)];
        foodimg.userInteractionEnabled = YES;
        foodimg.tag = i;
        
        if ([[_imageArray objectAtIndex:i]class] == [UIImage class]) {
            foodimg.image = [_imageArray objectAtIndex:i];
        }
        else{
            NSString * hStr = [[_imageArray objectAtIndex:i] objectForKey:@"image"];
            NSString * str = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,hStr];
            [lhUtilObject checkImageWithImageView:foodimg withImage:hStr withImageUrl:str withPlaceHolderImage:imageWithName(placeHolderImg)];
        }
        [_lunBoView addSubview:foodimg];
    }
    

    _lunBoView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
    _lunBoView.contentSize = CGSizeMake(DeviceMaxWidth*_imageArray.count, 210*widthRate);
    _lunboPC.numberOfPages = _imageArray.count-2;
    
    
    [self performSelector:@selector(removeOtherView:) withObject:viewArray afterDelay:1.0];
    
}

- (void)removeOtherView:(NSMutableArray *)viewArray
{
    if (viewArray) {
        for (UIView * view in viewArray){
            [view removeFromSuperview];
            
        }
    }
    
    [viewArray removeAllObjects];
    viewArray = nil;
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - setter
- (void)setImageArray:(NSArray *)imageArray
{
    if (!imageArray || !imageArray.count) {
        return;
    }
    
    id dic = [imageArray objectAtIndex:0];
    
    if ([dic class] != [UIImage class]) {
        [[NSUserDefaults standardUserDefaults]setObject:imageArray forKey:mainViewlunboPicFile];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    NSMutableArray * tempA = [NSMutableArray arrayWithArray:imageArray];
    [tempA insertObject:[tempA objectAtIndex:tempA.count-1] atIndex:0];
    [tempA insertObject:[tempA objectAtIndex:1] atIndex:tempA.count];
    
    _imageArray = [NSMutableArray arrayWithArray:tempA];
    
    [self initLunBoView];
    
}

#pragma mark - 左右滑动手势
- (void)swip:(UISwipeGestureRecognizer *)gesture_
{
    if (gesture_.direction == UISwipeGestureRecognizerDirectionRight) {
        [self scrollViewDidScrollToLeft:_lunBoView];
        countM = 0.0f;//时间置为0
    }
    else if(gesture_.direction == UISwipeGestureRecognizerDirectionLeft){
        [self scrollViewDidScrollToRight:_lunBoView];
        countM = 0.0f;//时间置为0
    }
    
}

#pragma mark - 点击事件
//跳转链接
- (void)topUrlButtonEvent
{
    if (!_imageArray || !_imageArray.count) {
        return;
    }
    
    NSInteger index = (NSInteger)(_lunBoView.contentOffset.x/DeviceMaxWidth);
    id oneDic = [_imageArray objectAtIndex:index];
    
    if (!oneDic || [oneDic class] != [NSDictionary class]) {
        return;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",[oneDic objectForKey:@"link"]];
    if (urlStr && ![@"" isEqualToString:urlStr] && ![urlStr rangeOfString:@"link"].length) {
        lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
        upVC.titleStr = @"详情";
        upVC.urlStr = urlStr;
        [tempVC.navigationController pushViewController:upVC animated:YES];
    }

}

#pragma mark - 轮播相关
//My UIScrollViewDelegate
- (void)scrollViewDidScrollToRight:(UIScrollView *)scrollView
{
    if (scrollView == _lunBoView) {
        UIScrollView * tempS = (UIScrollView *)scrollView;
        
        [UIView animateWithDuration:0.5 animations:^{
            tempS.contentOffset = CGPointMake(tempS.contentOffset.x+DeviceMaxWidth, 0);
            
        }completion:^(BOOL finished) {
            
            if (tempS.contentOffset.x > (_imageArray.count-2)*DeviceMaxWidth) {
                tempS.contentOffset = CGPointMake(DeviceMaxWidth, 0);
                
            }
            _lunboPC.currentPage = _lunBoView.contentOffset.x/DeviceMaxWidth-1;
        }];
    }
    
}

- (void)scrollViewDidScrollToLeft:(UIScrollView *)scrollView
{
    UIScrollView * tempS = scrollView;
    
    [UIView animateWithDuration:0.5 animations:^{
        tempS.contentOffset = CGPointMake(tempS.contentOffset.x-DeviceMaxWidth, 0);
        
    }completion:^(BOOL finished){
        if (tempS.contentOffset.x < DeviceMaxWidth) {
            tempS.contentOffset = CGPointMake(DeviceMaxWidth*(_imageArray.count-2), 0);
        }
        _lunboPC.currentPage = _lunBoView.contentOffset.x/DeviceMaxWidth-1;
    }];
    
}

#pragma mark - 轮播图片自动移动
- (void)lunboAutoMoveEvent
{
    [UIView animateWithDuration:0.5 animations:^{
        _lunBoView.contentOffset = CGPointMake(_lunBoView.contentOffset.x+DeviceMaxWidth, 0);
    }completion:^(BOOL finished) {
        if (_lunBoView.contentOffset.x > (_imageArray.count-2)*DeviceMaxWidth) {
            _lunBoView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
        }
        _lunboPC.currentPage = _lunBoView.contentOffset.x/DeviceMaxWidth-1;
    }];
}

- (void)moveCount
{
    countM++;
    if (countM == lunBoAutoTime) {
        countM = 0.0f;
        [self lunboAutoMoveEvent];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
