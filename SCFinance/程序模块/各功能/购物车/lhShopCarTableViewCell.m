//
//  lhShopCarTableViewCell.m
//  SCFinance
//
//  Created by bosheng on 16/5/31.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhShopCarTableViewCell.h"

@implementation lhShopCarTableViewCell

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
        //110+10
        
        self.backgroundColor = lhviewColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 110)];
        whiteView.backgroundColor = [UIColor colorFromHexRGB:@"f9f9f9"];
        [self addSubview:whiteView];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(0, 30, 50, 50);
        [_selectBtn setImage:imageWithName(@"selectedImage") forState:UIControlStateSelected];
        [_selectBtn setImage:imageWithName(@"noSelectedImage") forState:UIControlStateNormal];
        [self addSubview:_selectBtn];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, DeviceMaxWidth-60, 25)];
        _nameLabel.textColor = lhcontentTitleColorStr;
        _nameLabel.font = [UIFont systemFontOfSize:15];
//        _nameLabel.text = @"国四汽油93#";
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, 150, 20)];
//        _priceLabel.text = @"￥5730/ 吨";
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = lhcontentTitleColorStr;
        [self addSubview:_priceLabel];
        
        _oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 40, 100, 20)];
//        _oldPriceLabel.text = @"￥5900";
        _oldPriceLabel.font = [UIFont systemFontOfSize:14];
        _oldPriceLabel.textColor = lhcontentTitleColorStr2;
        [self addSubview:_oldPriceLabel];
        
        _oldLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 11, 45, 1)];
        _oldLineView.backgroundColor = lhcontentTitleColorStr2;
        [_oldPriceLabel addSubview:_oldLineView];
        
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-215, 40, 200, 20)];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.textColor = lhredColorStr;
        _totalLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_totalLabel];
        
        _jsLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-215, 60, 200, 15)];
        _jsLabel.textAlignment = NSTextAlignmentRight;
        _jsLabel.textColor = lhcontentTitleColorStr2;
        _jsLabel.font = [UIFont boldSystemFontOfSize:12];

        [self addSubview:_jsLabel];
        
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subBtn.frame = CGRectMake(50, 65, 26, 30);
        [_subBtn setImage:imageWithName(@"shopCarSubImage_S") forState:UIControlStateHighlighted];
        [_subBtn setImage:imageWithName(@"shopCarSubImage_N") forState:UIControlStateNormal];
        [self addSubview:_subBtn];
        
        _inputField = [[UITextField alloc]initWithFrame:CGRectMake(76, 65, 48, 30)];
        _inputField.keyboardType = UIKeyboardTypeNumberPad;
        _inputField.background = imageWithName(@"shopCarInputImage");
        _inputField.textAlignment = NSTextAlignmentCenter;
        _inputField.font = [UIFont systemFontOfSize:15];
        _inputField.textColor = lhcontentTitleColorStr;
//        _inputField.text = @"5";
        [self addSubview:_inputField];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(124, 65, 26, 30);
        [_addBtn setImage:imageWithName(@"shopCarAddImage_S") forState:UIControlStateHighlighted];
        [_addBtn setImage:imageWithName(@"shopCarAddImage_N") forState:UIControlStateNormal];
        [self addSubview:_addBtn];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 109.5, DeviceMaxWidth, 0.5)];
        lineView1.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineView1];
    }
    
    return self;
}

@end
