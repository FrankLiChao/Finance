//
//  FrankTuanGouView.m
//  SCFinance
//
//  Created by lichao on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankTuanGouView.h"
#import "FrankTools.h"
#import "FrankAutoLayout.h"
#import "FrankTgDetailsView.h"
#import "FrankDetailsView.h"
#import "FrankPopView.h"
#import "lhMainRequest.h"
#import "lhHubLoading.h"
#import "MJRefresh.h"
#import "FrankGroupView.h"
#import "lhUserProtocolViewController.h"


@interface FrankTuanGouView ()<rightBtnDelegate>
{
    UIScrollView *myScrollView;
    UILabel *showTime;  //显示倒计时
    NSTimer *myTimer;   //定时器
    NSDictionary *tgData; //详情数据
    NSInteger timeCount;    //倒计时
    NSArray *picName;
    UIButton *bmButton; //报名按钮
}

@end

@implementation FrankTuanGouView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"团购详情" isBackBtn:YES rightBtn:nil];
    nb.delegate = self;
    [self.view addSubview:nb];
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [self requestTuanGouData];
}

-(void)backBtnEvent
{
    [self.navigationController popViewControllerAnimated:YES];
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
}

-(void)requestTuanGouData
{
    NSDictionary *dic = @{@"productGroupBuyId":self.groupBuyId,
                          @"userId":[lhUserModel shareUserModel].userId
                          };
    FLLog(@"%@",dic);
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"product_groupPurchaseDetail") parameters:dic method:@"POST" success:^(id responseObject)
    {
        FLLog(@"%@",responseObject);
        tgData = [[NSDictionary alloc] initWithDictionary:responseObject];
        if (tgData.count) {
            [self initFrameView];
        }
        [lhHubLoading disAppearActivitiView];
    }fail:^(id error){
        [lhMainRequest checkRequestFail:error];
        [lhHubLoading disAppearActivitiView];
    }];
}

