//
//  lhFilterView.m
//  SCFinance
//
//  Created by bosheng on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhFilterView.h"
#import "FrankAutoLayout.h"

@interface lhFilterView()
{
    UIImageView * locationImgView;
    UILabel * cityLabel;
    
    UIView * whiteView;
    UIScrollView * filterScrollView;//删选条件
    UIView * fView;//油品和油库筛选控件
    
    NSMutableArray * btnArray;//存储
    
    NSMutableDictionary * filterStrDict;//存储删选条件
}

@end

@implementation lhFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        filterStrDict = [NSMutableDictionary dictionary];
        
        [self firmInit];
        
    }
    
    return self;
}

- (void)firmInit
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    UIView * tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 68*widthRate, DeviceMaxHeight)];
    tapView.backgroundColor = [UIColor clearColor];
    [self addSubview:tapView];
    [tapView addGestureRecognizer:tap];
    
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth, 0, DeviceMaxWidth-68*widthRate, DeviceMaxHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    filterScrollView = [UIScrollView new];
    filterScrollView.showsVerticalScrollIndicator = NO;
    [whiteView addSubview:filterScrollView];
    
    filterScrollView.sd_layout
    .yIs(20)
    .xIs(0)
    .heightIs(DeviceMaxHeight-20-49)
    .widthIs(CGRectGetWidth(whiteView.frame));
    
    fView = [UIView new];
    [filterScrollView addSubview:fView];
    
    fView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthIs(CGRectGetWidth(whiteView.frame))
    .heightIs(0);

    [filterScrollView setupAutoContentSizeWithBottomView:fView bottomMargin:20];
    
    cityLabel = [UILabel new];
    cityLabel.font = [UIFont systemFontOfSize:15];
    cityLabel.textColor = lhredColorStr;
    [filterScrollView addSubview:cityLabel];
    
    cityLabel.sd_layout
    .xIs(CGRectGetWidth(whiteView.frame)-15-CGRectGetWidth(cityLabel.frame))
    .yIs(14)
    .widthIs(50)
    .heightIs(20);
    
    locationImgView = [UIImageView new];
    locationImgView.image = imageWithName(@"locationImage_red");
    [filterScrollView addSubview:locationImgView];
    
    locationImgView.sd_layout
    .rightSpaceToView(cityLabel,2)
    .yIs(16.5)
    .widthIs(15)
    .heightIs(15);
    
    _cityButton = [UIButton new];
    [filterScrollView addSubview:_cityButton];
    
    _cityButton.sd_layout
    .leftSpaceToView(locationImgView,-15)
    .rightEqualToView(cityLabel)
    .yIs(10)
    .heightIs(28);
    
    UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:lhcontentTitleColorStr forState:UIControlStateNormal];
    resetButton.backgroundColor = [UIColor whiteColor];
    [resetButton addTarget:self action:@selector(resetButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    resetButton.titleLabel.font = [UIFont systemFontOfSize:18];
    resetButton.frame = CGRectMake(0, CGRectGetHeight(whiteView.frame)-49, CGRectGetWidth(whiteView.frame)/2, 49);
    [whiteView addSubview:resetButton];
    
    UIButton * firmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firmButton setTitle:@"确定" forState:UIControlStateNormal];
    firmButton.backgroundColor = lhmainColor;
    [firmButton addTarget:self action:@selector(firmButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [firmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    firmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    firmButton.frame = CGRectMake(CGRectGetWidth(whiteView.frame)/2, CGRectGetHeight(whiteView.frame)-49, CGRectGetWidth(whiteView.frame)/2, 49);
    [whiteView addSubview:firmButton];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(whiteView.frame)-49, CGRectGetWidth(whiteView.frame), 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [whiteView addSubview:lineView];
    
}

//设置筛选条件数据，重新初始化筛选控件
- (void)setFilterArray:(NSArray *)filterArray
{
    for (UIView * view in fView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat heih = 14;
    if (btnArray){
        [btnArray removeAllObjects];
        btnArray = nil;
    }
    btnArray = [NSMutableArray arrayWithCapacity:filterArray.count];
    for (int j=0;j < filterArray.count;j++) {
        
        NSDictionary * dic = [filterArray objectAtIndex:j];
        NSString * tStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, heih, 150, 20)];
        tLabel.text = tStr;
        tLabel.textColor = lhcontentTitleColorStr;
        tLabel.font = [UIFont systemFontOfSize:18];
        [fView addSubview:tLabel];
        
        heih += 35;
        
        NSArray * cArray = [dic objectForKey:@"value"];
        NSMutableArray * everyBtnArray = [NSMutableArray arrayWithCapacity:cArray.count];
        UIButton * tempBtn = nil;
        for (int i=0;i < cArray.count; i++) {
            NSDictionary * cDic = [cArray objectAtIndex:i];
            NSString * contentStr = [NSString stringWithFormat:@"%@",[cDic objectForKey:@"name"]];
            
            UIButton * eleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            eleBtn.tag = j*20+i;
            eleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [eleBtn setTitleColor:lhcontentTitleColorStr forState:UIControlStateNormal];
            [eleBtn setTitleColor:lhmainColor forState:UIControlStateSelected];
            [eleBtn setTitle:contentStr forState:UIControlStateNormal];
            [eleBtn setTitle:contentStr forState:UIControlStateSelected];
            [eleBtn setBackgroundColor:[UIColor colorFromHexRGB:@"f0f2f5"]];
            [eleBtn addTarget:self action:@selector(eleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            eleBtn.layer.cornerRadius = 5;
            eleBtn.layer.masksToBounds = YES;
            
            if (i == 0) {
                [eleBtn setFrame:CGRectMake(15, heih, 100, 27)];
                [eleBtn sizeToFit];
                
                CGRect re = eleBtn.frame;
                re.size.width += 20;
                re.size.height = 27;
                eleBtn.frame = re;
            }
            else{
                [eleBtn setFrame:CGRectMake(tempBtn.frame.origin.x+tempBtn.frame.size.width+10, heih, 100, 27)];
                [eleBtn sizeToFit];
                
                CGRect re = eleBtn.frame;
                re.size.width += 20;
                re.size.height = 27;
                eleBtn.frame = re;
                
                if (eleBtn.frame.origin.x+eleBtn.frame.size.width+15 > CGRectGetWidth(whiteView.frame)) {
                    heih += 47;
                    
                    [eleBtn setFrame:CGRectMake(15, heih, 100, 27)];
                    [eleBtn sizeToFit];
                    
                    CGRect re = eleBtn.frame;
                    re.size.width += 20;
                    re.size.height = 27;
                    eleBtn.frame = re;
                }
                
            }
            tempBtn = eleBtn;
            [fView addSubview:eleBtn];
            
            [everyBtnArray addObject:tempBtn];
        }
        [btnArray addObject:everyBtnArray];
        
        heih += 60;
    }
 
    fView.sd_layout.heightIs(heih);
    [whiteView updateLayout];
    
    _filterArray = filterArray;
}

//选择元素
- (void)eleBtnEvent:(UIButton *)button_
{
    NSInteger i = button_.tag%20;//每个元素的下标
    NSInteger j = (button_.tag-i)/20;//每个筛选条件
    
    NSDictionary * dic = [_filterArray objectAtIndex:j];//每个筛选数据
    NSDictionary * oneDic = [[dic objectForKey:@"value"] objectAtIndex:i];//每个元素
    
    NSMutableSet * set = [filterStrDict objectForKey:[dic objectForKey:@"key"]];
    if (!set) {
        set = [NSMutableSet set];
    }

    if (button_.selected) {
        //取消选择
        button_.selected = NO;
        
        button_.backgroundColor = [UIColor colorFromHexRGB:@"f0f2f5"];
        button_.layer.borderColor = [UIColor clearColor].CGColor;
        button_.layer.borderWidth = 0.0;
        
        [set removeObject:oneDic];
        
        if (set.count == 0) {
            [filterStrDict removeObjectForKey:[dic objectForKey:@"key"]];
        }
        else{
            [filterStrDict setObject:set forKey:[dic objectForKey:@"key"]];
        }
        return;
    }
    
    //选择
    button_.selected = YES;
    
    button_.backgroundColor = [UIColor whiteColor];
    button_.layer.borderColor = lhmainColor.CGColor;
    button_.layer.borderWidth = 0.5;
    
    [set addObject:oneDic];
    
    [filterStrDict setObject:set forKey:[dic objectForKey:@"key"]];
    
    
//    NSString * keyStr = [[_filterArray objectAtIndex:j] objectForKey:@"submitStr"];
//    [filterStrDict setObject:[[[[_filterArray objectAtIndex:j] objectForKey:@"filter"] objectAtIndex:i] objectForKey:@"name"] forKey:keyStr];
}

#pragma mark - 重置筛选条件和确定筛选条件
- (void)resetButtonEvent
{
    for (NSArray * tempA in btnArray) {
        for (UIButton * btn in tempA){
            btn.selected = NO;
            
            btn.backgroundColor = [UIColor colorFromHexRGB:@"f0f2f5"];
            btn.layer.borderColor = [UIColor clearColor].CGColor;
            btn.layer.borderWidth = 0.0;
        }
    }
    if (filterStrDict) {
        [filterStrDict removeAllObjects];
    }
}

- (void)firmButtonEvent
{
    if(_delegate && [_delegate respondsToSelector:@selector(setFilterStrDict:)]){
        [_delegate setFilterStrDict:filterStrDict];
    }
    
    [self disAppear];
}

//设置城市名称时，调整空间位置
- (void)setCityStr:(NSString *)cityStr
{
    _cityStr = cityStr;
    
    cityLabel.text = cityStr;
    CGSize cSize = [lhUtilObject sizeWithFontWhenIOS7:cityStr font:cityLabel.font];
    cityLabel.sd_layout.widthIs(cSize.width);
    cityLabel.sd_layout
    .xIs(CGRectGetWidth(whiteView.frame)-15-CGRectGetWidth(cityLabel.frame));
    
    [whiteView updateLayout];
}

#pragma mark - 界面出现或消失
- (void)appear
{
    [self resetButtonEvent];//重置选择的条件
    
    self.hidden = NO;
    
    CGRect wRect = whiteView.frame;
    wRect.origin.x = 68*widthRate;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = wRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }];
    
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)disAppear
{
    CGRect wRect = whiteView.frame;
    wRect.origin.x = DeviceMaxWidth;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = wRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
