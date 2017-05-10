//
//  lhOilDetailTableViewCell.m
//  SCFinance
//
//  Created by bosheng on 16/6/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhOilDetailTableViewCell.h"
#import "lhPersonalViewModel.h"

@implementation lhOilDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary *)dic
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //160+40+10
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 200*widthRate)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        UIView * gView = [[UIView alloc]initWithFrame:CGRectMake(0, 200*widthRate, DeviceMaxWidth, 10*widthRate)];
        gView.backgroundColor = lhviewColor;
        [self addSubview:gView];
        
        _hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 5*widthRate, 30*widthRate, 30*widthRate)];
        [self addSubview:_hImgView];
        
        NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"depotLogo"]];
        NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,str];
        [lhUtilObject checkImageWithImageView:_hImgView withImage:str withImageUrl:allStr withPlaceHolderImage:imageWithName(placeHolderImg)];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55*widthRate, 5*widthRate, DeviceMaxWidth-135*widthRate, 30*widthRate)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"depotName"]];
        _nameLabel.textColor = lhcontentTitleColorStr;
        [self addSubview:_nameLabel];
        
//        _tyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _tyBtn.frame = CGRectMake(DeviceMaxWidth-75*widthRate, 7*widthRate, 60*widthRate, 26*widthRate);
//        _tyBtn.layer.borderColor = lhmainColor.CGColor;
//        _tyBtn.layer.borderWidth = 0.5;
//        _tyBtn.layer.masksToBounds = YES;
//        _tyBtn.layer.cornerRadius = 3*widthRate;
//        [_tyBtn setTitle:@"我要提油" forState:UIControlStateNormal];
//        [_tyBtn setTitleColor:lhmainColor forState:UIControlStateNormal];
//        _tyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self addSubview:_tyBtn];
        
        _oilView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth, 160*widthRate)];
        [self addSubview:_oilView];
        
        [self setMyOilView:[dic objectForKey:@"oilList"]];
    }
    
    
    return self;
}

- (void)setMyOilView:(NSArray *)oilArray
{
    if (_oilView) {
        for (UIView * view in _oilView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if (oilArray && oilArray.count) {
        
        CGFloat maxNum = 0.0;//最大吨数
        for (int i = 0; i < oilArray.count; i++) {
            NSDictionary * dic = [oilArray objectAtIndex:i];
            NSString * rStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remainQuantity"]];
            NSString * uStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usedQuantity"]];
            if ([rStr doubleValue]+[uStr doubleValue] > maxNum) {
                maxNum = [rStr doubleValue]+[uStr doubleValue];
            }
        }
        
        if (maxNum == 0.0) {
            //暂无提油信息
            UILabel * dlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 20*widthRate, DeviceMaxWidth-30*widthRate, 140*widthRate)];
            dlabel.textAlignment = NSTextAlignmentCenter;
            dlabel.text = @"暂未购油";
            dlabel.textColor = [UIColor whiteColor];
            dlabel.font = [UIFont systemFontOfSize:15];
            [_oilView addSubview:dlabel];
            
            return;
        }
        
//        NSArray * tArray = @[@"国四 93#",@"国四 97#",@"国四 98#"];
        CGFloat totalHeight = 100*widthRate;
        CGFloat wid = 40*widthRate;
        for (int i = 0; i < oilArray.count; i++) {
            NSDictionary * dic = [oilArray objectAtIndex:i];
            
            //吨数显示
            UILabel * dlabel = [[UILabel alloc]initWithFrame:CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, 120*widthRate, (DeviceMaxWidth-2*wid)/oilArray.count, 0)];
            dlabel.textAlignment = NSTextAlignmentCenter;
            dlabel.font = [UIFont systemFontOfSize:12];
            [_oilView addSubview:dlabel];
            
            UIView * progressBackView = [[UIView alloc]initWithFrame:CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i+((DeviceMaxWidth-2*wid)/oilArray.count-30*widthRate)/2, 120*widthRate, 30*widthRate, 0)];
            progressBackView.backgroundColor = [UIColor whiteColor];
            progressBackView.layer.borderWidth = 0.5;
            progressBackView.layer.masksToBounds = YES;
            progressBackView.layer.cornerRadius = 4*widthRate;
            progressBackView.layer.anchorPoint = CGPointMake(0.5, 1);
            [_oilView addSubview:progressBackView];
            
            UIView * progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 120*widthRate, 30*widthRate, 0)];
//            progressView.layer.masksToBounds = YES;
//            progressView.layer.cornerRadius = 4*widthRate;
            progressView.layer.anchorPoint = CGPointMake(0.5, 1);
            [progressBackView addSubview:progressView];
            
            NSString * rStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remainQuantity"]];
            NSString * uStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usedQuantity"]];
            CGFloat totalRate = ([rStr doubleValue]+[uStr doubleValue])/maxNum;
            CGFloat rate = [rStr doubleValue]/([rStr doubleValue]+[uStr doubleValue]);
            progressView.backgroundColor = [[lhPersonalViewModel colorArray] objectAtIndex:i];
            dlabel.textColor = [[lhPersonalViewModel colorArray] objectAtIndex:i];
            dlabel.text = [NSString stringWithFormat:@"%.0ft/%.0ft",[rStr doubleValue],[rStr doubleValue]+[uStr doubleValue]];
            progressBackView.layer.borderColor = progressView.backgroundColor.CGColor;
            
            [UIView animateWithDuration:0.3 animations:^{
                progressBackView.frame = CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i+((DeviceMaxWidth-2*wid)/oilArray.count-30*widthRate)/2,20*widthRate+totalHeight*(1-totalRate), 30*widthRate,totalHeight*totalRate);
                
                progressView.frame = CGRectMake(0,totalHeight*totalRate*(1-rate), 30*widthRate,totalHeight*totalRate*rate);
                
                dlabel.frame = CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, totalHeight*(1-totalRate), (DeviceMaxWidth-2*wid)/oilArray.count, 20*widthRate);
            }];
            
            UILabel * nlabel = [[UILabel alloc]initWithFrame:CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, 130*widthRate, (DeviceMaxWidth-2*wid)/oilArray.count, 20*widthRate)];
            nlabel.textAlignment = NSTextAlignmentCenter;
            nlabel.font = [UIFont systemFontOfSize:12];
            nlabel.textColor = lhcontentTitleColorStr2;
            nlabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            [_oilView addSubview:nlabel];
        }
    }
    else{
        //暂无提油信息
        UILabel * dlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 20*widthRate, DeviceMaxWidth-30*widthRate, 140*widthRate)];
        dlabel.textAlignment = NSTextAlignmentCenter;
        dlabel.text = @"暂未购油";
        dlabel.textColor = [UIColor whiteColor];
        dlabel.font = [UIFont systemFontOfSize:15];
        [_oilView addSubview:dlabel];
        
    }
}

@end
