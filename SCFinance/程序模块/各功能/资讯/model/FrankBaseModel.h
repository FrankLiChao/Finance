//
//  FrankBaseModel.h
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrankBaseModel : NSObject

/**
 *  新闻标题
 */
@property (nonatomic,copy) NSString *adsTitle;

/**
 *  阅读人数
 */
@property (nonatomic,copy)NSNumber *readCount;

/**
 *  收藏人数
 */
@property (nonatomic,copy)NSNumber *collectCount;

/**
 *  新闻发布时间
 */
@property (nonatomic,copy) NSString *adsTime;

/**
 *  新闻ID
 */
@property (nonatomic,copy) NSString *adsId;

/**
 *  图片连接
 */
@property (nonatomic,copy) NSString *imgsrc;

/**
 *  描述
 */
@property (nonatomic,copy) NSString *digest;

/**
 *  大图样式
 */
@property (nonatomic,copy)NSNumber *imgType;

/**
 *  表示有大图
 */
@property (nonatomic,copy)NSNumber *hasHeadImg;

/**
 *  多图数组
 *  里面放的是轮播图模型
 */
@property (nonatomic,strong)NSArray *imgeBannerArray;

/**
 * 轮播数据
 */
@property (nonatomic,strong)NSArray *lunboArray;

/**
 *  缓存控制器
 */
@property (nonatomic,strong)UIViewController *tempVc;

/**
 *  里面放的是Ads模型
 */
@property (nonatomic,strong)NSArray *ads;

@end
