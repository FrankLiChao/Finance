//
//  lhHubLoading.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, lhActivityType) {
//    lhActivityTypeMax = 1,       // 满屏背景加载
//    lhActivityTypeTop,           // 除去导航条背景加载
//    lhActivityTypeLow,           // 除去tabBar背景加载
//    lhActivityTypeMin            // 除去导航条和tabBar背景加载
//};

@interface lhHubLoading : NSObject

+ (void)addActivityView1OnlyActivityView:(UIView *)nView;
+ (void)addActivityView:(UIView *)nView;
//+ (void)addActivityView123:(UIView *)nView activityType:(lhActivityType)aType;

+ (void)disAppearActivitiView;

@end
