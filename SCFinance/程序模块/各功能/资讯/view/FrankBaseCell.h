//
//  FrankBaseCell.h
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "FrankBaseModel.h"

@interface FrankBaseCell : UITableViewCell<SDCycleScrollViewDelegate>

/**
 *  图片
 */
@property (strong, nonatomic) UIImageView *imgIcon;

/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleMessage;

/**
 *  表示阅读人数
 */
@property (strong, nonatomic) UILabel *readMessage;

/**
 *  表示收藏人数
 */
@property (strong, nonatomic) UILabel *collectMessage;

/**
 *  表示新闻时间
 */
@property (strong, nonatomic) UILabel *dataMessage;

/**
 *  第一张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgPicOne;


/**
 *  第二张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgPicTwo;


/**
 *  第三张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgPicThree;

/**
 *  底部分界线
 */
@property (strong, nonatomic) UIView *lineView;

/**
 *  滚动图片区
 */
@property(nonatomic ,strong) SDCycleScrollView * cycleScrollView;

// 数据模型
@property(nonatomic ,strong) FrankBaseModel * baseModel;

+(NSString *)cellIdentifierForRow:(FrankBaseModel *)baseModel;

@end
