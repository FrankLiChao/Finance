//
//  lhSelectCarIdCell.m
//  GasStation
//
//  Created by bosheng on 16/4/25.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhSelectCarIdCell.h"

@implementation lhSelectCarIdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //100
        self.backgroundColor = lhviewColor;
//        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer * subLayer = [[CALayer alloc] init];
        subLayer.frame = CGRectMake(8*widthRate, 5*widthRate, DeviceMaxWidth-16*widthRate, 90*widthRate);//设定层的大小
        subLayer.backgroundColor=[UIColor clearColor].CGColor;//设定层的背景色
        //设置层的阴影效果----
        subLayer.shadowOffset=CGSizeMake(0, 0); //阴影的位置
        subLayer.shadowRadius=4*widthRate;//阴影的圆角
        subLayer.shadowOpacity = 0.8;
        subLayer.shadowColor=lhcontentTitleColorStr.CGColor; //阴影的颜色
        [self.layer addSublayer:subLayer];
        
        UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(8*widthRate, 5*widthRate, DeviceMaxWidth-16*widthRate, 90*widthRate)];
        hView.backgroundColor = [UIColor whiteColor];
        hView.layer.cornerRadius = 4*widthRate;
        hView.layer.masksToBounds = YES;
        [self addSubview:hView];
        
        _hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 30*widthRate, 80*widthRate, 30*widthRate)];
        _hImgView.image = imageWithName(@"carIdBackgroundYellow");
        [hView addSubview:_hImgView];
        
        _bgCarIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 30*widthRate, 70*widthRate, 30*widthRate)];
        _bgCarIdLabel.font = [UIFont systemFontOfSize:16];
        _bgCarIdLabel.adjustsFontSizeToFitWidth = YES;
        _bgCarIdLabel.textAlignment = NSTextAlignmentCenter;
        _bgCarIdLabel.textColor = [UIColor whiteColor];
        [hView addSubview:_bgCarIdLabel];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(110*widthRate, 25*widthRate, 180*widthRate, 20*widthRate)];
        tLabel.font = [UIFont systemFontOfSize:14];
        tLabel.text = @"车牌号码：";
        tLabel.textColor = lhcontentTitleColorStr2;
        [hView addSubview:tLabel];

        _carIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(110*widthRate, 50*widthRate, 180*widthRate, 20*widthRate)];
        _carIdLabel.font = [UIFont systemFontOfSize:18];
        _carIdLabel.textColor = lhcontentTitleColorStr;
        [hView addSubview:_carIdLabel];
        
//        _seleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(269*widthRate, 35*widthRate, 20*widthRate, 20*widthRate)];
//        _seleImgView.image = imageWithName(@"seletedzhifu");//selectzhifu
//        [hView addSubview:_seleImgView];
        
    }
    
    return self;
}

@end
