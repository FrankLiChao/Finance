//
//  lhGoodsTableViewCell.m
//  SCFinance
//
//  Created by bosheng on 16/5/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhGoodsTableViewCell.h"

@implementation lhGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = lhviewColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (section == 0) {//团购
            //215+10
            UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 215)];
            whiteView.backgroundColor = [UIColor whiteColor];
            [self addSubview:whiteView];
            
            _hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 5, 20, 20)];
//            _hImgView.backgroundColor = [UIColor grayColor];
//            [_hImgView setImage:imageWithName(@"hangyoulogo")];
            [self addSubview:_hImgView];
            
            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate+20, 5, 110, 20)];
//            _nameLabel.text = @"中航油四川公司";
            _nameLabel.textColor = lhcontentTitleColorStr;
            _nameLabel.font = [UIFont systemFontOfSize:12];
            [self addSubview:_nameLabel];
            
            _validateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(145*widthRate, 7.5, 69, 15)];
            _validateImgView.image = imageWithName(@"mainValidateImage");
            [self addSubview:_validateImgView];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, 29.75, DeviceMaxWidth-30*widthRate, 0.5)];
            lineView.backgroundColor = tableDefSepLineColor;
            [self addSubview:lineView];
            
            CGFloat wih = 40*widthRate;
            _oilLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih, 45, DeviceMaxWidth-130*widthRate, 20)];
//            _oilLabel.text = @"国四汽油93#";
            _oilLabel.font = [UIFont systemFontOfSize:15];
            _oilLabel.textColor = lhcontentTitleColorStr;
            [self addSubview:_oilLabel];
            
            _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih+5*widthRate, 70, DeviceMaxWidth-2*wih, 60)];
            _priceLabel.font = [UIFont boldSystemFontOfSize:30];
//            _priceLabel.textAlignment = NSTextAlignmentCenter;
            _priceLabel.textColor = lhredColorStr;
            [self addSubview:_priceLabel];
            
            _oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, 60, 15)];
            _oldPriceLabel.font = [UIFont systemFontOfSize:14];
            //            _oldPriceLabel.textAlignment = NSTextAlignmentCenter;
            _oldPriceLabel.textColor = lhcontentTitleColorStr2;
//            _oldPriceLabel.text = @"￥5900";
            [self addSubview:_oldPriceLabel];
            
//            _todayPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,102, 100, 15)];
//            _todayPriceLabel.textAlignment = NSTextAlignmentRight;
//            _todayPriceLabel.text = @"自提价";
//            _todayPriceLabel.font = [UIFont systemFontOfSize:12];
//            _todayPriceLabel.textColor = lhcontentTitleColorStr2;
//            [whiteView addSubview:_todayPriceLabel];
            
            _oldLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 48, 1)];
            _oldLineView.backgroundColor = lhcontentTitleColorStr2;
            [_oldPriceLabel addSubview:_oldLineView];
            
            _sPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_oldPriceLabel.frame.origin.x, 102, 105, 15)];
            _sPriceLabel.font = [UIFont systemFontOfSize:12];
            _sPriceLabel.textColor = lhcontentTitleColorStr2;
            [self addSubview:_sPriceLabel];
            
            _progressBackView = [[UIView alloc]initWithFrame:CGRectMake(wih, 130, DeviceMaxWidth-2*wih, 20)];
            _progressBackView.backgroundColor = [UIColor whiteColor];
            _progressBackView.layer.masksToBounds = YES;
            _progressBackView.layer.cornerRadius = 10;
            _progressBackView.layer.borderColor = [UIColor colorFromHexRGB:@"d7d7d7"].CGColor;
            _progressBackView.layer.borderWidth = 0.5;
            [self addSubview:_progressBackView];
            
            _progressForeView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, (CGRectGetWidth(_progressBackView.frame)-4)*0.69, 16)];
            _progressForeView.backgroundColor = [UIColor colorFromHexRGB:@"ffd27f"];
            _progressForeView.layer.masksToBounds = YES;
            _progressForeView.layer.cornerRadius = 8;
            [_progressBackView addSubview:_progressForeView];
            
            _progressShowView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_progressForeView.frame)-40-2, 2, 40, 12)];
            _progressShowView.font = [UIFont systemFontOfSize:12];
            _progressShowView.textAlignment = NSTextAlignmentCenter;
