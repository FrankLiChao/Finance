//
//  lhShopCarView.m
//  SCFinance
//
//  Created by bosheng on 16/6/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhShopCarView.h"

static lhShopCarView * onlySCView;

@interface lhShopCarView()
{
    UIView * iaView;
}

@end

@implementation lhShopCarView

+ (instancetype)shareShopCarView
{
    if (onlySCView) {
        return onlySCView;
    }
    
    onlySCView = [[lhShopCarView alloc]init];
    
    return onlySCView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self firmInit];
    }
    
    return self;
}

- (void)firmInit
{
    _shopCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-113) style:UITableViewStylePlain];
    _shopCarTableView.showsVerticalScrollIndicator = NO;
    _shopCarTableView.separatorColor = [UIColor clearColor];
    _shopCarTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_shopCarTableView];
    
    _lowView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight-98, DeviceMaxWidth, 49)];
    _lowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_lowView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [_lowView addSubview:lineView];
    
    UILabel * allLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 45, 49)];
    allLabel.font = [UIFont systemFontOfSize:18];
    allLabel.textColor = lhcontentTitleColorStr;
    allLabel.text = @"全选";
    [_lowView addSubview:allLabel];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(0, 0, 50, 49);
    [_selectBtn setImage:imageWithName(@"selectedImage") forState:UIControlStateSelected];
    [_selectBtn setImage:imageWithName(@"noSelectedImage") forState:UIControlStateNormal];
    [_lowView addSubview:_selectBtn];
    
    _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, DeviceMaxWidth-190, 25)];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.textColor = lhredColorStr;
    [_lowView addSubview:_totalLabel];
    
    UILabel * servicePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, DeviceMaxWidth-190, 12)];
    servicePriceLabel.text = @"不包括服务费";
    servicePriceLabel.textAlignment = NSTextAlignmentRight;
    servicePriceLabel.font = [UIFont systemFontOfSize:12];
    servicePriceLabel.textColor = lhcontentTitleColorStr2;
    [_lowView addSubview:servicePriceLabel];
    
    _settleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settleBtn.frame = CGRectMake(DeviceMaxWidth-80, 0, 80, 49);
    _settleBtn.backgroundColor = lhmainColor;
    _settleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_settleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lowView addSubview:_settleBtn];
    
    _maxControl = [[UIControl alloc]initWithFrame:self.bounds];
    _maxControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubview:_maxControl];
    _maxControl.hidden = YES;
}

//返回一个inputAccessoryView
- (UIView *)anInputAccessoryView
{
    if (iaView) {
        _showLabel.cursor.hidden = NO;
        [_showLabel cursorBlink];
        
        return iaView;
    }
    
    iaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
    iaView.backgroundColor = [UIColor whiteColor];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [iaView addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [iaView addSubview:lineView1];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [iaView addSubview:_cancelBtn];
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    _finishBtn.frame = CGRectMake(DeviceMaxWidth-60, 0, 60, 40);
    [iaView addSubview:_finishBtn];
    
    _showLabel = [[lhCursorLabel alloc]initWithFrame:CGRectMake(60, 0, DeviceMaxWidth-120, 40)];
    _showLabel.font = [UIFont systemFontOfSize:15];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.textColor = lhcontentTitleColorStr;
    [iaView addSubview:_showLabel];
    
    return iaView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