-(void)initFrameView
{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = lhviewColor;
    [self.view addSubview:myScrollView];
    
    CGFloat hight = 0;
    
    UILabel *tglcLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 100*widthRate, 30*widthRate)];
    tglcLab.text = @"团购流程";
    tglcLab.font = [UIFont systemFontOfSize:13];
    tglcLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:tglcLab];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-26*widthRate, 7*widthRate, 16*widthRate, 16*widthRate)];
    imageV.layer.cornerRadius = 8*widthRate;
    imageV.layer.masksToBounds = YES;
    [imageV setImage:imageWithName(@"questionpicture")];
    [myScrollView addSubview:imageV];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, 0, 40*widthRate, 30*widthRate);
    [imageBtn addTarget:self action:@selector(clickImageEvent) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:imageBtn];
    
    hight += 30*widthRate;
    
    UIView *pcView =[[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 105*widthRate)];
    pcView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:pcView];
    
    NSInteger orderStatus = 0;
    if ([[tgData objectForKey:@"isSign"] integerValue] == 1) {
        orderStatus = [[tgData objectForKey:@"orderStatus"] integerValue];
    }
    if (orderStatus>4) {
        orderStatus = 4;
    }else if (orderStatus<0){
        orderStatus = 0;
    }
    NSArray *picA = @[@"tuangouweibaoming",@"baomingpicture",@"suodingjiagepicture",@"zhifuweikuanpicture",@"zizhutihuopicture"];
    UIImageView *picImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 18*widthRate, DeviceMaxWidth-30*widthRate, 46*widthRate)]
    ;
    [picImage setImage:imageWithName(picA[orderStatus])];
    [pcView addSubview:picImage];
    picName = @[@"报名",@"支付定金",@"支付尾款",@"自主提货"];
    CGFloat nameWith = (DeviceMaxWidth-30*widthRate)/picName.count;
    for (int i=0; i<picName.count; i++) {
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate+i*nameWith, 68*widthRate, nameWith, 20*widthRate)];
        nameLable.text = picName[i];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:13];
        nameLable.textColor = lhcontentTitleColorStr2;
        [pcView addSubview:nameLable];
        if (i < orderStatus && orderStatus != 0) {
            nameLable.textColor = lhmainColor;
        }
    }
    
    hight += 105*widthRate;
    
    UILabel *deteilsLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 30*widthRate)];
    deteilsLab.text = @"详细信息";
    deteilsLab.font = [UIFont systemFontOfSize:13];
    deteilsLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:deteilsLab];
    
    hight += 30*widthRate;
    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 130*widthRate)];
    detailView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:detailView];
    
    UILabel *oilDetail = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    oilDetail.text = [NSString stringWithFormat:@"%@ %@",[tgData objectForKey:@"name"],[tgData objectForKey:@"oilName"]];
    oilDetail.font = [UIFont systemFontOfSize:15];
    oilDetail.textColor = lhcontentTitleColorStr;
    [detailView addSubview:oilDetail];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",[tgData objectForKey:@"currentPromotion"]];
    NSString *totalStr = [NSString stringWithFormat:@"自提价：%@元/吨",priceStr];
    UILabel *nowPrice = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 55*widthRate, 180*widthRate, 20*widthRate)];
    nowPrice.font = [UIFont systemFontOfSize:12];
    nowPrice.textColor = lhcontentTitleColorStr2;
    nowPrice.attributedText = [FrankTools setFontColorSize:[UIFont systemFontOfSize:18] WithColor:lhredColorStr WithString:totalStr WithRange:NSMakeRange(totalStr.length-priceStr.length-3, priceStr.length)];
    [detailView addSubview:nowPrice];
    
    NSString *nowPriceStr = [NSString stringWithFormat:@"%ld",(long)[[tgData objectForKey:@"price"] integerValue]-[[tgData objectForKey:@"currentPromotion"] integerValue]];
    NSString *nowTotalStr = [NSString stringWithFormat:@"当前优惠：%@元/吨",nowPriceStr];
    UILabel *preferent = [[UILabel alloc] initWithFrame:CGRectMake(180*widthRate, 55*widthRate, DeviceMaxWidth-190*widthRate, 20*widthRate)];
    preferent.font = [UIFont systemFontOfSize:12];
    preferent.textAlignment = NSTextAlignmentRight;
    preferent.textColor = lhcontentTitleColorStr2;
    preferent.attributedText = [FrankTools setFontColorSize:[UIFont systemFontOfSize:18] WithColor:lhredColorStr WithString:nowTotalStr WithRange:NSMakeRange(nowTotalStr.length-nowPriceStr.length-3, nowPriceStr.length)];
    [detailView addSubview:preferent];
    
    NSTimeInterval deadline = [[tgData objectForKey:@"deadline"] longLongValue]/1000;
    NSTimeInterval systemTime = [[tgData objectForKey:@"systemTime"] longLongValue]/1000;
    timeCount = deadline-systemTime;
    
    showTime = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 95*widthRate, 150*widthRate, 20*widthRate)];
