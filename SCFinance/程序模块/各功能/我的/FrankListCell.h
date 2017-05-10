//
//  FrankListCell.h
//  SCFinance
//
//  Created by lichao on 16/7/13.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankListCell : UITableViewCell

@property (nonatomic,strong)UILabel *orderName;//订单号
@property (nonatomic,strong)UILabel *dataName;  //日期

@property (nonatomic,strong)UILabel *oilNumber; //油号
@property (nonatomic,strong)UILabel *oilAddress;//油库名字
@property (nonatomic,strong)UILabel *oilStock;//吨数
@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UILabel *totalMoney;    //总价

@end
