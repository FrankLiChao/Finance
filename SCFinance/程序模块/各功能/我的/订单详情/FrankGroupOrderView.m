//
//  FrankGroupOrderView.m
//  SCFinance
//
//  Created by lichao on 16/6/12.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankGroupOrderView.h"
#import "lhMainRequest.h"
#import "lhUtilObject.h"
#import "FrankTools.h"
#import "FrankPopView.h"
#import "FrankAutoLayout.h"
#import "FrankOilView.h"

@interface FrankGroupOrderView ()<rightBtnDelegate,UIAlertViewDelegate>
{
    UIScrollView *myScrollView;
//    UITextField *oilField;
    NSDictionary *dataDic;
    NSArray *picName;
    NSInteger minQuantity;//团购最少订货吨数
    
    NSTimer *myTimer;
    NSInteger timeCount;
    UILabel *statusLable;
    NSInteger orderStatus; //订单状态
    NSInteger showStatus;   //显示进度的状态
    lhNavigationBar * tempBar;
    
    UILabel *messageLab; //消息提示
    UILabel *yjMoney;   //预计金额
    CGFloat serviceMoney;   //服务费费率
    CGFloat price;      //原价
    NSInteger purchaseNumber;//吨数
    CGFloat currentPromotion;//现价
    CGFloat tempHight;
    
    NSInteger showMessage;  //等于1表示添加提油信息成功，用来显示提示信息
}

@end

@implementation FrankGroupOrderView

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
    [self requestData];
}

#pragma mark - Delegate
-(void)rightBtnEvent
{
    FLLog(@"取消报名");
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定取消报名？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2 && buttonIndex == 1) {//取消订单
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        NSString *productGroupSignId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"productGroupSignId"]];
        NSDictionary *dic = @{@"productGroupSignId":productGroupSignId};
        [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"purchase_cancelGroupPurchase") parameters:dic method:@"POST" success:^(id responseObject) {

            [lhUtilObject showAlertWithMessage:@"取消报名成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            
            [self performSelector:@selector(backToMainView) withObject:nil afterDelay:1.5];

            [lhHubLoading disAppearActivitiView];
        } fail:nil];
        
    }
}

-(void)backToMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)requestData
{
    NSString *userId = [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
    NSDictionary *dic = @{@"userId":userId,
                          @"groupBuySignId":self.tgId
                          };
    FLLog(@"%@",dic);
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_groupDetail") parameters:dic method:@"POST" success:^(id responseObject) {
        FLLog(@"responseObject = %@",responseObject);
        dataDic = responseObject;
        [self initData:responseObject];
        [self initFrameView];
    } fail:nil];
}

-(void)reloadPage
{
    showMessage = 1;
    [self requestData];
}

-(void)initData:(NSDictionary *)data
{
    serviceMoney = [[data objectForKey:@"serviceMoney"] floatValue];
    price = [[data objectForKey:@"price"] floatValue];
    currentPromotion = [[data objectForKey:@"currentPromotion"] floatValue];
    purchaseNumber = [[data objectForKey:@"purchaseNumber"] integerValue];
}

-(void)initFrameView
{
    orderStatus = [[dataDic objectForKey:@"orderStatus"] integerValue];
    showStatus = [[dataDic objectForKey:@"showOrderStatus"] integerValue];
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.backgroundColor= lhviewColor;
    [self.view addSubview:myScrollView];
    CGFloat hight = 0;
    NSString *cancelReason = [dataDic objectForKey:@"cancelReason"];
    if (showStatus == 1 || showStatus > 4) {
        NSString *yjString = nil;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 40*widthRate)];
        topView.backgroundColor = [UIColor colorFromHexRGB:@"6f6e9d"];
        [myScrollView addSubview:topView];
        messageLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40*widthRate)];
        messageLab.textColor = [UIColor colorFromHexRGB:@"33324b"];
        messageLab.font = [UIFont systemFontOfSize:13];
        messageLab.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:messageLab];
        if (showStatus == 1) {
            yjString = [NSString stringWithFormat:@"预计：单价:%0.0f元/吨   成交总额:%0.0f元   省:%0.0f元",currentPromotion,currentPromotion*purchaseNumber,(price-currentPromotion)*purchaseNumber];
            messageLab.attributedText = [FrankTools setFontColor:[UIColor whiteColor] WithString:yjString WithRange:NSMakeRange(0, 3)];
        }else{
            yjString = [NSString stringWithFormat:@"关闭原因:%@",cancelReason];
            messageLab.text = [NSString stringWithFormat:@"%@",yjString];
        }
        if (showStatus != 1 && ([cancelReason isEqualToString:@""] || cancelReason == nil)) {
            topView.hidden = YES;
        }else{
            hight += 40*widthRate;
        }
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 165*widthRate)];
    bgView.backgroundColor = [UIColor colorFromHexRGB:@"33324b"];
    [myScrollView addSubview:bgView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 12*widthRate, 16*widthRate, 16*widthRate)];
    [imageV setImage:imageWithName(@"mineorderImage")];
    [bgView addSubview:imageV];
    
    NSTimeInterval deadline = [[dataDic objectForKey:@"deadline"] longLongValue]/1000;
    NSTimeInterval systemTime = [[dataDic objectForKey:@"systemTime"] longLongValue]/1000;
    timeCount = deadline-systemTime;
