//
//  lhLunBoScrollView.h
//  SCFinance
//
//  Created by bosheng on 16/5/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhLunBoScrollView : UIView

@property (nonatomic,strong)NSArray * imageArray;//轮播图片数组
@property (nonatomic,strong)UIScrollView * lunBoView;//轮播
@property (nonatomic,strong)UIPageControl * lunboPC;//轮播PageControl

/**
 *初始化轮播
 *frame:frame
 *imgArray:轮播图片
 *VC:当前viewController
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imgArray controller:(UIViewController *)VC;

/**
 *轮播自动跳转计时
 */
- (void)moveCount;

@end
