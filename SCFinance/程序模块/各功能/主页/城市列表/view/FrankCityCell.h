//
//  FrankCityCell.h
//  SCFinance
//
//  Created by lichao on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrankChooseCityView;

@interface FrankCityCell : UITableViewCell


@property (nonatomic,strong)UIButton *cityNameBtn;
@property (nonatomic,strong)NSArray *cityName;

@property (nonatomic,weak)FrankChooseCityView * delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary *)cityDic;



@end