//    showTime.text = @"还剩1天 23:27:28";
    showTime.font = [UIFont systemFontOfSize:12];
    showTime.textColor = lhcontentTitleColorStr;
    [detailView addSubview:showTime];
    
    [self dealWithTime:timeCount];
    
    if (!myTimer) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(myTimerEvent) userInfo:nil repeats:YES];
    }
    
    UILabel *bmNumber = [[UILabel alloc] initWithFrame:CGRectMake(165*widthRate, 95*widthRate, DeviceMaxWidth-175*widthRate, 20*widthRate)];
    bmNumber.text = [NSString stringWithFormat:@"已有%ld人报名",(long)[[tgData objectForKey:@"signNumber"] integerValue]];
    bmNumber.font = [UIFont systemFontOfSize:12];
    bmNumber.textAlignment = NSTextAlignmentRight;
    bmNumber.textColor = lhcontentTitleColorStr;
    [detailView addSubview:bmNumber];
    
    hight += 130*widthRate;
    
    UILabel *guizeLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 30*widthRate)];
    guizeLab.text = @"购买规则";
    guizeLab.font = [UIFont systemFontOfSize:13];
    guizeLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:guizeLab];
    
    hight += 30*widthRate;
    
    UIView *gmView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 50*widthRate)];
    gmView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:gmView];
    
    UILabel *fapiao = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 100*widthRate, 50*widthRate)];
    fapiao.text = @"购买须知";
    fapiao.font = [UIFont systemFontOfSize:15];
    fapiao.textColor = lhcontentTitleColorStr;
    [gmView addSubview:fapiao];
    
    UIImageView *jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-18*widthRate, 21*widthRate, 8*widthRate, 8*widthRate)];
    [jiantou setImage:imageWithName(@"youjiantouImage")];
    [gmView addSubview:jiantou];
    
    UIButton *gbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gbButton.frame = CGRectMake(0, 0, DeviceMaxWidth, 50*widthRate);
    [gbButton addTarget:self action:@selector(clickGmEvent) forControlEvents:UIControlEventTouchUpInside];
    [gmView addSubview:gbButton];
    
    hight += 60*widthRate;
    
    UIView *gBuyView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 325*widthRate)];
    gBuyView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:gBuyView];
    
    [self createGBuyView:gBuyView];
    
    hight += 335*widthRate;
    
    UIView *bmView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight-45*widthRate, DeviceMaxWidth, 45*widthRate)];
    bmView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bmView];
    
    CGFloat mString = [[tgData objectForKey:@"payDeposit"] floatValue];
    NSString *str = nil;
    UILabel *djLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 140, 45*widthRate)];
    djLable.textAlignment = NSTextAlignmentCenter;
    djLable.font = [UIFont systemFontOfSize:15];
    djLable.adjustsFontSizeToFitWidth = YES;
    djLable.textColor = lhcontentTitleColorStr;
    
    if ([[tgData objectForKey:@"isSign"] integerValue] == 1) {
        str = [NSString stringWithFormat:@"订金: %0.2f元",mString];
        djLable.attributedText = [FrankTools setFontColor:lhredColorStr WithString:str WithRange:NSMakeRange(3, str.length-3)];
    }else{
        NSString *strValue = [FrankTools floatStringZero:[NSString stringWithFormat:@"%f",mString*100]];
        str = [NSString stringWithFormat:@"订金 = 油款总价 x %@%%",strValue];
        djLable.attributedText = [FrankTools setFontColor:lhredColorStr WithString:str WithRange:NSMakeRange(4, str.length-4)];
    }
    [bmView addSubview:djLable];
    
    bmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bmButton.frame = CGRectMake(160, 0, DeviceMaxWidth-160, 45*widthRate);
    bmButton.backgroundColor = lhmainColor;
    [bmButton setTitle:[NSString stringWithFormat:@"%@",timeCount>0?@"确定报名":@"已截止"] forState:UIControlStateNormal];
    [bmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bmButton addTarget:self action:@selector(clickConfirmEvent) forControlEvents:UIControlEventTouchUpInside];
    [bmView addSubview:bmButton];
    if ([[tgData objectForKey:@"isSign"] integerValue] == 1) {
        [bmButton setTitle:@"已报名" forState:UIControlStateNormal];
    }else{
        [bmButton setTitle:@"确定报名" forState:UIControlStateNormal];
    }
}

