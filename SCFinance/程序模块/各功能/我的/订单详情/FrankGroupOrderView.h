//
//  FrankGroupOrderView.h
//  SCFinance
//
//  Created by lichao on 16/6/12.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankGroupOrderView : UIViewController

@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *tgId;
@property (nonatomic,assign)NSInteger type; //0表示未完成订单 1表示已完成订单

-(void)reloadPage;
@end