//            _progressShowView.text = @"690t";
            _progressShowView.adjustsFontSizeToFitWidth = YES;
            _progressShowView.textColor = [UIColor whiteColor];
            _progressShowView.backgroundColor = [UIColor colorFromHexRGB:@"febc43"];
            _progressShowView.layer.masksToBounds = YES;
            _progressShowView.layer.cornerRadius = 6;
            [_progressForeView addSubview:_progressShowView];
            
            _lessLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih, 150, 100, 20)];
            _lessLabel.font = [UIFont systemFontOfSize:13];
            _lessLabel.text = @"0t";
            _lessLabel.textColor = lhcontentTitleColorStr;
            [self addSubview:_lessLabel];
            
            _moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-wih-100, 150, 100, 20)];
            _moreLabel.font = [UIFont systemFontOfSize:13];
            _moreLabel.textAlignment = NSTextAlignmentRight;
//            _moreLabel.text = @"1000t";
            _moreLabel.textColor = lhcontentTitleColorStr;
            [self addSubview:_moreLabel];
            
//            _distanceNextLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih, 180, 200, 20)];
//            _distanceNextLabel.font = [UIFont systemFontOfSize:12];
//            _distanceNextLabel.textColor = lhcontentTitleColorStr2;
////            _distanceNextLabel.text = @"还差280吨降至5700/吨";
//            [whiteView addSubview:_distanceNextLabel];
            
            _alreadyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-15*widthRate-200, 180, 200, 20)];
//            _alreadyLabel.text = @"已有57人报名";
            _alreadyLabel.textAlignment = NSTextAlignmentRight;
            _alreadyLabel.font = [UIFont systemFontOfSize:12];
            _alreadyLabel.textColor = lhcontentTitleColorStr2;
            [self addSubview:_alreadyLabel];
            
            _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih, 180, 200, 20)];
//            _timeLabel.text = @"还剩0天 23:17:23";
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = lhcontentTitleColorStr2;
            [self addSubview:_timeLabel];
            
            _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _detailBtn.frame = CGRectMake(DeviceMaxWidth-90*widthRate, 41, 75*widthRate, 28);
            _detailBtn.backgroundColor = [UIColor whiteColor];
            _detailBtn.layer.borderColor = lhlineColor.CGColor;
            _detailBtn.layer.borderWidth = 0.5;
            _detailBtn.layer.masksToBounds = YES;
            _detailBtn.layer.cornerRadius = 5;
            [_detailBtn setTitle:@"立即参团" forState:UIControlStateNormal];
            [_detailBtn setTitleColor:lhlineColor forState:UIControlStateNormal];
            _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:_detailBtn];
            
            _finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-85, 36, 75, 43)];
            [_finishImage setImage:imageWithName(@"mainPageFinishedImage")];
            _finishImage.hidden = YES;
            [self addSubview:_finishImage];

        }
        else{//直购
            //180+10
            UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 180)];
            whiteView.backgroundColor = [UIColor whiteColor];
            [self addSubview:whiteView];
            
            _hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 5, 20, 20)];
