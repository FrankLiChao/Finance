//
//  lhMineTableViewCell.h
//  SCFinance
//
//  Created by yutiandesan on 16/5/23.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhMineTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *hImgView;    //图标
@property(nonatomic,strong)UIView       *circleView;  //小红点
@property(nonatomic,strong)UILabel      *titleLab;    //消息内容
@property(nonatomic,strong)UILabel      *subTitleLab; //副标题
@property(nonatomic,strong)UIView       *lineView;

@end
