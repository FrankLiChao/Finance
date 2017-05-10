//
//  FrankListCell.m
//  SCFinance
//
//  Created by lichao on 16/7/13.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankListCell.h"

@implementation FrankListCell

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
    
    if (self) { //130
        self.backgroundColor = [UIColor colorFromHexRGB:@"f9f9f9"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
        hView.backgroundColor = [UIColor whiteColor];
        [self addSubview:hView];
        
        _orderName = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-110*widthRate, 40)];
        _orderName.font = [UIFont systemFontOfSize:14];
        _orderName.textColor = lhcontentTitleColorStr2;
        [hView addSubview:_orderName];
        
        _dataName = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-120*widthRate, 0, 110*widthRate, 40)];
        _dataName.font = [UIFont systemFontOfSize:14];
        _dataName.textColor = lhcontentTitleColorStr2;
        _dataName.textAlignment = NSTextAlignmentRight;
        [hView addSubview:_dataName];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [hView addSubview:lineView];
        
        _oilNumber = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 40, 80*widthRate, 40*widthRate)];
        _oilNumber.text = @"国四 93#";
        _oilNumber.textColor = lhcontentTitleColorStr;
        _oilNumber.font = [UIFont systemFontOfSize:15];
        [self addSubview:_oilNumber];
        
        _oilStock = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-90*widthRate, 40, 80*widthRate, 40*widthRate)];
        _oilStock.text = @"60 吨";
        _oilStock.textColor = lhcontentTitleColorStr;
        _oilStock.font = [UIFont systemFontOfSize:15];
        _oilStock.textAlignment = NSTextAlignmentRight;
        [self addSubview:_oilStock];
        
        _oilAddress = [[UILabel alloc] initWithFrame:CGRectMake(90*widthRate, 40, DeviceMaxWidth-180*widthRate, 40*widthRate)];
        _oilAddress.text = @"中航油广汉库";
        _oilAddress.textColor = lhcontentTitleColorStr;
        _oilAddress.font = [UIFont systemFontOfSize:15];
        _oilAddress.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_oilAddress];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        _lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:_lineView];
        
        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40*widthRate, DeviceMaxWidth, 50)];
        fView.backgroundColor = [UIColor whiteColor];
        [self addSubview:fView];
        
        _totalMoney = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40)];
        _totalMoney.textAlignment = NSTextAlignmentRight;
        _totalMoney.font = [UIFont systemFontOfSize:13];
        _totalMoney.textColor = lhcontentTitleColorStr2;
        [fView addSubview:_totalMoney];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 80+40*widthRate, DeviceMaxWidth, 10)];
        lineV.backgroundColor = lhviewColor;
        [self addSubview:lineV];
    }
    return self;
}


@end
