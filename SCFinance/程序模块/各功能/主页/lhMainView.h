//
//  lhMainView.h
//  SCFinance
//
//  Created by bosheng on 16/5/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lhLunBoScrollView.h"

@interface lhMainView : UIView

@property (nonatomic,strong)UIScrollView * maxScrollView;//

@property (nonatomic,strong)lhLunBoScrollView * topScrollView;//轮播

@property (nonatomic,strong)UITableView * shopTableView;//团购直购列表

//@property (nonatomic,assign)CGFloat heih;

/**
 *初始化主界面
 *frame：frame
 *imgArray:轮播图片数组
 *VC:当前viewController
 */
- (instancetype)initWithFrame:(CGRect)frame imgageArray:(NSArray *)imgArray controller:(UIViewController *)VC;

/**
 *轮播自动跳转计时
 */
- (void)moveCount;

@end