//    FLLog(@"timeCount = %ld,deadline = %ld,systemTime = %ld",timeCount,deadline,systemTime);
    
    statusLable = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 10*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    statusLable.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"orderName"]];
    statusLable.font = [UIFont systemFontOfSize:15];
    statusLable.textColor = [UIColor whiteColor];
    [bgView addSubview:statusLable];
    
    NSInteger isPayEnd = [[dataDic objectForKey:@"isPayEnd"] integerValue];
    if (showStatus < 4 && isPayEnd != 1) {
        [self dealWithTime:timeCount];
        
        if (!myTimer) {
            myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(myTimerEvent) userInfo:nil repeats:YES];
        }
    }
    
    UILabel *ddNumber = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 35*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    ddNumber.text = [NSString stringWithFormat:@"订单号：%@",self.orderId];
    ddNumber.font = [UIFont systemFontOfSize:13];
    ddNumber.textColor = [UIColor whiteColor];
    [bgView addSubview:ddNumber];
    
    NSString *isPayDeposit = nil;
    if ([[dataDic objectForKey:@"isPayDeposit"] integerValue]==1) {
        isPayDeposit = @"已交";
    }else{
        isPayDeposit = @"未交";
    }
    UILabel *djLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 60*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    djLab.text = [NSString stringWithFormat:@"订金：%@元（%@）",[dataDic objectForKey:@"payDeposit"],isPayDeposit];
    djLab.font = [UIFont systemFontOfSize:13];
    djLab.textColor = [UIColor whiteColor];
    [bgView addSubview:djLab];
    
    NSString *yjStr = nil;
    NSString *totalMoney = [NSString stringWithFormat:@"%0.2f元",currentPromotion*purchaseNumber+currentPromotion*purchaseNumber*serviceMoney];
    if (showStatus < 2) {
        yjStr = [NSString stringWithFormat:@"预计金额：%@(含服务费%0.2f元)",totalMoney,currentPromotion*purchaseNumber*serviceMoney];
    }else{
        yjStr = [NSString stringWithFormat:@"总金额：%@(含服务费%0.2f元)",totalMoney,currentPromotion*purchaseNumber*serviceMoney];
    }
    yjMoney = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 85*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    yjMoney.text = [NSString stringWithFormat:@"%@",yjStr];
    yjMoney.font = [UIFont systemFontOfSize:13];
    yjMoney.textColor = [UIColor whiteColor];
    [bgView addSubview:yjMoney];
    
    UILabel *bmTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 110*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    bmTimeLab.text =  [NSString stringWithFormat:@"报名时间：%@",[FrankTools LongTimeToString:[dataDic objectForKey:@"createTime"] withFormat:@"YYYY-MM-dd HH:mm:ss"]];
    bmTimeLab.font = [UIFont systemFontOfSize:13];
    bmTimeLab.textColor = [UIColor whiteColor];
    [bgView addSubview:bmTimeLab];
    
    //=7已完成，只显示doPerson
    UILabel *handleLab = [[UILabel alloc] initWithFrame:CGRectMake(36*widthRate, 135*widthRate, DeviceMaxWidth-50*widthRate, 20*widthRate)];
    handleLab.text = [NSString stringWithFormat:@"%@%@",(orderStatus==7||orderStatus==8||orderStatus==9)?@"当前状态：":@"当前处理人：",[dataDic objectForKey:@"doPerson"]];
    handleLab.font = [UIFont systemFontOfSize:13];
    handleLab.textColor = [UIColor whiteColor];
    [bgView addSubview:handleLab];
    
    hight += 165*widthRate;
    
    NSDictionary *motorcade = [dataDic objectForKey:@"motorcade"];
    NSString *driver = [motorcade objectForKey:@"driver"];
    if (![driver isEqualToString:@""] && driver != nil) {
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
    tglcLab.text = @"团购流程";
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
    
    if (showStatus>5) {
        showStatus = 5;
    }else if (showStatus<1){
        showStatus = 1;
    }
    NSArray *picA = @[@"baomingpicture",@"suodingjiagepicture",@"zhifuweikuanpicture",@"zizhutihuopicture",@"tuangouweibaoming"];
    UIImageView *picImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 10*widthRate, DeviceMaxWidth-30*widthRate, 46*widthRate)]
    ;
    [picImage setImage:imageWithName(picA[showStatus-1])];
    [pcView addSubview:picImage];
    
    picName = @[@"报名",@"支付定金",@"支付尾款",@"自主提货"];
    CGFloat nameWith = (DeviceMaxWidth-30*widthRate)/picName.count;
    for (int i=0; i<picName.count; i++) {
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate+i*nameWith, 60*widthRate, nameWith, 20*widthRate)];
        nameLable.text = picName[i];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:13];
        nameLable.textColor = lhcontentTitleColorStr2;
        [pcView addSubview:nameLable];
        if (i < showStatus && showStatus != 5) {
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
    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 100*widthRate)];
    detailView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:detailView];
    
    UILabel *oilDetail = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40*widthRate)];
    oilDetail.text = [NSString stringWithFormat:@"%@ %@",[dataDic objectForKey:@"name"],[dataDic objectForKey:@"oilName"]];
    oilDetail.font = [UIFont systemFontOfSize:15];
    oilDetail.textColor = lhcontentTitleColorStr;
    [detailView addSubview:oilDetail];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [detailView addSubview:lineV];
    
    UILabel *buyNumber = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 48*widthRate, 100*widthRate, 20*widthRate)];
    buyNumber.text = @"购买数量";
    buyNumber.font = [UIFont systemFontOfSize:15];
    buyNumber.textColor = lhcontentTitleColorStr;
    [detailView addSubview:buyNumber];
    
    minQuantity = [[dataDic objectForKey:@"minQuantity"] integerValue];
    UILabel *buyDetails = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 72*widthRate, 150*widthRate, 20*widthRate)];
    buyDetails.text = [NSString stringWithFormat:@"本团购最少订货%ld吨",(long)minQuantity];
    buyDetails.font = [UIFont systemFontOfSize:13];
    buyDetails.textColor = lhcontentTitleColorStr2;
    [detailView addSubview:buyDetails];
    
    UILabel *oilNumber = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-100*widthRate, 50*widthRate, 90*widthRate, 39*widthRate)];
    oilNumber.text = [NSString stringWithFormat:@"%@吨",[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"purchaseNumber"]]];
    oilNumber.textColor = lhcontentTitleColorStr;
    oilNumber.textAlignment = NSTextAlignmentRight;
    oilNumber.font = [UIFont systemFontOfSize:15];
    [detailView addSubview:oilNumber];
    
    hight += 100*widthRate;
    
    NSString *yjString = nil;
    UILabel *yujiPrice = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 30*widthRate)];
    if (showStatus == 1) {
        yjString = @"预计价格";
    }
    else{
        yjString = @"支付定金";
    }
    yujiPrice.text = yjString;
    yujiPrice.font = [UIFont systemFontOfSize:13];
    yujiPrice.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:yujiPrice];
    
    hight += 30*widthRate;
    
    [self initPriceView:hight];
    
    if (([driver isEqualToString:@""] || driver == nil) && showStatus < 5 && _type == 1) {
        UIButton *oilButton = [UIButton buttonWithType:UIButtonTypeCustom];
        oilButton.frame = CGRectMake(0, DeviceMaxHeight-50*widthRate, DeviceMaxWidth, 50*widthRate);
        [oilButton setTitle:@"我要提油" forState:UIControlStateNormal];
        [oilButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        oilButton.backgroundColor = lhmainColor;
        oilButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [oilButton addTarget:self action:@selector(clickOilButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:oilButton];
    }
    if (orderStatus==1) {  //orderStatus等于1的时候可以取消订单
        [tempBar mergeRightButton:@"取消订单"];
    }
    if (showMessage == 1) {
        showMessage = 0;
        [lhUtilObject showAlertWithMessage:@"添加提油信息成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    }
}

-(void)clickOilButtonEvent
{
    FrankOilView *popView = [[FrankOilView alloc] initWithFrame:self.view.bounds];
    popView.type = 2;
    popView.groupDelegate = self;
    popView.orderId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"id"]];
    popView.oilDetailDic = @{@"name":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"name"]],
                             @"oilName":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"oilName"]],
                             @"currentPromotion":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"currentPromotion"]],
                             @"depotNote":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"depotNote"]],
                             @"price":[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"price"]],
                             @"purchaseNumber":[dataDic objectForKey:@"purchaseNumber"]};
    [self.view addSubview:popView];
}