-(void)createGBuyView:(UIView *)bgView
{
    CGFloat heit = 10*widthRate;
    UILabel *tLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heit, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    tLable.text = @"买得越多优惠越多";
    tLable.textColor = lhcontentTitleColorStr;
    tLable.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:tLable];
    
    heit += 25*widthRate;

    NSString *nowPriceStr = [NSString stringWithFormat:@"%@元/吨",[tgData objectForKey:@"price"]];
    NSString *midString = [NSString stringWithFormat:@"今日%@挂牌价：%@",[tgData objectForKey:@"name"],nowPriceStr];
    UILabel *midTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heit, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    midTitle.textColor = lhcontentTitleColorStr1;
    midTitle.font = [UIFont systemFontOfSize:13];
    midTitle.attributedText = [FrankTools setFontColor:lhredColorStr WithString:midString WithRange:NSMakeRange(midString.length-nowPriceStr.length, nowPriceStr.length)];
    [bgView addSubview:midTitle];
    
    heit += 30*widthRate;
    
    NSArray *titleA = @[@"购买量(吨)",@"优惠金额(元/吨)",@"成交价(元/吨)"];
    NSArray *tabListA = [tgData objectForKey:@"dataPrivateList"];
    NSMutableArray *buyCountA = [NSMutableArray new];
    NSMutableArray *saveMoneyA = [NSMutableArray new];
    NSMutableArray *nowPriceA = [NSMutableArray new];
    for (int i=0; i<tabListA.count; i++) {
        NSDictionary *dic = tabListA[i];
        if (i == tabListA.count-1) {
            [buyCountA addObject:[NSString stringWithFormat:@"%@≤A",[dic objectForKey:@"amountStart"]]];
        }else{
            [buyCountA addObject:[NSString stringWithFormat:@"%@≤A<%@",[dic objectForKey:@"amountStart"],[dic objectForKey:@"amountEnd"]]];
        }
        [saveMoneyA addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"tonOfferMoney"]]];
        [nowPriceA addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"currentPromotion"]]];
    }
    
    CGFloat withOfTitle = (DeviceMaxWidth-20*widthRate-1)/3;
    for (int i=0; i<titleA.count; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate+withOfTitle*i+0.5*i, heit, withOfTitle, 40*widthRate)];
        titleLab.text = titleA[i];
        titleLab.textColor = lhcontentTitleColorStr1;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = [UIColor colorFromHexRGB:@"ebf1f5"];
        titleLab.font = [UIFont systemFontOfSize:14];
        
        [bgView addSubview:titleLab];
        
        for (int j=0; j<buyCountA.count; j++)
        {
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heit+40*widthRate+0.5+j*40*widthRate+j*0.5, withOfTitle, 40*widthRate)];
            contentLab.text = buyCountA[j];
            contentLab.textColor = lhcontentTitleColorStr1;
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.backgroundColor = [UIColor colorFromHexRGB:@"f7fafc"];
            contentLab.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:contentLab];
            
            UILabel *saveMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate+withOfTitle+0.5, heit+40*widthRate+0.5+j*40*widthRate+j*0.5, withOfTitle, 40*widthRate)];
            saveMoneyLab.text = saveMoneyA[j];
            saveMoneyLab.textColor = lhcontentTitleColorStr1;
            saveMoneyLab.textAlignment = NSTextAlignmentCenter;
            saveMoneyLab.backgroundColor = [UIColor colorFromHexRGB:@"f7fafc"];
            saveMoneyLab.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:saveMoneyLab];
            
            UILabel *nowPriceLab = [[UILabel alloc] initWithFrame:CGRectMake( 10*widthRate+withOfTitle*2+0.5*2,heit+40*widthRate+0.5+j*40*widthRate+j*0.5, withOfTitle, 40*widthRate)];
            nowPriceLab.text = nowPriceA[j];
            nowPriceLab.textColor = lhcontentTitleColorStr1;
            nowPriceLab.textAlignment = NSTextAlignmentCenter;
            nowPriceLab.backgroundColor = [UIColor colorFromHexRGB:@"f7fafc"];
            nowPriceLab.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:nowPriceLab];
        }
    }
    
    heit += 40*widthRate + buyCountA.count*40*widthRate + buyCountA.count*0.5 + 10*widthRate;
    
    UILabel *smLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heit, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    smLab.text = @"声明：";
    smLab.font = [UIFont systemFontOfSize:13];
    smLab.textColor = lhcontentTitleColorStr;
    [bgView addSubview:smLab];
    
    heit += 25*widthRate;
    
    NSString *tuangStr = [NSString stringWithFormat:@"1、若本次团购未达到预定的%@吨，则本次团购自动取消。您的订金或尾款将在2个工作日内退换给您。\n2、除非特别说明，优品购油宝所有团购成交价均不含运费。",[tgData objectForKey:@"minVolume"]];
    UILabel *detailsLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, heit, DeviceMaxWidth-20*widthRate, 50)];
    detailsLable.font = [UIFont systemFontOfSize:11];
    detailsLable.textColor = lhcontentTitleColorStr2;
    detailsLable.attributedText = [FrankTools setLineSpaceing:4 WithString:tuangStr WithRange:NSMakeRange(0, tuangStr.length)];
    detailsLable.numberOfLines = 0;
    detailsLable.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:detailsLable];
    
    heit += detailsLable.frame.size.height + 10*widthRate;
    
    CGRect rect = bgView.frame;
    rect.size.height = heit;
    bgView.frame = rect;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heit+bgView.frame.origin.y+45*widthRate+10*widthRate);
}

