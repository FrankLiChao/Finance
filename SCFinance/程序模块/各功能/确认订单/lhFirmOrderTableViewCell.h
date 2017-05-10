//
//  lhFirmOrderTableViewCell.h
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhFirmOrderTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * nameLabel;//油号
@property (nonatomic,strong)UILabel * priceLabel;//价钱
@property (nonatomic,strong)UILabel * oldPriceLabel;//原价
@property (nonatomic,strong)UIView * oldLineView;//划掉原价的线
@property (nonatomic,strong)UILabel * totalLabel;//小计
@property (nonatomic,strong)UILabel * jsLabel;//已节省
@property (nonatomic,strong)UILabel * numLabel;//购买吨数

@end
