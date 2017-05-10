//
//  lhTeamBuyViewController.h
//  SCFinance
//
//  Created by bosheng on 16/5/31.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//团购和直购
@interface lhTeamBuyViewController : UIViewController

@property (nonatomic,strong)NSDictionary * filterCityDic;

@property (nonatomic,assign)NSInteger type;//type=5表示团购，type=6表示直购


@end
