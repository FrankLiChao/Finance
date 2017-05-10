//
//  FrankSelectTime.m
//  SCFinance
//
//  Created by lichao on 16/7/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankSelectTime.h"

@implementation FrankSelectTime
{
    UIDatePicker *dateP;
    NSString * dateStr;//日期,MM月dd日
    NSString * dateStrY;//日期,yyyy-MM-dd
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:bgView];
        
        UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(40, (DeviceMaxHeight-200)/2, DeviceMaxWidth-80, 200)];
        popView.backgroundColor = [UIColor whiteColor];
        popView.layer.cornerRadius = 5;
        [bgView addSubview:popView];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(0, 160, (DeviceMaxWidth-80)/2, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(cancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:cancelBtn];
        
        UIButton * firmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        firmBtn.frame = CGRectMake((DeviceMaxWidth-80)/2, 160, (DeviceMaxWidth-80)/2, 40);
        [firmBtn setTitle:@"确定" forState:UIControlStateNormal];
        firmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [firmBtn addTarget:self action:@selector(firmBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:firmBtn];
        
        NSDate * dat;
        if (dateStr && ![@"" isEqualToString:dateStr]) {
            NSDateFormatter * fm = [[NSDateFormatter alloc]init];
            [fm setDateFormat:@"yyyy"];
            NSString * str = [fm stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
            NSString * n = [NSString stringWithFormat:@"%@-%@",str,dateStr];
            [fm setDateFormat:@"yyyy-MM-dd"];
            dat = [fm dateFromString:n];
        }
        else{
            dat = [NSDate dateWithTimeIntervalSinceNow:0];
        }
        
        dateP = [[UIDatePicker alloc]init];
        dateP.backgroundColor = lhviewColor;
        dateP.frame = CGRectMake(0, 0, DeviceMaxWidth-80, 160);
        dateP.layer.cornerRadius = 5;
        dateP.layer.masksToBounds = YES;
        dateP.date = dat;
        dateP.backgroundColor = [UIColor whiteColor];
        [dateP addTarget:self action:@selector(datePEvent:) forControlEvents:UIControlEventValueChanged];
        dateP.datePickerMode = UIDatePickerModeDate;
        [popView addSubview:dateP];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 160-0.5, DeviceMaxWidth-80, 0.5)];
        lineV.backgroundColor = tableDefSepLineColor;
        [popView addSubview:lineV];
        
        bgView.alpha = 0;
        popView.alpha = 0;
        popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            bgView.alpha = 1;
            popView.transform = CGAffineTransformMakeScale(1, 1);
            popView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    return self;
}

-(void)cancelBtnEvent:(UIButton *)button_
{
    __block UIView *popView = button_.superview;
    __block UIView *bgView = popView.superview;
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.4 animations:^{
        popView.alpha = 0;
        popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        bgView.alpha = 0;
    }completion:^(BOOL finished) {
        [popView removeFromSuperview];
        [bgView removeFromSuperview];
        [ws removeFromSuperview];
    }];
}

-(void)firmBtnEvent:(UIButton *)button_
{
    __block UIView *popView = button_.superview;
    __block UIView *bgView = popView.superview;
    __weak typeof(self) ws = self;
    
    NSDateFormatter * fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd"];
    
    dateStrY = [fm stringFromDate:dateP.date];
    [fm setDateFormat:@"yyyy-MM-dd"];
    dateStr = [fm stringFromDate:dateP.date];
    _delegate.oilData.text = dateStr;
    _delegate.oilData.textColor = lhcontentTitleColorStr;
    [UIView animateWithDuration:0.4 animations:^{
        popView.alpha = 0;
        popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        bgView.alpha = 0;
    }completion:^(BOOL finished) {
        [popView removeFromSuperview];
        [bgView removeFromSuperview];
        [ws removeFromSuperview];
    }];
}

#pragma mark - 时间选择
- (void)datePEvent:(UIDatePicker *)datePi
{
//    NSDateFormatter * fm = [[NSDateFormatter alloc]init];
    NSDate * nowDate = [NSDate date];
    NSTimeInterval bDate = [datePi.date timeIntervalSince1970];
    NSTimeInterval nDate = [nowDate timeIntervalSince1970];
    if (bDate < nDate) {
//        [fm setDateFormat:@"yyyy-MM-dd"];
        dateP.date = nowDate;
    }
}

@end
