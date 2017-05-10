//
//  lhFirmOrderView.h
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrankAutoLayout.h"

@interface lhFirmOrderView : UIView

@property (nonatomic,strong)UITableView * firmTableView;//表格
@property (nonatomic,strong)UIScrollView * maxScrollView;

@property (nonatomic,strong)UIButton * seleFaPiaoBtn;//选择发票
//@property (nonatomic,strong)UIButton * seleCarIdBtn;//选择车辆

@property (nonatomic,strong)UILabel * faPiaoLabel;//发票
//@property (nonatomic,strong)UILabel * carIdLabel;//车牌

//@property (nonatomic,strong)UILabel * bankCardIdLabel;

@property (nonatomic,strong)UILabel * totalPriceLabel;//合计金额显示
@property (nonatomic,strong)UILabel * servicePriceLabel;//服务费金额显示
@property (nonatomic,strong)UIButton * submitBtn;//提交订单按钮

@end
