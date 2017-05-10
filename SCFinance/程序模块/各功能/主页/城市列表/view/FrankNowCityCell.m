//
//  FrankNowCityCell.m
//  SCFinance
//
//  Created by lichao on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankNowCityCell.h"
#import "FrankTools.h"

@implementation FrankNowCityCell

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
        self.backgroundColor = lhviewColor;
        
        UILabel *cityLab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 20*widthRate, DeviceMaxWidth-40*widthRate, 20*widthRate)];
        cityLab.text = [NSString stringWithFormat:@"当前城市"];
        cityLab.textColor = lhcontentTitleColorStr;
        cityLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:cityLab];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(20*widthRate, 50*widthRate, 40*widthRate, 30*widthRate)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5*widthRate, 7*widthRate, 16*widthRate, 16*widthRate)];
        [imageV setImage:imageWithName(@"nowcitytubiao")];
        [_bgView addSubview:imageV];
        
        _nowCityLab = [[UILabel alloc] init];
        _nowCityLab.font = [UIFont systemFontOfSize:14];
        _nowCityLab.text = @"成都";
        _nowCityLab.textColor = lhmainColor;
        [_bgView addSubview:_nowCityLab];
        
        _nowCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_nowCityBtn];
        
    }
    return self;
}

@end
