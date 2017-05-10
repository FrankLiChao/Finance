//
//  lhShopCarViewModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/31.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class lhShopCarTableViewCell;

@interface lhShopCarViewModel : NSObject


/**
 *获取购物车数据
 *success:获取数据成功Block，返回
 */
+ (void)getShopCarDataSuccess:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *删除一条数据
 *success:获取数据成功Block，返回
 */
+ (void)deleteOne:(NSDictionary *)oneDic success:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *购物车结算
 *buyArray:购买数据
 */
+ (void)settle:(NSArray *)buyArray success:(void (^)(id response))success;

/**
 *设置总计金额label样式
 *text:label内容
 */
+ (NSAttributedString *)setLabelStyle:(NSString *)text;


/**
 *更新购物车cell中原价label位置
 *sCell:当前购物车cell对象
 */
+ (void)updateCell:(lhShopCarTableViewCell *)sCell;

@end
