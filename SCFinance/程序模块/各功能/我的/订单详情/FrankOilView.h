//
//  FrankOilView.h
//  SCFinance
//
//  Created by lichao on 16/7/7.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrankDirectOrderView.h"
#import "FrankGroupOrderView.h"

@interface FrankOilView : UIView


@property (nonatomic,strong)UILabel *carType;       //表示车牌前缀
@property (nonatomic,strong)UITextField *dataField; //表示日期
@property (nonatomic,assign)NSInteger type;         //1表示直购；2表示团购
@property (nonatomic,strong)NSString *orderId;      //订单ID
@property (nonatomic,strong)NSDictionary *oilDetailDic; //油号信息

@property (nonatomic,weak)FrankDirectOrderView *directDelegate; //直购代理
@property (nonatomic,weak)FrankGroupOrderView *groupDelegate;   //团购代理

@end
