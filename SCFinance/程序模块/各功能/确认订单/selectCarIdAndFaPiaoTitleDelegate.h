//
//  selectCarIdAndFaPiaoTitleDelegate.h
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//选择车牌和发票抬头
@protocol selectCarIdAndFaPiaoTitleDelegate <NSObject>

/**
 *设置车牌和发票抬头
 *carIdDic：当前车牌或发票抬头数据
 *type：类型，=5表示车牌，=6表示发票抬头
 */
- (void)setCarIdDic:(NSDictionary *)carIdDic withType:(NSInteger)type;

@end
