//
//  FrankCarNumberView.m
//  SCFinance
//
//  Created by lichao on 16/7/7.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankCarNumberView.h"

@interface FrankCarNumberView()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation FrankCarNumberView
{
    NSString *carKey;
    NSDictionary *carNumDic;
    NSArray *keyForCarNum;
    NSArray *valueForCarNum;
    NSInteger lastRow0;
    NSString *carValue;
    NSString *carNumberTemp;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:bgView];
        
        UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(40, (DeviceMaxHeight-200)/2, DeviceMaxWidth-80, 200)];
        popView.backgroundColor = [UIColor whiteColor];
        popView.layer.cornerRadius = 5;
        popView.layer.masksToBounds = YES;
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
        [firmBtn addTarget:self action:@selector(clickSureForCarNum:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:firmBtn];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 160-0.5, DeviceMaxWidth-80, 0.5)];
        lineV.backgroundColor = tableDefSepLineColor;
        [popView addSubview:lineV];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth-80, 160)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.layer.cornerRadius = 5;
        pickerView.layer.masksToBounds = YES;
        pickerView.showsSelectionIndicator = YES;
        [popView addSubview:pickerView];
        
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

-(void)initData
{
    carKey = [[NSString alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chepai" ofType:@""];
    NSData *data=[NSData dataWithContentsOfFile:path];
    carNumDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    keyForCarNum = [carNumDic allKeys];
    valueForCarNum = [carNumDic allValues];
}

-(void)clickSureForCarNum:(UIButton *)button_
{
    __block UIView *popView = button_.superview;
    __block UIView *bgView = popView.superview;
    __weak typeof(self) ws = self;
    _delegate.carNum.text = carNumberTemp;
    [UIView animateWithDuration:0.2
                     animations:^{
                         popView.alpha = 0;
                         popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         bgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [bgView removeFromSuperview];
                         [popView removeFromSuperview];
                         [ws removeFromSuperview];
                         bgView = nil;
                         popView = nil;
                     }];
}

-(void)cancelBtnEvent:(UIButton *)button_
{
    __block UIView *popView = button_.superview;
    __block UIView *bgView = popView.superview;
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         popView.alpha = 0;
                         popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         bgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [bgView removeFromSuperview];
                         [popView removeFromSuperview];
                         [ws removeFromSuperview];
                         bgView = nil;
                         popView = nil;
                     }];
}

#pragma mark- 设置数据
//一共多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //1.获取当前的列
    //2.返回当前列对应的行数
    if (component == 0) {
        
        return [keyForCarNum count];
    }else{
        NSArray * eA = [carNumDic objectForKey:keyForCarNum[lastRow0]];
        return eA.count;
    }
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //1.获取当前的列
    //    NSArray *arayM= self.foods[component];
    //    //2.获取当前列对应的行的数据
    //    NSString *name=arayM[row];
    if (component == 0) {
        return keyForCarNum[row];
    }else{
        return [carNumDic objectForKey:[keyForCarNum objectAtIndex:lastRow0]][row];
    }
}

#pragma mark-设置下方的数据刷新
// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
    if (component == 0) {
        carKey = keyForCarNum[row];
        lastRow0 = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        carValue = [carNumDic objectForKey:carKey][0];
    }else if (component == 1)
    {
        if ([carKey isEqual:@""]) {
            carKey = keyForCarNum[0];
        }
        carValue = [carNumDic objectForKey:carKey][row];
    }
    carNumberTemp = [NSString stringWithFormat:@"%@%@",carKey,carValue];
}

@end