-(void)clickGmEvent
{
    NSString * aStr = @"http://www.gou-you.com/purchaseNote.html";
    lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
    upVC.titleStr = @"购买须知";
    upVC.urlStr = aStr;
    [self.navigationController pushViewController:upVC animated:YES];
}

- (void)dealWithTime:(NSInteger)timeNumber
{
    NSInteger day = timeNumber/(24*3600);
    NSInteger hour = (timeNumber%(24*3600))/3600;
    NSInteger minutes = (timeNumber%3600)/60;
    NSInteger seconds = timeNumber%60;
    
    NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString * hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    if (hour < 10 && hour > 0) {
        hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    NSString * minutesStr = [NSString stringWithFormat:@"%ld",(long)minutes];
    if (minutes < 10 && minutes > 0) {
        minutesStr = [NSString stringWithFormat:@"0%@",minutesStr];
    }
    NSString * secondsStr = [NSString stringWithFormat:@"%ld",(long)seconds];
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%@",secondsStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeNumber>0) {
            if(day <= 0){
                showTime.text = [NSString stringWithFormat:@"还剩 %@小时%@分%@秒",hourStr,minutesStr,secondsStr];
//                tpLabel.text = [NSString stringWithFormat:@"还剩 %@:%@:%@",hourStr,minutesStr,secondsStr];
            }
            else{
                showTime.text = [NSString stringWithFormat:@"还剩%@天 %@:%@:%@",dayStr,hourStr,minutesStr,secondsStr];
                
//                tpLabel.text = [NSString stringWithFormat:@"还剩%@天 %@:%@:%@",dayStr,hourStr,minutesStr,secondsStr];
            }
        }else
        {
            showTime.text = [NSString stringWithFormat:@"已截止"];
            [bmButton setTitle:@"已截止" forState:UIControlStateNormal];
        }
    });
}

-(void)myTimerEvent
{
    timeCount--;
    if (timeCount > 0) {
        [self dealWithTime:timeCount];
    }else
    {
        if (myTimer) {
            [myTimer invalidate];
            myTimer = nil;
        }
    }
}

