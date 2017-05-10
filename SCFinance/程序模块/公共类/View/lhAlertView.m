//
//  lhAlertView.m
//  GasStation
//
//  Created by liuhuan on 16/1/12.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhAlertView.h"

@implementation lhAlertView

- (instancetype)initWithFrame:(CGRect)frame noticeStr:(NSString *)nStr attributedS1:(NSAttributedString *)att1 attributedS2:(NSAttributedString *)att2 attributedS3:(NSAttributedString *)att3 attributedS4:(NSAttributedString *)att4 noticeStr2:(NSString *)noticeStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        maxView.tag = 1000999;
        maxView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:maxView];
        
        UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(30*widthRate, (DeviceMaxHeight-285*widthRate)/2, DeviceMaxWidth-60*widthRate, 285*widthRate)];
        alertView.tag = 1000998;
        [maxView addSubview:alertView];
        
        UIView * rAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 35*widthRate, CGRectGetWidth(alertView.frame), 250*widthRate)];
        rAlertView.backgroundColor = [UIColor whiteColor];
        rAlertView.layer.cornerRadius = 8;
        rAlertView.layer.masksToBounds = YES;
        [alertView addSubview:rAlertView];
        
        UIImageView * tImgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(alertView.frame)-56*widthRate)/2, 0, 70*widthRate, 70*widthRate)];
        tImgView.image = imageWithName(@"alertIcon");
        [alertView addSubview:tImgView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 45*widthRate, CGRectGetWidth(alertView.frame)-30*widthRate, 20*widthRate)];
        tLabel.textAlignment = NSTextAlignmentLeft;
        tLabel.textColor = [UIColor colorFromHexRGB:@"211613"];
        tLabel.font = [UIFont systemFontOfSize:13];
        tLabel.text = nStr;
        [rAlertView addSubview:tLabel];
        
        UILabel * cLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50*widthRate, 75*widthRate, CGRectGetWidth(alertView.frame)-52*widthRate, 20*widthRate)];
        cLabel1.textColor = lhcontentTitleColorStr2;
        cLabel1.font = [UIFont systemFontOfSize:13];
        cLabel1.attributedText = att1;
        [rAlertView addSubview:cLabel1];
        
        UILabel * cLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(50*widthRate, 95*widthRate, CGRectGetWidth(alertView.frame)-52*widthRate, 20*widthRate)];
        cLabel2.textColor = lhcontentTitleColorStr2;
        cLabel2.font = [UIFont systemFontOfSize:13];
        cLabel2.attributedText = att2;
        [rAlertView addSubview:cLabel2];
        
        UILabel * cLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(50*widthRate, 115*widthRate, CGRectGetWidth(alertView.frame)-52*widthRate, 20*widthRate)];
        cLabel3.textColor = lhcontentTitleColorStr2;
        cLabel3.font = [UIFont systemFontOfSize:13];
        cLabel3.attributedText = att3;
        cLabel3.adjustsFontSizeToFitWidth = YES;
        [rAlertView addSubview:cLabel3];
        
        UILabel * cLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(50*widthRate, 135*widthRate, CGRectGetWidth(alertView.frame)-52*widthRate, 20*widthRate)];
        cLabel4.textColor = lhcontentTitleColorStr2;
        cLabel4.font = [UIFont systemFontOfSize:13];
        cLabel4.attributedText = att4;
        cLabel4.adjustsFontSizeToFitWidth = YES;
        [rAlertView addSubview:cLabel4];
        
        UILabel * nLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 170*widthRate, CGRectGetWidth(alertView.frame)-40*widthRate, 30*widthRate)];
        nLabel.numberOfLines = 2;
        nLabel.textColor = lhmainColor;
        nLabel.font = [UIFont systemFontOfSize:12];
        nLabel.text = noticeStr;
        nLabel.adjustsFontSizeToFitWidth = YES;
        [rAlertView addSubview:nLabel];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.backgroundColor = [UIColor colorFromHexRGB:@"cecece"];
        cancelBtn.tag = 101;
        cancelBtn.layer.cornerRadius = 4*widthRate;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setFrame:CGRectMake(20*widthRate, 205*widthRate, (CGRectGetWidth(rAlertView.frame)-70*widthRate)/2, 35*widthRate)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(firmCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:cancelBtn];
        
        UIButton * fBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        fBtn.tag = 102;
        fBtn.layer.cornerRadius = 4*widthRate;
        fBtn.layer.masksToBounds = YES;
        fBtn.backgroundColor = lhmainColor;
        [fBtn setFrame:CGRectMake((CGRectGetWidth(rAlertView.frame)+30*widthRate)/2, 205*widthRate, (CGRectGetWidth(rAlertView.frame)-70*widthRate)/2, 35*widthRate)];
        [fBtn setTitle:@"确定" forState:UIControlStateNormal];
        [fBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fBtn addTarget:self action:@selector(firmCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:fBtn];
        
        maxView.alpha = 0;
        alertView.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            maxView.alpha = 1;
            alertView.transform = CGAffineTransformMakeScale(1, 1);
            alertView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    
    return self;
}

