//
//  lhNavigationBar.h
//  LHTestProduct
//
//  Created by bosheng on 16/1/14.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//导航栏右边按钮协议
@protocol rightBtnDelegate <NSObject>

@optional
- (void)rightBtnEvent;//导航栏右按钮事件
- (void)backBtnEvent; //导航栏返回按钮事件

@end

@interface lhNavigationBar : UIView
{
    UIViewController * tempVC;
}

@property (nonatomic,weak)id<rightBtnDelegate> delegate;

/**
 *初始化一个导航栏
 *tempVC:当前VC
 *titleStr:标题
 *yesOrNo:是否添加返回按钮
 *tStr:右边按钮，tStr=nil表示不添加，添加右按钮需遵守rightBtnDelegate协议，并实现rightBtnEvent方法
 */
- (instancetype)initWithVC:(UIViewController *)tempVC title:(NSString *)titleStr isBackBtn:(BOOL)yesOrNo rightBtn:(NSString *)tStr;


/**
 *修改导航栏标题
 *titleStr:修改之后的标题
 */
- (void)mergeTitle:(NSString *)titleStr;

/**
 *修改右边的按钮标题
 *titleStr:修改之后的标题
 */
- (void)mergeRightButton:(NSString *)titleStr;

@end