-(void)initPriceView:(CGFloat)hight
{
    tempHight = hight;
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 70*widthRate)];
    priceView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:priceView];
    
    UILabel *currentP = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, 80*widthRate, 20*widthRate)];
    currentP.font = [UIFont systemFontOfSize:15];
    currentP.textColor = lhcontentTitleColorStr;
    currentP.text = [NSString stringWithFormat:@"%0.2f元/吨",currentPromotion];
    [priceView addSubview:currentP];
    
    CGRect rect = currentP.frame;
    rect.size.width = [FrankTools sizeForString:currentP.text withSizeOfFont:[UIFont systemFontOfSize:15]];
    currentP.frame = rect;
    
    UILabel *priceL = [UILabel new];
    priceL.font = [UIFont systemFontOfSize:13];
    priceL.text = [NSString stringWithFormat:@"%0.2f元",price];
    priceL.textColor = lhcontentTitleColorStr2;
    [priceView addSubview:priceL];
    
    priceL.sd_layout
    .leftSpaceToView(currentP,5*widthRate)
    .topEqualToView(currentP)
    .heightIs(20*widthRate);
    
    [priceL setSingleLineAutoResizeWithMaxWidth:100];
    
    UILabel *priceLine = [UILabel new];
    priceLine.backgroundColor = lhcontentTitleColorStr2;
    [priceView addSubview:priceLine];
    
    priceLine.sd_layout
    .leftSpaceToView(currentP,5*widthRate)
    .centerYEqualToView(priceL)
    .heightIs(1)
    .widthRatioToView(priceL,1);
    
    UILabel *purchaseL = [UILabel new];
    purchaseL.font = [UIFont systemFontOfSize:13];
    purchaseL.text = [NSString stringWithFormat:@"x%ld",(long)purchaseNumber];
    purchaseL.textColor = lhcontentTitleColorStr2;
    [priceView addSubview:purchaseL];
    
    purchaseL.sd_layout
    .leftSpaceToView(priceView,12*widthRate)
    .topSpaceToView(currentP,5*widthRate)
    .heightIs(15*widthRate)
    .widthIs(100*widthRate);
    
    
    UILabel *xiaoji = [UILabel new];
    xiaoji.text = [NSString stringWithFormat:@"小计：%0.2f元",currentPromotion*purchaseNumber];
    xiaoji.textColor = lhredColorStr;
    xiaoji.font = [UIFont systemFontOfSize:15];
    xiaoji.textAlignment = NSTextAlignmentRight;
    [priceView addSubview:xiaoji];
    
    xiaoji.sd_layout
    .rightSpaceToView(priceView,10*widthRate)
    .topEqualToView(currentP)
    .heightIs(20*widthRate);
    [xiaoji setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *savemoney = [UILabel new];
    savemoney.text = [NSString stringWithFormat:@"已省%0.2f元",(price-currentPromotion)*purchaseNumber];
    savemoney.textColor = lhcontentTitleColorStr2;
    savemoney.font = [UIFont systemFontOfSize:13];
    savemoney.textAlignment = NSTextAlignmentRight;
    [priceView addSubview:savemoney];
    
    savemoney.sd_layout
    .rightSpaceToView(priceView,10*widthRate)
    .topSpaceToView(xiaoji,5*widthRate)
    .heightIs(20*widthRate)
    .widthIs(200);
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, 64+tempHight+80*widthRate);
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
        if (timeNumber > 0) {
            if ([dayStr integerValue] == 0) {
                statusLable.text = [NSString stringWithFormat:@"%@(%@:%@:%@)",[dataDic objectForKey:@"orderName"],hourStr,minutesStr,secondsStr];
            }else
            {
                statusLable.text = [NSString stringWithFormat:@"%@(%@天 %@:%@:%@)",[dataDic objectForKey:@"orderName"],dayStr,hourStr,minutesStr,secondsStr];
            }
            
        }else
        {
            statusLable.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"orderName"]];
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

-(void)clickImageEvent
{
    FLLog(@"团购流程");
    FrankPopView *popView = [[FrankPopView alloc] initWithFrame:self.view.bounds withType:0];
    popView.nameArray = picName;
    [self.view addSubview:popView];
}

//-(void)clickAddButtonEvent
//{
//    if (_type == 1 || orderStatus>3) {
//        return;
//    }
//    NSInteger oilNumber = [oilField.text integerValue];
//    if (oilNumber > 9999) {
//        oilField.text = @"9999";
//        return;
//    }
//    oilField.text = [NSString stringWithFormat:@"%ld",(long)oilNumber+1];
//}

//-(void)clickJianButtonEvent
//{
//    if (_type == 1 || orderStatus>3) {
//        return;
//    }
//    NSInteger oilNumber = [oilField.text integerValue];
//    if (oilNumber == 1) {
//        return;
//    }
//    oilField.text = [NSString stringWithFormat:@"%ld",(long)oilNumber-1];
//}



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
