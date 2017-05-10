//
//  FrankSetView.m
//  Drive
//
//  Created by lichao on 15/10/27.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankSetView.h"

@implementation FrankSetView

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
        //49
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 200*widthRate, 49*widthRate)];
        self.titleLabel.textColor = lhcontentTitleColorStr;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        self.yjtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-23*widthRate, 41*widthRate/2, 8*widthRate, 8*widthRate)];
        self.yjtImgView.image = imageWithName(@"youjiantouImage");
        [self addSubview:self.yjtImgView];
        
        self.mSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(DeviceMaxWidth-15*widthRate-51, (49*widthRate-31)/2, 51, 31)];
        self.mSwitch.on = YES;
        [self addSubview:self.mSwitch];
        self.mSwitch.hidden = YES;
        
        self.topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
        self.topLine.backgroundColor = tableDefSepLineColor;
        [self addSubview:self.topLine];
        
        self.lowLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49*widthRate-0.5, DeviceMaxWidth, 0.5)];
        self.lowLine.backgroundColor = tableDefSepLineColor;
        [self addSubview:self.lowLine];
    }
    
    return self;
}

@end
