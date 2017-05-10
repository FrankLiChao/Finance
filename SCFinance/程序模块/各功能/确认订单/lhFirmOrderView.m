//
//  lhFirmOrderView.m
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhFirmOrderView.h"

@interface lhFirmOrderView()
{
    
}

@end

@implementation lhFirmOrderView

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
    _maxScrollView = [UIScrollView new];
    _maxScrollView.showsVerticalScrollIndicator = NO;
    _maxScrollView.backgroundColor = lhviewColor;
    [self addSubview:_maxScrollView];
    
    _maxScrollView.sd_layout
    .xIs(0)
    .yIs(64)
    .widthIs(DeviceMaxWidth)
    .heightIs(DeviceMaxHeight-64);
    
    _firmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0) style:UITableViewStylePlain];
    _firmTableView.scrollEnabled = NO;
    _firmTableView.separatorColor = [UIColor clearColor];
    _firmTableView.backgroundColor = [UIColor clearColor];
    [_maxScrollView addSubview:_firmTableView];
    
    UIView * selectView = [UIView new];
    selectView.backgroundColor = [UIColor whiteColor];
    [_maxScrollView addSubview:selectView];
    
    UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-100, 40)];
    tLabel.text = @"公司名称";
    tLabel.textColor = lhcontentTitleColorStr;
    tLabel.font = [UIFont systemFontOfSize:14];
    [selectView addSubview:tLabel];
    
//    UILabel * tLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, DeviceMaxWidth-100, 40)];
//    tLabel1.text = @"配送车辆";
//    tLabel1.textColor = lhcontentTitleColorStr;
//    tLabel1.font = [UIFont systemFontOfSize:14];
//    [selectView addSubview:tLabel1];
    
    _faPiaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth-25, 40)];
    _faPiaoLabel.textAlignment = NSTextAlignmentRight;
//    _faPiaoLabel.text = @"成都虎威加油管理有限公司";
    _faPiaoLabel.textColor = lhcontentTitleColorStr2;
    _faPiaoLabel.font = [UIFont systemFontOfSize:14];
    [selectView addSubview:_faPiaoLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-23, 16, 8, 8)];
    [arrowView setImage:imageWithName(@"youjiantouImage")];
    [selectView addSubview:arrowView];
    
//    _carIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, DeviceMaxWidth-25, 40)];
//    _carIdLabel.textAlignment = NSTextAlignmentRight;
////    _carIdLabel.text = @"川A 17177";
//    _carIdLabel.textColor = lhcontentTitleColorStr2;
//    _carIdLabel.font = [UIFont systemFontOfSize:14];
//    [selectView addSubview:_carIdLabel];
//    
//    UIImageView *arrowView1 = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-23, 56, 8, 8)];
//    [arrowView1 setImage:imageWithName(@"youjiantouImage")];
//    [selectView addSubview:arrowView1];
//    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 39.75, DeviceMaxWidth-30, 0.5)];
//    lineView.backgroundColor = tableDefSepLineColor;
//    [selectView addSubview:lineView];
    
    _seleFaPiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _seleFaPiaoBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 40);
    [selectView addSubview:_seleFaPiaoBtn];
    
//    _seleCarIdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _seleCarIdBtn.frame = CGRectMake(0, 40, DeviceMaxWidth, 40);
//    [selectView addSubview:_seleCarIdBtn];
    
    selectView.sd_layout
    .xIs(0)
    .topSpaceToView(_firmTableView,10)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UIView * zfView = [UIView new];
    zfView.backgroundColor = [UIColor whiteColor];
    [_maxScrollView addSubview:zfView];
    
    zfView.sd_layout
    .xIs(0)
    .topSpaceToView(selectView,10)
    .widthIs(DeviceMaxWidth)
    .heightIs(80);
    
    UILabel * payTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, DeviceMaxWidth, 40)];
    payTitleLabel.text = @"支付方式";
    payTitleLabel.textColor = lhcontentTitleColorStr;
    payTitleLabel.font = [UIFont systemFontOfSize:14];
    [zfView addSubview:payTitleLabel];
    
    UIImageView * payImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 20, 20)];
    payImgView.image = imageWithName(@"bankImagePlaceHolder");
    [zfView addSubview:payImgView];
    
    UILabel * payLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, DeviceMaxWidth-100, 40)];
    payLabel.text = @"网银转账";
    payLabel.textColor = lhcontentTitleColorStr;
    payLabel.font = [UIFont systemFontOfSize:14];
    [zfView addSubview:payLabel];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39.75, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [zfView addSubview:lineView1];
    
    UIImageView * gImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-30, 52.5, 15, 15)];
    gImgView.image = imageWithName(@"gougouimage");
    [zfView addSubview:gImgView];
    
//    _bankCardIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 45, DeviceMaxWidth-162, 30)];
//    _bankCardIdLabel.textAlignment = NSTextAlignmentRight;
//    _bankCardIdLabel.font = [UIFont systemFontOfSize:13];
//    _bankCardIdLabel.textColor = lhcontentTitleColorStr2;
//    [zfView addSubview:_bankCardIdLabel];
    
    [_maxScrollView setupAutoHeightWithBottomView:zfView bottomMargin:59];
    
    UIView * lowView = [UIView new];
    lowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lowView];
    
    lowView.sd_layout
    .xIs(0)
    .bottomSpaceToView(self,0)
    .widthIs(DeviceMaxWidth)
    .heightIs(49);
    
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, DeviceMaxWidth-190, 25)];
    _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    _totalPriceLabel.font = [UIFont systemFontOfSize:14];
    _totalPriceLabel.textColor = lhredColorStr;
    [lowView addSubview:_totalPriceLabel];
    
    _servicePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, DeviceMaxWidth-190, 12)];
    _servicePriceLabel.textAlignment = NSTextAlignmentRight;
    _servicePriceLabel.font = [UIFont systemFontOfSize:12];
    _servicePriceLabel.textColor = lhcontentTitleColorStr2;
    [lowView addSubview:_servicePriceLabel];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(DeviceMaxWidth-80, 0, 80, 49);
    _submitBtn.backgroundColor = lhmainColor;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [lowView addSubview:_submitBtn];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
