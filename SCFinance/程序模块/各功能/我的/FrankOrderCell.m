//
//  FrankOrderCell.m
//  SCFinance
//
//  Created by lichao on 16/6/12.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankOrderCell.h"

@implementation FrankOrderCell

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
    
    if (self) {//40
        self.backgroundColor = [UIColor colorFromHexRGB:@"f9f9f9"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _oilNumber = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 80*widthRate, 40*widthRate-0.5)];
        _oilNumber.text = @"国四 93#";
        _oilNumber.textColor = lhcontentTitleColorStr;
        _oilNumber.font = [UIFont systemFontOfSize:15];
        [self addSubview:_oilNumber];
        
        _oilStock = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-90*widthRate, 0, 80*widthRate, 40*widthRate)];
        _oilStock.text = @"60 吨";
        _oilStock.textColor = lhcontentTitleColorStr;
        _oilStock.font = [UIFont systemFontOfSize:15];
        _oilStock.textAlignment = NSTextAlignmentRight;
        [self addSubview:_oilStock];
        
        _oilAddress = [[UILabel alloc] initWithFrame:CGRectMake(90*widthRate, 0, DeviceMaxWidth-180*widthRate, 40*widthRate)];
        _oilAddress.text = @"中航油广汉库";
        _oilAddress.textColor = lhcontentTitleColorStr;
        _oilAddress.font = [UIFont systemFontOfSize:15];
        _oilAddress.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_oilAddress];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        _lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:_lineView];
    }
    return self;
}

@end
