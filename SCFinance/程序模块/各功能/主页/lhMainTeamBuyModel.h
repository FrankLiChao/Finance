//
//  lhMainTeamBuyModel.h
//  SCFinance
//
//  Created by bosheng on 16/6/7.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhMainTeamBuyModel : NSObject

@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * companyLogo;//公司logo
@property (nonatomic,strong)NSString * companyName;//公司名称
@property (nonatomic,strong)NSString * oilCategory;//油号
@property (nonatomic,strong)NSString * nextDiff;//到下一级差的吨数
@property (nonatomic,strong)NSString * nextMax;//当前阶段最大值
@property (nonatomic,strong)NSString * price;//原价
@property (nonatomic,strong)NSString * currentPurchase;//已购吨数
@property (nonatomic,strong)NSString * name;//
@property (nonatomic,strong)NSString * oilName;//油号名字
@property (nonatomic,strong)NSString * signNumber;//已购人数
@property (nonatomic,strong)NSString * nextPromotion;//下一阶段价格
@property (nonatomic,strong)NSString * deadline;//截止时间
@property (nonatomic,strong)NSString * currentPromotion;//当前参考价

@end
