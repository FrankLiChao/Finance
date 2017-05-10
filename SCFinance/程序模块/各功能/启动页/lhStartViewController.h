//
//  lhStartViewController.h
//  SCFinance
//
//  Created by bosheng on 16/6/16.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class lhFirstMainView;

@interface lhStartViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;

//单例
+ (instancetype)shareStartVC;

//启动app请求的接口数据
- (void)startRequstData;

/**
 *启动主页
 *kcView:开场图片页面，以便跳过时看起来更和谐，为空时则不添加
 */
+ (void)gotoMainView:(lhFirstMainView *)kcView;

@end
