//
//  FrankDirectOrderView.m
//  SCFinance
//
//  Created by lichao on 16/6/12.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankDirectOrderView.h"
#import "lhFirmOrderTableViewCell.h"
#import "FrankTools.h"
#import "FrankAutoLayout.h"
#import "FrankPopView.h"
#import "FrankOilView.h"
#import "MJRefresh.h"

@interface FrankDirectOrderView ()<rightBtnDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    UIScrollView *myScrollView;
    UITableView *myTableView;
    NSArray *picName;
    NSTimer *myTimer;
    UILabel *statusLable;
    NSInteger timeCount;
    NSDictionary *dataDic;
    lhNavigationBar *tempBar;
    
    NSInteger showMessage;
}

@end

@implementation FrankDirectOrderView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *rightStr = nil;
    if (_type == 1) {
        rightStr = nil;
    }else{
        rightStr = @"取消订单";
    }
    lhNavigationBar * tBar = [[lhNavigationBar alloc]initWithVC:self title:@"订单详情" isBackBtn:YES rightBtn:rightStr];
    tempBar = tBar;
    tBar.delegate = self;
    [self.view addSubview:tBar];
    [tBar mergeRightButton:nil];
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [self getDetailData];
//    [self initFrameView];
}

//获取直购详情
-(void)getDetailData{
    NSString *userId = [lhUserModel shareUserModel].userId;
    NSDictionary *dic = @{@"userId":userId,
                          @"orderId":_orderId,
                          @"type":[NSString stringWithFormat:@"%ld",(long)_type]};
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_directDetail") parameters:dic method:@"POST" success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        dataDic = responseObject;
        if (dataDic.count) {
            [self initFrameView];
        }
        [lhHubLoading disAppearActivitiView];
    } fail:^(id error){
        [lhHubLoading disAppearActivitiView];
        [lhMainRequest checkRequestFail:error];
    }];
}

-(void)reloadPage
{
    showMessage = 1;
    [self getDetailData];
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

- (void)dealWithTime:(NSInteger)timeNumber
{
    NSInteger day = timeNumber/(24*3600);
    NSInteger hour = (timeNumber%(24*3600))/3600;
    NSInteger minutes = (timeNumber%3600)/60;
    NSInteger seconds = timeNumber%60;
    
    NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString * hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    NSString * minutesStr = [NSString stringWithFormat:@"%ld",(long)minutes];
    if (minutes < 10) {
        minutesStr = [NSString stringWithFormat:@"0%@",minutesStr];
    }
    NSString * secondsStr = [NSString stringWithFormat:@"%ld",(long)seconds];
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%@",secondsStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeNumber>0) {
            if ([dayStr integerValue] == 0) {
                statusLable.text = [NSString stringWithFormat:@"%@(%@:%@:%@)",[dataDic objectForKey:@"orderName"],hourStr,minutesStr,secondsStr];
            }else
            {
                statusLable.text = [NSString stringWithFormat:@"%@(%@天 %@:%@:%@)",[dataDic objectForKey:@"orderName"],dayStr,hourStr,minutesStr,secondsStr];
            }
        }else
        {
            statusLable.text = [dataDic objectForKey:@"orderName"];
        }
    });
}

#pragma mark - Delegate
-(void)rightBtnEvent
{
    FLLog(@"取消订单");
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定取消订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2;
    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2 && buttonIndex == 1) {//取消订单
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        NSDictionary *dic = @{@"orderId":[NSString stringWithFormat:@"%@",self.orderId]};
        [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"product_cancelDirectPurchase") parameters:dic method:@"POST" success:^(id responseObject) {
            [lhUtilObject showAlertWithMessage:@"取消订单成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [self performSelector:@selector(backMainViewEvent) withObject:nil afterDelay:1.5];
            [lhHubLoading disAppearActivitiView];
        } fail:nil];

    }
}

-(void)backMainViewEvent
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//#pragma mark - 刷新和加载
////下拉刷新
//- (void)headerRefresh
//{
//    [self getDetailData];
//}

