//
//  lhFirmOrderViewController.h
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhFirmOrderViewController : UIViewController

@property (nonatomic,assign)NSInteger type;//type=5直接购买，else购物车结算

@property (nonatomic,strong)NSDictionary * firmDic;//订单数据
@property (nonatomic,assign)CGFloat totalPrice;//总价格

@end
