//
//  lhPersonalView.m
//  SCFinance
//
//  Created by bosheng on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhPersonalView.h"
#import "lhPersonalViewModel.h"

@interface lhPersonalView()

@end

@implementation lhPersonalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-49)];
        _maxScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_maxScrollView];
        
        [self initFrameView];
        
    }
    
    return self;
}

-(void)initFrameView
{
    UIView * topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight)];
    topBgView.backgroundColor = lhmainColorBlack;
    [_maxScrollView addSubview:topBgView];
    
    CGFloat heih = 0;
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 64+216*widthRate)];
    _topView.backgroundColor = lhmainColorBlack;
    [_maxScrollView addSubview:_topView];
    
    heih += CGRectGetHeight(_topView.frame)+9*widthRate;
    
    UIView * orderView = [[UIView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 95*widthRate)];
    orderView.backgroundColor = [UIColor whiteColor];
    [_maxScrollView addSubview:orderView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/2-0.25, 15*widthRate, 0.5, CGRectGetHeight(orderView.frame)-30*widthRate)];
    lineView.backgroundColor = tableDefSepLineColor;
    [orderView addSubview:lineView];
    
    UIImageView * orderBuyImg = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceMaxWidth/2-45*widthRate)/2, 15*widthRate, 45*widthRate, 45*widthRate)];
    orderBuyImg.image = imageWithName(@"orderBuyImage");
    [orderView addSubview:orderBuyImg];
    
    UILabel * orderBuyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*widthRate, DeviceMaxWidth/2, 28*widthRate)];
    orderBuyLabel.textAlignment = NSTextAlignmentCenter;
    orderBuyLabel.font = [UIFont systemFontOfSize:12];
    orderBuyLabel.textColor = lhcontentTitleColorStr2;
    orderBuyLabel.text = @"直购订单";
    [orderView addSubview:orderBuyLabel];
    
    UIImageView * orderTeamBuyImg = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth/2+(DeviceMaxWidth/2-45*widthRate)/2, 15*widthRate, 45*widthRate, 45*widthRate)];
    orderTeamBuyImg.image = imageWithName(@"orderTeamBuyImage");
    [orderView addSubview:orderTeamBuyImg];
    
    UILabel * orderTeamBuyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth/2, 60*widthRate, DeviceMaxWidth/2, 28*widthRate)];
    orderTeamBuyLabel.textAlignment = NSTextAlignmentCenter;
    orderTeamBuyLabel.font = [UIFont systemFontOfSize:12];
    orderTeamBuyLabel.textColor = lhcontentTitleColorStr2;
    orderTeamBuyLabel.text = @"团购订单";
    [orderView addSubview:orderTeamBuyLabel];
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.frame = CGRectMake(0, 0, DeviceMaxWidth/2, CGRectGetHeight(orderView.frame));
    [orderView addSubview:_buyBtn];
    
    _teamBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _teamBuyBtn.frame = CGRectMake(DeviceMaxWidth/2, 0, DeviceMaxWidth/2, CGRectGetHeight(orderView.frame));
    [orderView addSubview:_teamBuyBtn];
    
    heih += 104*widthRate;
    
    _funTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 67*widthRate*[lhPersonalViewModel funArray].count)];
    _funTableView.scrollEnabled = NO;
    _funTableView.separatorColor = [UIColor clearColor];
    _funTableView.backgroundColor = [UIColor clearColor];
    [_maxScrollView addSubview:_funTableView];
    
}

