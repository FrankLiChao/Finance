//
//  lhShopCarView.h
//  SCFinance
//
//  Created by bosheng on 16/6/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lhCursorLabel.h"

@interface lhShopCarView : UIView

@property (nonatomic,strong)UITableView * shopCarTableView;

@property (nonatomic,strong)UIView * lowView;//底部View
@property (nonatomic,strong)UIButton * selectBtn;//选择
@property (nonatomic,strong)UILabel * totalLabel;//合计金额
@property (nonatomic,strong)UIButton * settleBtn;//结算

@property (nonatomic,strong)UIControl * maxControl;//点击结束输入

//购物车显示
@property (nonatomic,strong)lhCursorLabel * showLabel;//显示当前数量
@property (nonatomic,strong)UIButton * cancelBtn;//取消按钮
@property (nonatomic,strong)UIButton * finishBtn;//输入完成按钮

/**
 *单例
 */
+ (instancetype)shareShopCarView;

/**
 *得到一个键盘显示控件
 */
- (UIView *)anInputAccessoryView;


@end
