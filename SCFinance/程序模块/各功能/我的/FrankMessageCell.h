//
//  FrankMessageCell.h
//  GasStation
//
//  Created by lichao on 15/9/4.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankMessageCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLab;              //时间
@property(nonatomic,strong)UIView  *bgLab;              //消息边框
@property(nonatomic,strong)UILabel *tLab;               //消息标题
@property(nonatomic,strong)UIImageView  *hdImage;       //标题图片
@property(nonatomic,strong)UILabel      *contentLab;    //消息内容

@property (nonatomic,strong)UIView * lowView;           //查看详情

@end
