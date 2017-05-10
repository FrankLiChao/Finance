//
//  lhMainBuyModel.h
//  SCFinance
//
//  Created by bosheng on 16/6/7.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhMainBuyModel : NSObject

@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * companyId;
@property (nonatomic,strong)NSString * depotLogo;//油库logo
@property (nonatomic,strong)NSString * depotName;//油库名
@property (nonatomic,strong)NSString * oilCategory;
@property (nonatomic,strong)NSString * phone;//对应销售经理电话号码
@property (nonatomic,strong)NSString * price;//原价
@property (nonatomic,strong)NSString * oilName;//油号名称
@property (nonatomic,strong)NSString * name;//油号名称
@property (nonatomic,strong)NSString * realName;
@property (nonatomic,strong)NSString * exclusivePrice;//现在价格

@end