- (instancetype)initWithFrame2:(CGRect)frame noticeStr:(NSString *)nStr attributedS1:(NSAttributedString *)att1
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        maxView.tag = 1000999;
        maxView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:maxView];
        
        UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(30*widthRate, (DeviceMaxHeight-260*widthRate)/2, DeviceMaxWidth-60*widthRate, 260*widthRate)];
        alertView.tag = 1000998;
        [maxView addSubview:alertView];
        
        UIView * rAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 35*widthRate, CGRectGetWidth(alertView.frame), 225*widthRate)];
        rAlertView.backgroundColor = [UIColor whiteColor];
        rAlertView.layer.cornerRadius = 8;
        rAlertView.layer.masksToBounds = YES;
        [alertView addSubview:rAlertView];
        
        UIImageView * tImgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(alertView.frame)-70*widthRate)/2, 0, 70*widthRate, 70*widthRate)];
        tImgView.image = imageWithName(@"alertIcon");
        [alertView addSubview:tImgView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate, 45*widthRate, CGRectGetWidth(alertView.frame)-30*widthRate, 20*widthRate)];
        tLabel.textColor = lhcontentTitleColorStr;
        tLabel.font = [UIFont systemFontOfSize:15];
        tLabel.text = nStr;
        [rAlertView addSubview:tLabel];
        
        CGFloat wid = 50*widthRate;
        UILabel * cLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(wid, 75*widthRate, CGRectGetWidth(alertView.frame)-wid-20*widthRate, 95*widthRate)];
        cLabel1.numberOfLines = 0;
        cLabel1.textColor = lhcontentTitleColorStr2;
        cLabel1.font = [UIFont systemFontOfSize:13];
        cLabel1.attributedText = att1;
        [rAlertView addSubview:cLabel1];
        
//        UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        delBtn.frame = CGRectMake(CGRectGetWidth(rAlertView.frame)-42*widthRate, 2*widthRate, 40*widthRate, 30*widthRate);
//        [delBtn setBackgroundImage:imageWithName(@"malldetaildeleteBtn") forState:UIControlStateNormal];
//        [delBtn addTarget:self action:@selector(alertViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
//        [rAlertView addSubview:delBtn];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.backgroundColor = [UIColor colorFromHexRGB:@"cecece"];
        cancelBtn.tag = 101;
        cancelBtn.layer.cornerRadius = 4*widthRate;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setFrame:CGRectMake(20*widthRate, 180*widthRate, (CGRectGetWidth(rAlertView.frame)-70*widthRate)/2, 35*widthRate)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(firmCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:cancelBtn];
        
        UIButton * fBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        fBtn.tag = 102;
        fBtn.layer.cornerRadius = 4*widthRate;
        fBtn.layer.masksToBounds = YES;
        fBtn.backgroundColor = lhmainColor;
        [fBtn setFrame:CGRectMake((CGRectGetWidth(rAlertView.frame)+30*widthRate)/2, 180*widthRate, (CGRectGetWidth(rAlertView.frame)-70*widthRate)/2, 35*widthRate)];
        [fBtn setTitle:@"确定" forState:UIControlStateNormal];
        [fBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fBtn addTarget:self action:@selector(firmCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:fBtn];
        
        maxView.alpha = 0;
        alertView.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            maxView.alpha = 1;
            alertView.transform = CGAffineTransformMakeScale(1, 1);
            alertView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    
    return self;
}