- (void)setMyOilView:(NSArray *)oilArray
{
    if (_topView) {
        for (UIView * view in _topView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if (oilArray && oilArray.count) {
        
        CGFloat maxNum = 0.0;//最大吨数
        for (int i = 0; i < oilArray.count; i++) {
            NSDictionary * dic = [oilArray objectAtIndex:i];
            NSString * rStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remainQuantity"]];
            if ([rStr doubleValue] > maxNum) {
                maxNum = [rStr doubleValue];
            }
        }
        
        if (maxNum == 0.0) {
            //暂无提油信息
            UILabel * dlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 64+20*widthRate, DeviceMaxWidth-30*widthRate, 136*widthRate)];
            dlabel.textAlignment = NSTextAlignmentCenter;
            dlabel.text = @"暂未购油";
            dlabel.textColor = [UIColor whiteColor];
            dlabel.font = [UIFont systemFontOfSize:15];
            [_topView addSubview:dlabel];
            
            return;
        }
        
        CGFloat totalHeight = 136*widthRate;
        CGFloat wid = 40*widthRate;
        for (int i = 0; i < oilArray.count; i++) {
            NSDictionary * dic = [oilArray objectAtIndex:i];
            
            //吨数显示
            UILabel * dlabel = [[UILabel alloc]initWithFrame:CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, 64+156*widthRate, (DeviceMaxWidth-2*wid)/oilArray.count, 20*widthRate)];
            dlabel.textAlignment = NSTextAlignmentCenter;
            dlabel.font = [UIFont systemFontOfSize:12];
            [_topView addSubview:dlabel];
            
            UIView * progressView = [[UIView alloc]initWithFrame:CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i+((DeviceMaxWidth-2*wid)/oilArray.count-30*widthRate)/2, 64+156*widthRate, 30*widthRate, 0)];
            progressView.layer.masksToBounds = YES;
            progressView.layer.cornerRadius = 4*widthRate;
            progressView.layer.anchorPoint = CGPointMake(0.5, 1);
            [_topView addSubview:progressView];
            
            NSString * rStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remainQuantity"]];
            CGFloat rate = [rStr doubleValue]/maxNum;
            dlabel.text = [NSString stringWithFormat:@"%@吨",rStr];
    
            dlabel.textColor = [[lhPersonalViewModel colorArray] objectAtIndex:i];
            progressView.backgroundColor = [[lhPersonalViewModel colorArray] objectAtIndex:i];
            
//            [UIView animateWithDuration:0.3 animations:^{
                progressView.frame = CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i+((DeviceMaxWidth-2*wid)/oilArray.count-30*widthRate)/2,64+20*widthRate+totalHeight*(1-rate), 30*widthRate,totalHeight*rate);
                
                dlabel.frame = CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, 64+totalHeight*(1-rate), (DeviceMaxWidth-2*wid)/oilArray.count, 20*widthRate);
//            }completion:^(BOOL finished) {
//                progressView.frame = CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i+((DeviceMaxWidth-2*wid)/oilArray.count-30*widthRate)/2,64+20*widthRate+totalHeight*(1-rate), 30*widthRate,totalHeight*rate);
//                
//                dlabel.frame = CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, 64+totalHeight*(1-rate), (DeviceMaxWidth-2*wid)/oilArray.count, 20*widthRate);
//            }];
            
            UILabel * nlabel = [[UILabel alloc]initWithFrame:CGRectMake(wid+(DeviceMaxWidth-2*wid)/oilArray.count*i, 64+176*widthRate, (DeviceMaxWidth-2*wid)/oilArray.count, 20*widthRate)];
            nlabel.adjustsFontSizeToFitWidth = YES;
            nlabel.textAlignment = NSTextAlignmentCenter;
            nlabel.font = [UIFont systemFontOfSize:12];
            nlabel.textColor = lhcontentTitleColorStr2;
            nlabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            [_topView addSubview:nlabel];
        }
    }
    else{
        //暂无提油信息
        
//        [lhUtilObject addANullLabelWithSuperView:_topView withText:@"暂无余油信息"];
        
        UILabel * dlabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, 64+20*widthRate, DeviceMaxWidth-30*widthRate, 136*widthRate)];
        dlabel.textAlignment = NSTextAlignmentCenter;
        dlabel.text = @"暂未购油";
        dlabel.textColor = [UIColor whiteColor];
        dlabel.font = [UIFont systemFontOfSize:15];
        [_topView addSubview:dlabel];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
