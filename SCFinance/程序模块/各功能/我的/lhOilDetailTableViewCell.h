//
//  lhOilDetailTableViewCell.h
//  SCFinance
//
//  Created by bosheng on 16/6/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhOilDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView * oilView;//显示提油信息

@property (nonatomic,strong)UIImageView * hImgView;//油库图标
@property (nonatomic,strong)UILabel * nameLabel;//油库名称

@property (nonatomic,strong)UIButton * tyBtn;//提油按钮

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary *)dic;

@end
