//
//  FrankMessageCell.m
//  GasStation
//
//  Created by lichao on 15/9/4.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankMessageCell.h"

@implementation FrankMessageCell

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
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = lhviewColor;
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 30*widthRate)];
        self.timeLab.font = [UIFont systemFontOfSize:13];
        self.timeLab.textAlignment = NSTextAlignmentCenter;
        self.timeLab.textColor = [UIColor colorFromHexRGB:@"a2a2a2"];
        [self addSubview:self.timeLab];
        
        self.hdImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 30*widthRate, 40*widthRate, 40*widthRate)];
        [self addSubview:self.hdImage];
        
        self.bgLab = [[UIView alloc] initWithFrame:CGRectMake(60*widthRate, 30*widthRate, DeviceMaxWidth-80*widthRate, 60*widthRate)];
        self.bgLab.backgroundColor = [UIColor whiteColor];
        self.bgLab.layer.cornerRadius = 4*widthRate;
        self.bgLab.layer.masksToBounds = YES;
        [self addSubview:self.bgLab];
        
        UIView * wView = [[UIView alloc]initWithFrame:CGRectMake(60*widthRate, 30*widthRate, 4*widthRate, 4*widthRate)];
        wView.backgroundColor = [UIColor whiteColor];
        [self addSubview:wView];
        
        UIImageView * jImgView = [[UIImageView alloc]initWithFrame:CGRectMake(53*widthRate, 30*widthRate, 7*widthRate, 8*widthRate)];
        jImgView.image = imageWithName(@"messageCenterJianImage");
        [self addSubview:jImgView];
        
        self.tLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 5*widthRate, DeviceMaxWidth-100*widthRate, 20*widthRate)];
        self.tLab.numberOfLines = 0;
        self.tLab.font = [UIFont systemFontOfSize:15];
        self.tLab.textColor = lhlineColor;
        [self.bgLab addSubview:self.tLab];
        
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 30*widthRate, DeviceMaxWidth-100*widthRate, 20*widthRate)];
        self.contentLab.textColor = lhcontentTitleColorStr1;
        self.contentLab.font = [UIFont systemFontOfSize:13];
        self.contentLab.numberOfLines = 0;
        [self.bgLab addSubview:self.contentLab];
        
        self.lowView = [[UIView alloc]initWithFrame:CGRectMake(10*widthRate, 50*widthRate, DeviceMaxWidth-100*widthRate, 40*widthRate)];
        [self.bgLab addSubview:self.lowView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth-100*widthRate, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [self.lowView addSubview:lineView];
        
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*widthRate, 40*widthRate)];
        detailLabel.text = @"点击查看详情";
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = lhmainColor;
        [self.lowView addSubview:detailLabel];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.lowView.frame)-6*widthRate, 16*widthRate, 6*widthRate, 8*widthRate)];
        [image setImage:imageWithName(@"youjiantouImage")];
        [self.lowView addSubview:image];
        
    }
    return self;
}

@end
