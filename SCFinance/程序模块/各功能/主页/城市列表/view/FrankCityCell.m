//
//  FrankCityCell.m
//  SCFinance
//
//  Created by lichao on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankCityCell.h"
#import "FrankTools.h"
#import "FrankAutoLayout.h"
#import "FrankChooseCityView.h"

@implementation FrankCityCell
{
//    NSArray *cityArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary *)cityDic
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *cityArray = [cityDic objectForKey:@"children"];
        UILabel *cityLab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 20*widthRate, DeviceMaxWidth-40*widthRate, 20*widthRate)];
        cityLab.text = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"name"]];
        cityLab.textColor = lhcontentTitleColorStr;
        cityLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:cityLab];
        
        CGFloat widthX = 20*widthRate;
        CGFloat hightY = 60*widthRate;
        CGFloat widthBtn = 0;
        CGFloat hightBtn = 0;
        for (int i=0; i<cityArray.count; i++){
            NSDictionary * dic = cityArray[i];
            
            UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat width = [FrankTools sizeForString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] withSizeOfFont:[UIFont systemFontOfSize:14]]+30*widthRate;
            cityButton.frame = CGRectMake(widthX+widthBtn, hightY+hightBtn, width, 30*widthRate);
            cityButton.titleLabel.font = [UIFont systemFontOfSize:14];
            cityButton.backgroundColor = [UIColor whiteColor];
            [cityButton setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] forState:UIControlStateNormal];
            [cityButton setTitleColor:lhcontentTitleColorStr forState:UIControlStateNormal];
            [cityButton addTarget:self action:@selector(clickCityButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cityButton];
            widthBtn += width + 20*widthRate;
            if (widthBtn > DeviceMaxWidth-20*widthRate) {
                hightBtn += 50*widthRate;
                widthBtn = 0;
                cityButton.frame = CGRectMake(widthX+widthBtn, hightY+hightBtn, width, 30*widthRate);
                widthBtn += width + 20*widthRate;
            }
            if (i == cityArray.count-1) {
                [self setupAutoHeightWithBottomView:cityButton bottomMargin:0];
                [self updateLayout];
            }
        }
    }
    self.backgroundColor = lhviewColor;
    return self;
}

-(void)clickCityButtonEvent:(UIButton *)button_
{
    [self.delegate clickCityButtonEvent:button_.titleLabel.text];

}

@end
