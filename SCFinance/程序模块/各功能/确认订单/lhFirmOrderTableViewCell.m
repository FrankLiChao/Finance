//
//  lhFirmOrderTableViewCell.m
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhFirmOrderTableViewCell.h"

@implementation lhFirmOrderTableViewCell

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
        //75
        self.backgroundColor = [UIColor colorFromHexRGB:@"f9f9f9"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, DeviceMaxWidth-60, 20)];
        _nameLabel.textColor = lhcontentTitleColorStr;
        _nameLabel.font = [UIFont systemFontOfSize:15];
//        _nameLabel.text = @"国四汽油93#";
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 150, 14)];
//        _priceLabel.text = @"￥5730/吨";
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = lhcontentTitleColorStr;
        [self addSubview:_priceLabel];
        
        _oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 30, 100, 14)];
//        _oldPriceLabel.text = @"￥5900";
        _oldPriceLabel.font = [UIFont systemFontOfSize:12];
        _oldPriceLabel.textColor = lhcontentTitleColorStr2;
        [self addSubview:_oldPriceLabel];
        
        _oldLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, 45, 1)];
        _oldLineView.backgroundColor = lhcontentTitleColorStr2;
        [_oldPriceLabel addSubview:_oldLineView];
        
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-215, 28, 200, 16)];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.textColor = lhredColorStr;
        _totalLabel.font = [UIFont boldSystemFontOfSize:14];
//        _totalLabel.text = @"小计: ￥28650";
        [self addSubview:_totalLabel];
        
        _jsLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-215, 47, 200, 15)];
        _jsLabel.textAlignment = NSTextAlignmentRight;
        _jsLabel.textColor = lhcontentTitleColorStr2;
        _jsLabel.font = [UIFont systemFontOfSize:12];
//        _jsLabel.text = @"已省 ￥850";
        [self addSubview:_jsLabel];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 200, 15)];
        _numLabel.textColor = lhcontentTitleColorStr2;
        _numLabel.font = [UIFont systemFontOfSize:12];
//        _numLabel.text = @"x5";
        [self addSubview:_numLabel];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 74.5, DeviceMaxWidth, 0.5)];
        lineView1.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineView1];
    }
    
    return self;
}

@end
