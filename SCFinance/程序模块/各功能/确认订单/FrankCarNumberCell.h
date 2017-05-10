//
//  FrankCarNumberCell.h
//  GasStation
//
//  Created by lichao on 15/9/17.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankCarNumberCell : UITableViewCell

@property (nonatomic,strong) UIImageView *carImage;     //车牌列表图标
//@property(nonatomic,strong)UIImageView  *hdImage;       //列表选中标识
@property(nonatomic,strong)UILabel      *carNumber;     //车牌号（发票抬头）

@end