-(void)drawPicture:(UIView *)oneView withNowValue:(NSInteger)nowValue withNowArray:(NSArray *)newArray withMoneyArray:(NSArray *)moneyArray
{
//    FLLog(@"%ld",nowValue);
    if (!newArray.count || !moneyArray.count) {
        return;
    }
    NSInteger maxValue = [newArray[newArray.count-1] integerValue];
    CGFloat miniValue = (DeviceMaxWidth-20*widthRate)/10;
    CGFloat pointLenth = 0;
    CGRect tempRect;
    CGRect saveRect;
    NSInteger tagValue = 0;
    for (int i=0; i<newArray.count; i++) {
        UILabel *topLable = [UILabel new];
        topLable.text = [NSString stringWithFormat:@"%@元",moneyArray[i]];
        topLable.textColor = lhcontentTitleColorStr2;
        topLable.font = [UIFont systemFontOfSize:12];
        [oneView addSubview:topLable];
        CGFloat topWith = [FrankTools sizeForString:topLable.text withSizeOfFont:[UIFont systemFontOfSize:12]];
        
        UILabel *bomLable = [UILabel new];
        bomLable.text = [NSString stringWithFormat:@"%@吨",newArray[i]];
        bomLable.textColor = lhcontentTitleColorStr2;
        bomLable.font = [UIFont systemFontOfSize:12];
        [oneView addSubview:bomLable];
        CGFloat bomWith = [FrankTools sizeForString:bomLable.text withSizeOfFont:[UIFont systemFontOfSize:12]];
        
        UILabel *point = [UILabel new];
        point.layer.cornerRadius = 5*widthRate;
        point.layer.masksToBounds = YES;
        point.backgroundColor = [UIColor colorFromHexRGB:@"febc43"];
        [oneView addSubview:point];
        
        if (i == 0)
        {
            topLable.frame = CGRectMake(10*widthRate, 5*widthRate, topWith, 15*widthRate);
            topLable.textAlignment = NSTextAlignmentLeft;
            point.frame = CGRectMake(10*widthRate, 20*widthRate, 10*widthRate, 10*widthRate);
            bomLable.frame = CGRectMake(10*widthRate, 30*widthRate, bomWith, 15*widthRate);
            
        }
        else if (i == newArray.count-1)
        {
            topLable.frame = CGRectMake(DeviceMaxWidth-10*widthRate-topWith, 5*widthRate, topWith, 15*widthRate);
            point.frame = CGRectMake(DeviceMaxWidth-20*widthRate, 20*widthRate, 10*widthRate, 10*widthRate);
            bomLable.frame = CGRectMake(DeviceMaxWidth-10*widthRate-bomWith, 30*widthRate, bomWith, 15*widthRate);
        }
        else
        {
            pointLenth = 10*widthRate+([newArray[i] floatValue])/maxValue*(DeviceMaxWidth-20*widthRate);
            miniValue = tempRect.origin.x + tempRect.size.width;
            if (miniValue >= pointLenth-(topWith/2)) {
                tempRect.origin.x = miniValue;
            }else{
                tempRect.origin.x = pointLenth-(topWith/2);
            }
            if (i == newArray.count-2) { //对倒数第二个点进行位置处理
                CGFloat lastLenth = [FrankTools sizeForString:[NSString stringWithFormat:@"%@",newArray[newArray.count-1]] withSizeOfFont:[UIFont systemFontOfSize:12]];
                if (tempRect.origin.x+topWith > DeviceMaxWidth-12*widthRate-lastLenth) {
                    tempRect.origin.x = DeviceMaxWidth-12*widthRate-lastLenth-topWith;
                }
            }
            
            tempRect.size.width = topWith;
            topLable.frame = tempRect;
            
            point.sd_layout
            .centerXEqualToView(topLable)
            .yIs(20*widthRate)
            .widthIs(10*widthRate)
            .heightIs(10*widthRate);
            
            bomLable.sd_layout
            .centerXEqualToView(topLable)
            .yIs(30*widthRate)
            .heightIs(15*widthRate)
            .widthIs(bomWith);
        }
        UIView *lineV = [UIView new];
        lineV.backgroundColor = [UIColor colorFromHexRGB:@"febc43"];
        [oneView addSubview:lineV];
        UIView *lineVV = [UIView new];
        lineVV.backgroundColor = tableDefSepLineColor;
        [oneView addSubview:lineVV];
        if (nowValue == [newArray[i] integerValue]) {
            tagValue++;
            lineV.frame = CGRectMake(10*widthRate, 24*widthRate, topLable.frame.origin.x+topLable.frame.size.width/2, 2);
            lineVV.sd_layout
            .leftSpaceToView(point,0)
            .topSpaceToView(oneView,24*widthRate)
            .rightSpaceToView(oneView,10*widthRate)
            .heightIs(2);
            topLable.textColor = lhlineColor;
            bomLable.textColor = lhlineColor;
        }
        if (nowValue < [newArray[i] integerValue] && nowValue >= [newArray[0] integerValue]) {
            point.backgroundColor = tableDefSepLineColor;
            if (tagValue == 0) {
                CGFloat a = (nowValue-[newArray[i-1] floatValue])/([newArray[i] floatValue]-[newArray[i-1] floatValue]);
                CGFloat b = ((topLable.frame.origin.x+topLable.frame.size.width/2-10*widthRate) - (saveRect.origin.x+saveRect.size.width/2-10*widthRate));
                CGFloat offset = a*b;
                lineV.frame = CGRectMake(10*widthRate, 24*widthRate, (saveRect.origin.x+saveRect.size.width/2-10*widthRate)+offset, 2);
                lineVV.frame = CGRectMake(lineV.frame.size.width+10*widthRate, 24*widthRate, DeviceMaxWidth-lineV.frame.size.width-30*widthRate, 2);
            }
            tagValue ++;
        }
        if (nowValue > maxValue) {
            lineV.frame = CGRectMake(10*widthRate, 24*widthRate, DeviceMaxWidth-20*widthRate, 2);
            lineVV.frame = CGRectMake(10*widthRate, 24*widthRate, 0, 2);
            if (i == newArray.count-1) {
                topLable.textColor = lhlineColor;
                bomLable.textColor = lhlineColor;
            }
        }
        if (nowValue < [newArray[0] integerValue]) {
            lineV.frame = CGRectMake(10*widthRate, 24*widthRate, 0, 2);
            lineVV.frame = CGRectMake(10*widthRate, 24*widthRate, DeviceMaxWidth-20*widthRate, 2);
            point.backgroundColor = tableDefSepLineColor;
        }
        if (nowValue > [newArray[i] integerValue] && i<newArray.count-1 && nowValue < [newArray[i+1] integerValue]) {
            topLable.textColor = lhlineColor;
            bomLable.textColor = lhlineColor;
        }
        tempRect = topLable.frame;
        saveRect = topLable.frame;
    }
}