- (instancetype)initWithFrame3:(CGRect)frame noticeStr:(NSString *)nStr 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        maxView.tag = 1000999;
        maxView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:maxView];
        
        UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(30*widthRate, (DeviceMaxHeight-210*widthRate)/2, DeviceMaxWidth-60*widthRate, 210*widthRate)];
        alertView.tag = 1000998;
        [maxView addSubview:alertView];
        
        UIView * rAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 28*widthRate, CGRectGetWidth(alertView.frame), 180*widthRate)];
        rAlertView.backgroundColor = [UIColor whiteColor];
        rAlertView.layer.cornerRadius = 8;
        rAlertView.layer.masksToBounds = YES;
        [alertView addSubview:rAlertView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 30*widthRate, CGRectGetWidth(alertView.frame)-30*widthRate, 40*widthRate)];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.numberOfLines = 2;
        tLabel.textColor = lhcontentTitleColorStr2;
        tLabel.font = [UIFont boldSystemFontOfSize:14];
        tLabel.text = nStr;
        [rAlertView addSubview:tLabel];
        
        CGFloat wid = 25*widthRate;
        UILabel * cLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(wid, 70*widthRate, CGRectGetWidth(alertView.frame)-2*wid, 65*widthRate)];
        cLabel1.textAlignment = NSTextAlignmentCenter;
        cLabel1.textColor = lhredColorStr;
        cLabel1.font = [UIFont systemFontOfSize:13];
        cLabel1.text = @"请不要在加油站内接听电话！";
        [rAlertView addSubview:cLabel1];
        
//        UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        delBtn.frame = CGRectMake(CGRectGetWidth(rAlertView.frame)-42*widthRate, 2*widthRate, 40*widthRate, 30*widthRate);
//        [delBtn setBackgroundImage:imageWithName(@"malldetaildeleteBtn") forState:UIControlStateNormal];
//        [delBtn addTarget:self action:@selector(alertViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
//        [rAlertView addSubview:delBtn];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.layer.cornerRadius = 4*widthRate;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setFrame:CGRectMake(0, 140*widthRate, CGRectGetWidth(rAlertView.frame)/2, 40*widthRate)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:lhcontentTitleColorStr2 forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(alertViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:cancelBtn];
        
        UIButton * fBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        fBtn.tag = 102;
        fBtn.layer.cornerRadius = 4*widthRate;
        fBtn.layer.masksToBounds = YES;
        fBtn.backgroundColor = [UIColor whiteColor];
        [fBtn setFrame:CGRectMake(CGRectGetWidth(rAlertView.frame)/2, 140*widthRate, CGRectGetWidth(rAlertView.frame)/2, 40*widthRate)];
        [fBtn setTitle:@"确定" forState:UIControlStateNormal];
        [fBtn setTitleColor:lhredColorStr forState:UIControlStateNormal];
        [fBtn addTarget:self action:@selector(firmCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:fBtn];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 140*widthRate, CGRectGetWidth(rAlertView.frame), 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [rAlertView addSubview:lineView];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(rAlertView.frame)/2-0.25, 140*widthRate, 0.5, 40*widthRate)];
        lineView1.backgroundColor = tableDefSepLineColor;
        [rAlertView addSubview:lineView1];
        
        maxView.alpha = 0;
        alertView.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            maxView.alpha = 1;
            alertView.transform = CGAffineTransformMakeScale(1, 1);
            alertView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    
    return self;
}

