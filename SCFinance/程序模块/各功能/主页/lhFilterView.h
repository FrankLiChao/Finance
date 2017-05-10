//
//  lhFilterView.h
//  SCFinance
//
//  Created by bosheng on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol filterStrDictDelegate <NSObject>

- (void)setFilterStrDict:(NSDictionary *)dict;

@end

@interface lhFilterView : UIView

@property (nonatomic,strong)NSString * cityStr;//城市名称
@property (nonatomic,strong)UIButton * cityButton;//城市点击事件
@property (nonatomic,strong)NSArray * filterArray;//删选条件数据

@property (nonatomic,weak)id<filterStrDictDelegate> delegate;

/**
 *筛选出现
 */
- (void)appear;

/**
 *筛选消失
 */
- (void)disAppear;

@end
