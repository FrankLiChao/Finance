//
//  lhFirmOrderViewModel.h
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class lhFirmOrderTableViewCell;

@interface lhFirmOrderViewModel : NSObject


/**
 *获取发票抬头
 *
 *success:获取数据成功Block，返回
 */
+ (void)getFaPiaoDataSuccess:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *获取配送车辆
 *
 *success:获取数据成功Block，返回
 */
+ (void)getCarIdDataSuccess:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *确认订单
 *buyArray:购买信息
 *carDic:车队信息
 *invoiceDic:发票抬头
 *success:获取数据成功Block，返回
 */
+ (void)firmOrderArray:(NSArray *)buyArray invoiceData:(NSDictionary *)invoiceDic success:(void (^)(id response))success;

/**
 *更新table的高度
 *tableView:表格
 *fArray:当前数据
 */
+ (void)updateTableSize:(UITableView *)tableView fArray:(NSArray *)fArray;

/**
 *更新确认订单中cell中原价label位置及线的位置
 *fCell:当前确定订单cell对象
 */
+ (void)updateCell:(lhFirmOrderTableViewCell *)fCell;

/**
 *设置总计金额label样式
 *text:label内容
 */
+ (NSAttributedString *)setLabelStyle:(NSString *)text;

/**
 *设置每个油库合计金额label样式
 *text:label内容
 */
//+ (NSAttributedString *)setEveryLabelStyle:(NSString *)text;

@end