-(void)clickConfirmEvent
{
    FLLog(@"确定报名");
    NSArray *invoiceA = [tgData objectForKey:@"invoice"];
    NSArray *motorcadeA = [tgData objectForKey:@"motorcade"];
    if ([bmButton.titleLabel.text isEqualToString:@"确定报名"]) {
        if (!invoiceA.count) {
            invoiceA = @[];
        }
        if (!motorcadeA.count) {
            motorcadeA = @[];
        }
        FrankTgDetailsView *tgView = [FrankTgDetailsView new];
        NSInteger process = 0;
        if ([[tgData objectForKey:@"isSign"] integerValue] == 1) {
            process = [[tgData objectForKey:@"orderStatus"] integerValue];
        }
        tgView.tgDataDic = tgData;
        [self.navigationController pushViewController:tgView animated:YES];
    }else if ([bmButton.titleLabel.text isEqualToString:@"已报名"]) {
        FrankGroupView *groupV = [FrankGroupView new];
        [self.navigationController pushViewController:groupV animated:YES];
    }else{
        [lhUtilObject showAlertWithMessage:@"该团购已截止~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    }
}

-(void)clickImageEvent
{
    FLLog(@"团购流程");
    FrankPopView *popView = [[FrankPopView alloc] initWithFrame:self.view.bounds withType:0];
    popView.nameArray = picName;
    [self.view addSubview:popView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 UIView *tuanGView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 160*widthRate)];
 tuanGView.backgroundColor = [UIColor whiteColor];
 [myScrollView addSubview:tuanGView];
 
 UILabel *youhui1 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
 youhui1.text = @"团购优惠第一重：";
 youhui1.font = [UIFont systemFontOfSize:15];
 youhui1.textColor = lhcontentTitleColorStr;
 [tuanGView addSubview:youhui1];
 
 UILabel *buyLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
 buyLab.text = @"大家一起买，买得越多越优惠！";
 buyLab.font = [UIFont systemFontOfSize:12];
 buyLab.textColor = lhcontentTitleColorStr2;
 [tuanGView addSubview:buyLab];
 
 UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 70*widthRate, DeviceMaxWidth, 50*widthRate)];
 [tuanGView addSubview:oneView];
 FLLog(@"%@",tgData);
 //第一重数组
 NSArray *dArray = [tgData objectForKey:@"dataIntervalList"];
 
 NSInteger nowDun = [[tgData objectForKey:@"purchaseTotal"] integerValue];
 //    NSArray *youArray = @[@"-￥100",@"-￥240"];
 //    NSArray *nowArray = @[@"0",@"10000"];
 NSMutableArray *youArray = [[NSMutableArray alloc] init];
 NSMutableArray *nowArray = [[NSMutableArray alloc] init];
 for (int i=0; i<dArray.count; i++) {
 [youArray addObject:[dArray[i] objectForKey:@"discountPrice"]];
 [nowArray addObject:[dArray[i] objectForKey:@"amountStart"]];
 }
 
 [self drawPicture:oneView withNowValue:nowDun withNowArray:nowArray withMoneyArray:youArray];
 
 UILabel *peopleL = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 130*widthRate, 150*widthRate, 20*widthRate)];
 peopleL.text = [NSString stringWithFormat:@"已有%ld人报名",(long)[[tgData objectForKey:@"signNumber"] integerValue]];
 peopleL.font = [UIFont systemFontOfSize:13];
 peopleL.textColor = lhcontentTitleColorStr;
 [tuanGView addSubview:peopleL];
 
 UILabel *ybmLab = [[UILabel alloc] initWithFrame:CGRectMake(165*widthRate, 130*widthRate, 200*widthRate, 20*widthRate)];
 ybmLab.text = [NSString stringWithFormat:@"已团购：%@吨",[tgData objectForKey:@"purchaseTotal"]];
 ybmLab.font = [UIFont systemFontOfSize:13];
 ybmLab.textAlignment = NSTextAlignmentRight;
 ybmLab.textColor = lhcontentTitleColorStr;
 [tuanGView addSubview:ybmLab];
 
 hight += 170*widthRate;
 
 UIView *tuanGView1 = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 130*widthRate)];
 tuanGView1.backgroundColor = [UIColor whiteColor];
 [myScrollView addSubview:tuanGView1];
 
 UILabel *youhui2 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
 youhui2.text = @"团购优惠第二重：";
 youhui2.font = [UIFont systemFontOfSize:15];
 youhui2.textColor = lhcontentTitleColorStr;
 [tuanGView1 addSubview:youhui2];
 
 UILabel *buyLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
 buyLab2.text = @"单人买得越多，在团购价的基础上再优惠！";
 buyLab2.font = [UIFont systemFontOfSize:12];
 buyLab2.textColor = lhcontentTitleColorStr2;
 [tuanGView1 addSubview:buyLab2];
 
 UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, 70*widthRate, DeviceMaxWidth, 50*widthRate)];
 [tuanGView1 addSubview:twoView];
 
 //第二重数组
 NSArray *pArray = [tgData objectForKey:@"dataPrivateList"];
 
 NSInteger nowValue = [[tgData objectForKey:@"userPurChaseNum"] integerValue];
 NSMutableArray *moneyArray = [[NSMutableArray alloc] init];
 NSMutableArray *nwArray = [[NSMutableArray alloc] init];
 for (int i=0; i<pArray.count; i++) {
 [moneyArray addObject:[pArray[i] objectForKey:@"tonOfferMoney"]];
 [nwArray addObject:[pArray[i] objectForKey:@"amountStart"]];
 }
 [self drawPicture:twoView withNowValue:nowValue withNowArray:nwArray withMoneyArray:moneyArray];
 
 hight += 135*widthRate+5*widthRate;
 
 NSString *tuangStr = [NSString stringWithFormat:@"团购销售服务由博晟创信科技有限公司提供，该公司的\n加盟热线为：%@",ourServicePhone];
 UILabel *detailsLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 50*widthRate)];
 detailsLable.font = [UIFont systemFontOfSize:11];
 detailsLable.textColor = lhcontentTitleColorStr2;
 detailsLable.numberOfLines = 2;
 detailsLable.attributedText = [FrankTools setLineSpaceing:4 WithString:tuangStr WithRange:NSMakeRange(0, tuangStr.length)];
 detailsLable.textAlignment = NSTextAlignmentCenter;
 [myScrollView addSubview:detailsLable];
 
 hight += 100*widthRate;
 */
//    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight+45*widthRate);
@end
