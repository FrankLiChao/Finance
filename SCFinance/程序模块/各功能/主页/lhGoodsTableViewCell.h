//
//  lhGoodsTableViewCell.h
//  SCFinance
//
//  Created by bosheng on 16/5/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhGoodsTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * hImgView;//油站图标
@property (nonatomic,strong)UILabel * nameLabel;//油站名字
@property (nonatomic,strong)UIImageView * validateImgView;//实地认证
@property (nonatomic,strong)UILabel * oilLabel;//油号
@property (nonatomic,strong)UILabel * priceLabel;//当前价格
@property (nonatomic,strong)UILabel * oldPriceLabel;//原价价格
@property (nonatomic,strong)UIView * oldLineView;//划掉原价的线
@property (nonatomic,strong)UILabel * sPriceLabel;//直购节省

//团购控件
//@property (nonatomic,strong)UILabel * todayPriceLabel;//自提价几个字
@property (nonatomic,strong)UIView * progressBackView;//进度条背景
@property (nonatomic,strong)UILabel * progressShowView;//显示当前已购吨数
@property (nonatomic,strong)UIView * progressForeView;//进度条
@property (nonatomic,strong)UILabel * lessLabel;//起始吨数
@property (nonatomic,strong)UILabel * moreLabel;//结束吨数
@property (nonatomic,strong)UILabel * distanceNextLabel;//下一阶梯降价还差吨数
@property (nonatomic,strong)UILabel * alreadyLabel;//已报名人数
@property (nonatomic,strong)UILabel * timeLabel;//时间倒计时
@property (nonatomic,strong)UIButton * detailBtn;//查看详情
@property (nonatomic,strong)UIImageView *finishImage;//已结束的标识

//直购控件
@property (nonatomic,strong)UIButton * tellBtn;//电话咨询
@property (nonatomic,strong)UIButton * shopCarBtn;//添加到购物车
@property (nonatomic,strong)UIButton * buyBtn;//立即购买


/**
 *根据section初始cell
 *style:cell样式
 *reuseIdentifier:重用标识
 *section:section=0表示团购，==1表示直购
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section;

@end
