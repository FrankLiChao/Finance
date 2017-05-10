//
//  lhTabBar.h
//  SCFinance
//
//  Created by bosheng on 16/5/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhTabBar : UITabBarController

//@property (nonatomic,strong)UITabBarController * tabBC;//tabbarController
@property (nonatomic,strong)UIButton * shopCarTabBtn;//购物车按钮

@property (nonatomic,strong)UILabel * shopCarBadge;//购物车图标badge

/**
 *tabBar单例
 */
+ (instancetype)shareTabBar;

/**
 *初始化tabBar
 *viewControllers:tabBar的每个VC
 */
- (instancetype)initWithTabViewControlers:(NSArray *)viewControlers;

/**
 *设置shopCarBadge数字,并且调整shopCarBadge长度
 *badgeStr:nsstring类型的数字
 */
- (void)sizeToFitWithText:(NSString *)badgeStr;

@end
