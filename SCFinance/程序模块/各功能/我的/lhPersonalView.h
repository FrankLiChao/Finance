//
//  lhPersonalView.h
//  SCFinance
//
//  Created by bosheng on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhPersonalView : UIView

@property (nonatomic,strong)UIScrollView * maxScrollView;//滑动控件

@property (nonatomic,strong)UIView * topView;//我的油

@property (nonatomic,strong)UIButton * buyBtn;//直购订单按钮
@property (nonatomic,strong)UIButton * teamBuyBtn;//团购订单按钮

@property (nonatomic,strong)UITableView * funTableView;//个人中心功能


/**
 *显示我买的油
 *oilArray:买的油数组
 */
- (void)setMyOilView:(NSArray *)oilArray;

@end
