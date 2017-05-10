//
//  lhPersonalViewModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhPersonalViewModel : NSObject

/**
 *请求余油详情信息
 */
+ (void)requestOilDetailSuccess:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *请求消息列表
 *pno:当前页数
 */
+ (void)requestMessageInfoPno:(NSInteger)pno success:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *个人中心功能数组
 */
+ (NSArray *)funArray;

/**
 *余油柱形颜色
 */
+ (NSArray *)colorArray;

@end
