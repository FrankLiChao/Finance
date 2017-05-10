//
//  FrankChooseCityView.h
//  SCFinance
//
//  Created by lichao on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class lhTeamBuyViewController;

@interface FrankChooseCityView : UIViewController

@property (nonatomic,assign)NSInteger type;//type=5表示筛选选择城市

@property (nonatomic,assign)BOOL noBack;//是否添加返回按钮
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,weak)lhTeamBuyViewController * delegate;

- (void)clickCityButtonEvent:(NSString *)cityStr;

@end
