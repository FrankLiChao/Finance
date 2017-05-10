//
//  lhShopCarTableViewCell.h
//  SCFinance
//
//  Created by bosheng on 16/5/31.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhShopCarTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton * selectBtn;//选择按钮
@property (nonatomic,strong)UILabel * nameLabel;//油号
@property (nonatomic,strong)UILabel * priceLabel;//价钱
@property (nonatomic,strong)UILabel * oldPriceLabel;//原价
@property (nonatomic,strong)UIView * oldLineView;//划掉原价的线
@property (nonatomic,strong)UILabel * totalLabel;//小计
@property (nonatomic,strong)UILabel * jsLabel;//已节省
@property (nonatomic,strong)UIButton * subBtn;//减
@property (nonatomic,strong)UITextField * inputField;//输入框
@property (nonatomic,strong)UIButton * addBtn;//加

@end
