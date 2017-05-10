//
//  lhCircleView.h
//  LHNormalTest
//
//  Created by bosheng on 16/7/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhCircleView : UIView

@property (nonatomic,strong)UILabel * contentLabel;//内容
@property (nonatomic,assign)CGFloat progressValue;//进度,0-1.0;
@property (nonatomic,strong)UILabel * numlabel;//吨数显示
@property (nonatomic,strong)UIButton * detailBtn;//点击查看详情

@end
