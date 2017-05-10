//
//  FrankOrderCell.h
//  SCFinance
//
//  Created by lichao on 16/6/12.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankOrderCell : UITableViewCell

@property (nonatomic,strong)UILabel *oilNumber; //油号
@property (nonatomic,strong)UILabel *oilAddress;//油库名字
@property (nonatomic,strong)UILabel *oilStock;//吨数
@property (nonatomic,strong)UIView *lineView;

@end
