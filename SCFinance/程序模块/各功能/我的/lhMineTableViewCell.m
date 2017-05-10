//
//  lhMineTableViewCell.m
//  SCFinance
//
//  Created by yutiandesan on 16/5/23.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMineTableViewCell.h"

@implementation lhMineTableViewCell

- (void)awakeFromNib {
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
        //67
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 20*widthRate, 25*widthRate, 25*widthRate)];
        [self addSubview:self.hImgView];
        
        self.circleView = [[UIView alloc]initWithFrame:CGRectMake(40*widthRate-5, 20*widthRate, 6, 6)];
        self.circleView.backgroundColor = [UIColor redColor];
        self.circleView.layer.cornerRadius = 3;
        self.circleView.layer.masksToBounds = YES;
//        self.circleView.hidden = YES;
        [self addSubview:self.circleView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(52*widthRate, 10*widthRate, DeviceMaxWidth-40*widthRate, 25*widthRate)];
        self.titleLab.textColor = lhcontentTitleColorStr;
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLab];
        
        self.subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(52*widthRate, 35*widthRate, DeviceMaxWidth-40*widthRate, 20*widthRate)];
        self.subTitleLab.textColor = lhcontentTitleColorStr2;
        self.subTitleLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.subTitleLab];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 67*widthRate-0.5, DeviceMaxWidth, 0.5)];
        self.lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:self.lineView];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-23*widthRate, 29.5*widthRate, 8*widthRate, 8*widthRate)];
        [image setImage:imageWithName(@"youjiantouImage")];
        [self addSubview:image];
        
    }
    return self;
}

@end
