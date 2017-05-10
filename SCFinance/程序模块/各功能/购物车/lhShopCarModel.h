//
//  lhShopCarModel.h
//  SCFinance
//
//  Created by bosheng on 16/6/15.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhShopCarModel : NSObject

@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * amount;//小计价格
@property (nonatomic,strong)NSString * oilName;//名字
@property (nonatomic,strong)NSString * name;//油库名
@property (nonatomic,strong)NSString * oilCategory;//
@property (nonatomic,strong)NSString * price;//当前价格
@property (nonatomic,strong)NSString * policyPrice;//原价
@property (nonatomic,strong)NSString * purchaseNumber;//购买数量
@property (nonatomic,strong)NSString * serviceMoney;//服务费

@property (nonatomic,strong)NSString * isSelected;//是否选择


@end