//            _hImgView.backgroundColor = [UIColor grayColor];
//            [_hImgView setImage:imageWithName(@"hangyoulogo")];
            [self addSubview:_hImgView];
            
            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate+20, 5, 110, 20)];
            _nameLabel.text = @"中航油四川公司";
            _nameLabel.textColor = lhcontentTitleColorStr;
            _nameLabel.font = [UIFont systemFontOfSize:12];
            [self addSubview:_nameLabel];
            
            _validateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(145*widthRate, 7.5, 69, 15)];
            _validateImgView.image = imageWithName(@"mainValidateImage");
            [self addSubview:_validateImgView];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, 29.75, DeviceMaxWidth-30*widthRate, 0.5)];
            lineView.backgroundColor = tableDefSepLineColor;
            [self addSubview:lineView];
            
            CGFloat wih = 40*widthRate;
            _oilLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih, 45, DeviceMaxWidth-2*wih, 20)];
            _oilLabel.text = @"国四汽油93#";
            _oilLabel.font = [UIFont systemFontOfSize:15];
            _oilLabel.textColor = lhcontentTitleColorStr;
            [self addSubview:_oilLabel];
            
            _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(wih+5*widthRate, 70, DeviceMaxWidth-2*wih, 60)];
            _priceLabel.font = [UIFont boldSystemFontOfSize:30];
//            _priceLabel.textAlignment = NSTextAlignmentCenter;
            _priceLabel.textColor = lhredColorStr;
            [self addSubview:_priceLabel];
            
//            _todayPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,97, 100, 15)];
//            _todayPriceLabel.textAlignment = NSTextAlignmentRight;
//            _todayPriceLabel.text = @"自提价";
//            _todayPriceLabel.font = [UIFont systemFontOfSize:12];
//            _todayPriceLabel.textColor = lhcontentTitleColorStr2;
//            [whiteView addSubview:_todayPriceLabel];
        
            _oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, 60, 15)];
            _oldPriceLabel.font = [UIFont systemFontOfSize:14];
//            _oldPriceLabel.textAlignment = NSTextAlignmentCenter;
            _oldPriceLabel.textColor = lhcontentTitleColorStr2;
//            _oldPriceLabel.text = @"￥5900";
            [self addSubview:_oldPriceLabel];
            
            _oldLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 48, 1)];
            _oldLineView.backgroundColor = lhcontentTitleColorStr2;
            [_oldPriceLabel addSubview:_oldLineView];
            
            _sPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_oldPriceLabel.frame.origin.x, 102, 105, 15)];
            _sPriceLabel.font = [UIFont systemFontOfSize:12];
//            _sPriceLabel.textAlignment = NSTextAlignmentCenter;
            _sPriceLabel.textColor = lhcontentTitleColorStr2;
//            _sPriceLabel.text = @"省￥170";
            [self addSubview:_sPriceLabel];
            
            UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, 129.5, DeviceMaxWidth-30*widthRate, 0.5)];
            lineView3.backgroundColor = tableDefSepLineColor;
            [self addSubview:lineView3];
            
            UIImageView * phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, 146.5, 17, 17)];
            phoneImgView.image = imageWithName(@"phoneSymbolImage");
            [self addSubview:phoneImgView];
            
            UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*widthRate+17, 130, 60, 50)];
            phoneLabel.font = [UIFont systemFontOfSize:15];
            phoneLabel.text = @"电话咨询";
            phoneLabel.textColor = lhcontentTitleColorStr2;
            [self addSubview:phoneLabel];
            
            _tellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _tellBtn.frame = CGRectMake(15*widthRate, 130, 80, 50);
            [self addSubview:_tellBtn];
            
            _shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _shopCarBtn.frame = CGRectMake(DeviceMaxWidth-230*widthRate, 137.5, 100*widthRate, 35);
            _shopCarBtn.backgroundColor = [UIColor whiteColor];
            _shopCarBtn.layer.borderColor = lhlineColor.CGColor;
            _shopCarBtn.layer.borderWidth = 0.5;
            _shopCarBtn.layer.masksToBounds = YES;
            _shopCarBtn.layer.cornerRadius = 5;
            [_shopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [_shopCarBtn setTitleColor:lhlineColor forState:UIControlStateNormal];
            _shopCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:_shopCarBtn];
            
            _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _buyBtn.frame = CGRectMake(DeviceMaxWidth-115*widthRate, 137.5, 100*widthRate, 35);
            _buyBtn.backgroundColor = lhlineColor;
            _buyBtn.layer.masksToBounds = YES;
            _buyBtn.layer.cornerRadius = 5;
            [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:_buyBtn];
        }
    }
    
    return self;
}

@end