-(void)initFrameView
{
    FLLog(@"dataDic%@",dataDic);
    NSInteger orderStatus = [[dataDic objectForKey:@"orderStatus"] integerValue];
    CGFloat hight = 0;
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.backgroundColor = lhviewColor;
    myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
    NSString *cancelReason = [dataDic objectForKey:@"cancelReason"];
    if (orderStatus > 4 && ![cancelReason isEqualToString:@""] && cancelReason != nil) {
        NSString *yjString = [NSString stringWithFormat:@"关闭原因:%@",cancelReason];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
        topView.backgroundColor = [UIColor colorFromHexRGB:@"6f6e9d"];
        [myScrollView addSubview:topView];
        UILabel *yj = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40*widthRate)];
        yj.textColor = [UIColor colorFromHexRGB:@"33324b"];
        yj.text = [NSString stringWithFormat:@"%@",yjString];
        yj.font = [UIFont systemFontOfSize:13];
        yj.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:yj];
        
        hight += 40*widthRate;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 140*widthRate)];
    bgView.backgroundColor = [UIColor colorFromHexRGB:@"33324b"];
    [myScrollView addSubview:bgView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 12*widthRate, 16*widthRate, 16*widthRate)];
    [imageV setImage:imageWithName(@"mineorderImage")];
    [bgView addSubview:imageV];
    
    NSTimeInterval deadline = [[dataDic objectForKey:@"deadline"] longLongValue]/1000;
    NSTimeInterval systemTime = [[dataDic objectForKey:@"systemTime"] longLongValue]/1000;
    timeCount = deadline-systemTime;
    
    statusLable = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 10*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    statusLable.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"orderName"]];
    statusLable.font = [UIFont systemFontOfSize:15];
    statusLable.textColor = [UIColor whiteColor];
    [bgView addSubview:statusLable];
    
    NSInteger isPayEnd = [[dataDic objectForKey:@"isPayEnd"] integerValue];
    if (orderStatus < 4 && isPayEnd != 1) {
        [self dealWithTime:timeCount];
        if (!myTimer) {
            myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(myTimerEvent) userInfo:nil repeats:YES];
        }
    }
    
    UILabel *ddNumber = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 35*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    ddNumber.text = [NSString stringWithFormat:@"订单号：%@",[dataDic objectForKey:@"orderId"]];
    ddNumber.font = [UIFont systemFontOfSize:13];
    ddNumber.textColor = [UIColor whiteColor];
    [bgView addSubview:ddNumber];
    
    CGFloat serviceMoney = [[dataDic objectForKey:@"serviceMoney"] floatValue];
    NSInteger price = 0;
    NSArray *mArray = [dataDic objectForKey:@"listProduct"];
    NSInteger dunNumber = 0;
    NSInteger totalM = 0;
    for (int i=0; i<mArray.count; i++) {
        dunNumber += [[mArray[i] objectForKey:@"purchaseNumber"] integerValue];
        price = [[mArray[i] objectForKey:@"price"] integerValue];
        totalM += price*[[mArray[i] objectForKey:@"purchaseNumber"] integerValue];
    }
    NSString *totalMoney = [NSString stringWithFormat:@"%ld",(long)totalM];
    UILabel *djLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 60*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    djLab.text = [NSString stringWithFormat:@"订单金额：%0.2f元(含服务费%0.2f元)",[totalMoney floatValue]+[totalMoney floatValue]*serviceMoney,[totalMoney floatValue]*serviceMoney];
    djLab.font = [UIFont systemFontOfSize:13];
    djLab.textColor = [UIColor whiteColor];
    [bgView addSubview:djLab];
    
    UILabel *bmTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 85*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    bmTimeLab.text = [NSString stringWithFormat:@"报名时间：%@",[FrankTools LongTimeToString:[dataDic objectForKey:@"createTime"] withFormat:@"YYYY-MM-dd HH:mm:ss"]];
    bmTimeLab.font = [UIFont systemFontOfSize:13];
    bmTimeLab.textColor = [UIColor whiteColor];
    [bgView addSubview:bmTimeLab];
    
    //=4已完成，只显示doPerson
    UILabel *handleLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 110*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    handleLab.text = [NSString stringWithFormat:@"%@%@",(orderStatus==4||orderStatus==5||orderStatus==6)?@"当前状态：":@"当前处理人：",[dataDic objectForKey:@"doPerson"]];
    handleLab.font = [UIFont systemFontOfSize:13];
    handleLab.textColor = [UIColor whiteColor];
    [bgView addSubview:handleLab];
    hight += 140*widthRate;
    
    NSDictionary *motorcade = [dataDic objectForKey:@"motorcade"];
    NSString *driver = [[dataDic objectForKey:@"motorcade"]objectForKey:@"driver"];
    if (![driver isEqualToString:@""] && driver!= nil) {
        UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 135*widthRate)];
        goodsView.backgroundColor = [UIColor whiteColor];
        [myScrollView addSubview:goodsView];
        
        UIImageView *imageVV = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, 20*widthRate, 20*widthRate)];
        [imageVV setImage:imageWithName(@"tihuorenImage")];
        [goodsView addSubview:imageVV];
        
        UILabel *tihuoman = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 10*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
        tihuoman.text = [NSString stringWithFormat:@"提货人：%@",[motorcade objectForKey:@"driver"]];
        tihuoman.font = [UIFont systemFontOfSize:15];
        tihuoman.textColor = lhcontentTitleColorStr;
        [goodsView addSubview:tihuoman];
        
        UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-120*widthRate, 10*widthRate, 110*widthRate, 20*widthRate)];
        phoneNum.text = [NSString stringWithFormat:@"%@",[motorcade objectForKey:@"phone"]];
        phoneNum.font = [UIFont systemFontOfSize:13];
        phoneNum.textAlignment = NSTextAlignmentRight;
        phoneNum.textColor = lhcontentTitleColorStr;
        [goodsView addSubview:phoneNum];
        
        UILabel *carNumLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 35*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
        carNumLab.text = [NSString stringWithFormat:@"车牌号：%@",[motorcade objectForKey:@"plate"]];
        carNumLab.font = [UIFont systemFontOfSize:13];
        carNumLab.textColor = lhcontentTitleColorStr;
        [goodsView addSubview:carNumLab];
        
        UILabel *jiazhaoLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 60*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
        jiazhaoLab.text = [NSString stringWithFormat:@"驾    照：%@",[motorcade objectForKey:@"idCard"]];
        jiazhaoLab.font = [UIFont systemFontOfSize:13];
        jiazhaoLab.textColor = lhcontentTitleColorStr;
        [goodsView addSubview:jiazhaoLab];
        
        UILabel *idCardLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 85*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
        idCardLab.text = [NSString stringWithFormat:@"时    间：%@",[FrankTools LongTimeToString:[motorcade objectForKey:@"date"] withFormat:@"YYYY-MM-dd"]];
        idCardLab.font = [UIFont systemFontOfSize:13];
        idCardLab.textColor = lhcontentTitleColorStr;
        [goodsView addSubview:idCardLab];
        
        UILabel *tdOrderId = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 110*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
        tdOrderId.text = [NSString stringWithFormat:@"提单号：%@",[motorcade objectForKey:@"billOrder"]];
        tdOrderId.font = [UIFont systemFontOfSize:13];
        tdOrderId.textColor = lhcontentTitleColorStr;
        [goodsView addSubview:tdOrderId];
        
        hight += 135*widthRate;
    }
    
    UILabel *tglcLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 30*widthRate)];
    tglcLab.text = @"直购流程";
    tglcLab.font = [UIFont systemFontOfSize:13];
    tglcLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:tglcLab];
    
    UIImageView *imageVV = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-26*widthRate, hight+7*widthRate, 16*widthRate, 16*widthRate)];
    imageVV.layer.cornerRadius = 8*widthRate;
    imageVV.layer.masksToBounds = YES;
    [imageVV setImage:imageWithName(@"questionpicture")];
    [myScrollView addSubview:imageVV];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, hight, 40*widthRate, 30*widthRate);
    [imageBtn addTarget:self action:@selector(clickImageEvent) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:imageBtn];
    
    hight += 30*widthRate;
    
    UIView *pcView = [[UIImageView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 90*widthRate)]
    ;
    pcView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:pcView];
    
    if (orderStatus>5) {
        orderStatus = 5;
    }else if (orderStatus<1){
        orderStatus = 1;
    }
    NSArray *picA = @[@"zhigoutijiaodingdan",@"zhigoujiaofuhuokuan",@"zgchuhuochupiao",@"zgzhizhutihuo",@"zhigouweibaoming"];
    UIImageView *picImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 10*widthRate, DeviceMaxWidth-30*widthRate, 46*widthRate)]
    ;
    [picImage setImage:imageWithName(picA[orderStatus-1])];
    [pcView addSubview:picImage];
    
    picName = @[@"提交订单",@"支付货款",@"出单出票",@"自主提货"];
    CGFloat nameWith = (DeviceMaxWidth-30*widthRate)/picName.count;
    for (int i=0; i<picName.count; i++) {
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate+i*nameWith, 60*widthRate, nameWith, 20*widthRate)];
        nameLable.text = picName[i];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:13];
        nameLable.textColor = lhcontentTitleColorStr2;
        [pcView addSubview:nameLable];
        if (i < orderStatus && orderStatus != 5) {
            nameLable.textColor = lhmainColor;
        }
    }
    
    hight += 90*widthRate;
    
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 30*widthRate)];
    detailLab.text = @"详细信息";
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:detailLab];
    
    hight += 30*widthRate;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 90+75*mArray.count) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;
    myTableView.dataSource = self;
    [myScrollView addSubview:myTableView];
    
    
    hight += myTableView.frame.size.height;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight);
    if (([driver isEqualToString:@""] || driver== nil) && orderStatus<5 && _type == 1) {
        UIButton *oilButton = [UIButton buttonWithType:UIButtonTypeCustom];
        oilButton.frame = CGRectMake(0, DeviceMaxHeight-50*widthRate, DeviceMaxWidth, 50*widthRate);
        [oilButton setTitle:@"我要提油" forState:UIControlStateNormal];
        [oilButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        oilButton.backgroundColor = lhmainColor;
        oilButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [oilButton addTarget:self action:@selector(clickOilButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:oilButton];
    }
    
    if (orderStatus == 1) {
        [tempBar mergeRightButton:@"取消订单"];
    }
    
    if (showMessage == 1) {
        showMessage = 0;
        [lhUtilObject showAlertWithMessage:@"添加提油信息成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    }
}

-(void)clickOilButtonEvent
{
    NSDictionary *dic = [dataDic objectForKey:@"listProduct"][0];
    FrankOilView *popView = [[FrankOilView alloc] initWithFrame:self.view.bounds];
    popView.type = 1;
    popView.directDelegate = self;
    popView.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    popView.oilDetailDic = @{@"name":[dic objectForKey:@"name"],
                             @"oilName":[dic objectForKey:@"name"],
                             @"currentPromotion":[dic objectForKey:@"price"],
                             @"price":[dic objectForKey:@"originalPrice"],
                             @"depotNote":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"depotNote"]],
                             @"purchaseNumber":[dic objectForKey:@"purchaseNumber"]};
    [self.view addSubview:popView];
}

-(void)clickImageEvent
{
    FLLog(@"直购流程");
    FrankPopView *popView = [[FrankPopView alloc] initWithFrame:self.view.bounds withType:1];
    popView.nameArray = picName;
    [self.view addSubview:popView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [dataDic objectForKey:@"listProduct"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
    hView.backgroundColor = [UIColor whiteColor];
    
    UILabel * nLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-110*widthRate, 40)];
    nLabel.font = [UIFont systemFontOfSize:14];
    nLabel.textColor = lhcontentTitleColorStr2;
    nLabel.text = [NSString stringWithFormat:@"订单号：%@",[dataDic objectForKey:@"orderId"]];
    [hView addSubview:nLabel];
    
    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-120*widthRate, 0, 110*widthRate, 40)];
    dataLab.font = [UIFont systemFontOfSize:14];
    dataLab.textColor = lhcontentTitleColorStr2;
    dataLab.textAlignment = NSTextAlignmentRight;
    dataLab.text = [FrankTools LongTimeToString:[dataDic objectForKey:@"createTime"] withFormat:@"YYYY-MM-dd"];
    [hView addSubview:dataLab];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [hView addSubview:lineView];
    
    return hView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * fView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 50)];
    fView.backgroundColor = [UIColor whiteColor];
    
    NSInteger price = 0;
    NSArray *array = [dataDic objectForKey:@"listProduct"];
    NSInteger dunNumber = 0;
    NSInteger totalM = 0;
    for (int i=0; i<array.count; i++) {
        dunNumber += [[array[i] objectForKey:@"purchaseNumber"] integerValue];
        price = [[array[i] objectForKey:@"price"] integerValue];
        totalM += price*[[array[i] objectForKey:@"purchaseNumber"] integerValue];
    }
    NSString *totalMoney = [NSString stringWithFormat:@"%ld",(long)totalM];
    NSString *totalStr = [NSString stringWithFormat:@"共%ld吨  合计: %@",(long)dunNumber,totalMoney];
    UILabel * pLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, DeviceMaxWidth-55, 40)];
    pLabel.textAlignment = NSTextAlignmentRight;
    pLabel.font = [UIFont systemFontOfSize:13];
    pLabel.textColor = lhcontentTitleColorStr2;
    pLabel.attributedText = [FrankTools setFontColorSize:[UIFont systemFontOfSize:15] WithColor:lhredColorStr WithString:totalStr WithRange:NSMakeRange(totalStr.length-totalMoney.length, totalMoney.length)];
    [fView addSubview:pLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [fView addSubview:lineView];
    
    UIView * viewColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, DeviceMaxWidth, 10)];
    viewColorView.backgroundColor = lhviewColor;
    [fView addSubview:viewColorView];
    
    return fView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"firmCell";
    lhFirmOrderTableViewCell * fCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (fCell == nil) {
        fCell = [[lhFirmOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    NSDictionary *dic = [[dataDic objectForKey:@"listProduct"] objectAtIndex:indexPath.row];
    fCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger yjprice = [[dic objectForKey:@"originalPrice"] integerValue];
    NSInteger nprice = [[dic objectForKey:@"price"] integerValue];
    NSInteger dunNumber = [[dic objectForKey:@"purchaseNumber"] integerValue];
    fCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"name"],[dic objectForKey:@"oilName"]];
    fCell.priceLabel.text = [NSString stringWithFormat:@"%ld元/吨",(long)nprice];
    
    //更新
    CGRect rect = fCell.priceLabel.frame;
    rect.size.width = [FrankTools sizeForString:fCell.priceLabel.text withSizeOfFont:[UIFont systemFontOfSize:14]]+4*widthRate;
    fCell.priceLabel.frame = rect;
    fCell.oldPriceLabel.text = [NSString stringWithFormat:@"%ld元",(long)yjprice];
    fCell.oldPriceLabel.sd_layout
    .leftSpaceToView(fCell.priceLabel,10*widthRate)
    .topEqualToView(fCell.priceLabel)
    .heightRatioToView(fCell.priceLabel,1);
    [fCell.oldPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    fCell.oldLineView.sd_layout
    .leftSpaceToView(fCell.oldPriceLabel,1)
    .widthRatioToView(fCell.oldPriceLabel,1);
    //更新
    
    fCell.numLabel.text = [NSString stringWithFormat:@"x%ld",(long)dunNumber];
    
    fCell.totalLabel.text = [NSString stringWithFormat:@"小计：%ld元",(long)nprice*dunNumber];
    fCell.jsLabel.text = [NSString stringWithFormat:@"已省 %ld元",(long)(yjprice-nprice)*dunNumber];
    
    return fCell;
    
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

@end