#pragma mark - 验证银行卡信息提示
- (instancetype)initWithFrame1:(CGRect)frame noticeStr:(NSString *)nStr insImage:(UIImage *)iImage content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        maxView.tag = 1000999;
        maxView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:maxView];
        
        CGFloat totalH = 0.0;
        if (iImage) {
            totalH = 240*widthRate;
        }
        else{
            totalH = 180*widthRate;
        }
        
        UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(30*widthRate, (DeviceMaxHeight-totalH)/2, DeviceMaxWidth-60*widthRate, totalH)];
        alertView.tag = 1000998;
        [maxView addSubview:alertView];
        
        UIView * rAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame), totalH)];
        rAlertView.backgroundColor = [UIColor whiteColor];
        rAlertView.layer.cornerRadius = 8;
        rAlertView.layer.masksToBounds = YES;
        [alertView addSubview:rAlertView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 20*widthRate, CGRectGetWidth(alertView.frame)-30*widthRate, 20*widthRate)];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.textColor = lhcontentTitleColorStr;
        tLabel.font = [UIFont boldSystemFontOfSize:16];
        tLabel.text = nStr;
        [rAlertView addSubview:tLabel];
        
        CGFloat heih = 55*widthRate;
        if (iImage) {
            UIImageView * iImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(alertView.frame)-115)/2, heih, 115, 104)];
            iImageView.image = iImage;
            [rAlertView addSubview:iImageView];
            heih += 120;
        }
        
        
        UILabel * cLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, iImage?CGRectGetHeight(rAlertView.frame)-70*widthRate:heih-10*widthRate, CGRectGetWidth(alertView.frame)-30*widthRate, iImage?20*widthRate:90*widthRate)];
        cLabel.textAlignment = NSTextAlignmentCenter;
        cLabel.textColor = lhcontentTitleColorStr1;
        cLabel.font = [UIFont systemFontOfSize:14];
        cLabel.text = content;
        [rAlertView addSubview:cLabel];
        
        if (!iImage) {
            NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:content];
            NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
            [ps setLineSpacing:6];
            [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, content.length)];
            cLabel.numberOfLines = 0;
            cLabel.attributedText = as;
        }
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(rAlertView.frame)-40*widthRate-0.5, DeviceMaxWidth, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [rAlertView addSubview:lineView];
        
        UIButton * fBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [fBtn setFrame:CGRectMake(0, CGRectGetHeight(rAlertView.frame)-40*widthRate, CGRectGetWidth(alertView.frame), 40*widthRate)];
        fBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [fBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [fBtn setTitleColor:lhredColorStr forState:UIControlStateNormal];
        [fBtn addTarget:self action:@selector(alertViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
        [rAlertView addSubview:fBtn];
        
        maxView.alpha = 0;
        alertView.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            maxView.alpha = 1;
            alertView.transform = CGAffineTransformMakeScale(1, 1);
            alertView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    
    return self;
}

#pragma mark - 确定、取消
- (void)firmCancelBtnEvent:(UIButton *)btn
{
    [self alertViewDisAppear];
    
    if(btn.tag == 102){
        if ([self.delegate respondsToSelector:@selector(firmBtnClick:)]) {
            [self.delegate firmBtnClick:(lhAlertView *)btn.superview.superview.superview.superview];
        }
    }
    else if(btn.tag == 101){
        if ([self.delegate respondsToSelector:@selector(cancelBtnClick:)]) {
            [self.delegate cancelBtnClick:(lhAlertView *)btn.superview.superview.superview.superview];
        }
    }
}

- (void)alertViewDisAppear
{
    __block UIView * maxView = [self viewWithTag:1000999];
    __block UIView * alertView = [self viewWithTag:1000998];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.2 animations:^{
        maxView.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        alertView.alpha = 0;
    }completion:^(BOOL finished) {
        [maxView removeFromSuperview];
        [alertView removeFromSuperview];
        [ws removeFromSuperview];
        maxView = nil;
        alertView = nil;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
