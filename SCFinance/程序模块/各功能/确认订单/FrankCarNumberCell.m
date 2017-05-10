//
//  FrankCarNumberCell.m
//  GasStation
//
//  Created by lichao on 15/9/17.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankCarNumberCell.h"

@implementation FrankCarNumberCell

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
        self.carImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 0, 40*widthRate, 40*widthRate)];
        [self.carImage setImage:imageWithName(@"carnum")];
        [self addSubview:self.carImage];
        
//        self.hdImage = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-30*widthRate, 10*widthRate, 20*widthRate, 20*widthRate)];
//        [self.hdImage setImage:imageWithName(@"selectSymbol")];
//        self.hdImage.hidden = YES;
//        [self addSubview:self.hdImage];
        
        self.carNumber = [[UILabel alloc] initWithFrame:CGRectMake(60*widthRate, 0, DeviceMaxWidth-60*widthRate, 40*widthRate)];
        self.carNumber.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.carNumber];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        line.backgroundColor = tableDefSepLineColor;
        [self addSubview:line];
    }
    return self;
}

@end
