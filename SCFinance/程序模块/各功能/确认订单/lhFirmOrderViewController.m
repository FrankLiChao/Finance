//
//  lhFirmOrderViewController.m
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhFirmOrderViewController.h"
#import "lhFirmOrderTableViewCell.h"
#import "lhFirmOrderViewModel.h"
#import "lhFirmOrderView.h"
#import "selectCarIdAndFaPiaoTitleDelegate.h"
#import "lhSelectCarIdViewController.h"
#import "FrankSelectFaPiaoView.h"
#import "lhShopCarModel.h"
#import "LHJsonModel.h"
#import "FrankDirectView.h"
#import "lhAlertView.h"
#import "FrankTools.h"

@interface lhFirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,selectCarIdAndFaPiaoTitleDelegate,firmBtnClickProtocol>
{
    UIScrollView * maxScrollView;
    
    UITableView * firmTableView;//
    
    lhFirmOrderView * foView;
    
    NSArray * firmArray;//订单信息
    NSArray * faPiaoArray;//发票信息
    NSArray * carIdArray;//车牌信息
    
    NSDictionary * nowFaPiaoDic;
//    NSDictionary * nowCarIdDic;
}

@end

@implementation lhFirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    foView = [[lhFirmOrderView alloc]initWithFrame:self.view.bounds];
    foView.firmTableView.dataSource = self;
    foView.firmTableView.delegate = self;
    [foView.seleFaPiaoBtn addTarget:self action:@selector(seleFaPiaoBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    [foView.seleCarIdBtn addTarget:self action:@selector(seleCarIdBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [foView.submitBtn addTarget:self action:@selector(submitBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foView];
    
    lhNavigationBar * nBar = [[lhNavigationBar alloc]initWithVC:self title:@"确认订单" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nBar];
    
    self.totalPrice = [[self.firmDic objectForKey:@"sum"] doubleValue];
    firmArray = [self.firmDic objectForKey:@"dataList"];
    
    [lhFirmOrderViewModel updateTableSize:foView.firmTableView fArray:firmArray];
    
    CGFloat servicePrice = [[self.firmDic objectForKey:@"serviceMoney"] doubleValue]*[[self.firmDic objectForKey:@"sum"] doubleValue];
    
    NSString * priceStr = [NSString stringWithFormat:@"合计:%.2f元",_totalPrice+servicePrice];
    foView.totalPriceLabel.attributedText = [lhFirmOrderViewModel setLabelStyle:priceStr];
    NSString * servicePriceStr = [NSString stringWithFormat:@"含服务费%.2f元",servicePrice];
    foView.servicePriceLabel.text = servicePriceStr;
    
    if ([[self.firmDic allKeys] containsObject:@"invoice"]) {
        nowFaPiaoDic = [self.firmDic objectForKey:@"invoice"];
        foView.faPiaoLabel.text = [NSString stringWithFormat:@"%@",[nowFaPiaoDic objectForKey:@"name"]];
    }
//    if ([[self.firmDic allKeys] containsObject:@"motorcade"]) {
//        nowCarIdDic = [self.firmDic objectForKey:@"motorcade"];
//        foView.carIdLabel.text = [NSString stringWithFormat:@"%@",[nowCarIdDic objectForKey:@"name"]];
//    }
    
    
//    foView.bankCardIdLabel.text = [NSString stringWithFormat:@"%@",[self.firmDic objectForKey:@"bankNo"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (firmArray && firmArray.count) {
        return firmArray.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (firmArray && firmArray.count) {
        NSArray * tArr = [firmArray objectAtIndex:section];
        
        return tArr.count;
    }
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
//    hView.backgroundColor = [UIColor whiteColor];
//    
//    UIImageView * hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
//    hImgView.backgroundColor = [UIColor grayColor];
//    [hView addSubview:hImgView];
//    
//    UILabel * nLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, DeviceMaxWidth-60, 40)];
//    nLabel.font = [UIFont systemFontOfSize:14];
//    nLabel.textColor = lhcontentTitleColorStr2;
//    nLabel.text = @"中航油广汉库";
//    [hView addSubview:nLabel];
//    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
//    lineView.backgroundColor = tableDefSepLineColor;
//    [hView addSubview:lineView];
//    
//    return hView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView * fView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 50)];
//    fView.backgroundColor = [UIColor whiteColor];
//    
//    NSString * pStr = @"共5吨  合计:￥28650.00";
//    UILabel * pLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, DeviceMaxWidth-55, 40)];
//    pLabel.textAlignment = NSTextAlignmentRight;
//    pLabel.font = [UIFont systemFontOfSize:15];
//    pLabel.textColor = lhredColorStr;
//    pLabel.attributedText = [lhFirmOrderViewModel setEveryLabelStyle:pStr];
//    [fView addSubview:pLabel];
//    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
//    lineView.backgroundColor = tableDefSepLineColor;
//    [fView addSubview:lineView];
//    
//    UIView * viewColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, DeviceMaxWidth, 10)];
//    viewColorView.backgroundColor = lhviewColor;
//    [fView addSubview:viewColorView];
//    
//    return fView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"firmCell";
    lhFirmOrderTableViewCell * fCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (fCell == nil) {
        fCell = [[lhFirmOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSDictionary * dic = [firmArray objectAtIndex:indexPath.row];
    
    lhShopCarModel * scModel = [LHJsonModel modelWithDict:dic className:@"lhShopCarModel"];
    
    fCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",scModel.name,scModel.oilName];
    
    fCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",scModel.price];
    fCell.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",scModel.policyPrice];
    
    NSString * xjStr = [NSString stringWithFormat:@"小计: %.0f元",(CGFloat)[scModel.price integerValue]*[scModel.purchaseNumber integerValue]];
    fCell.totalLabel.text = xjStr;
    
    NSString * jsStr = [NSString stringWithFormat:@"已省 %.0f元",(CGFloat)([scModel.policyPrice integerValue]-[scModel.price integerValue])*[scModel.purchaseNumber integerValue]];
    fCell.jsLabel.text = jsStr;
    
    fCell.numLabel.text = [NSString stringWithFormat:@"x%@",scModel.purchaseNumber];
    
    [lhFirmOrderViewModel updateCell:fCell];
    
    return fCell;
    
}


#pragma mark - 选择发票抬头和配送车辆
- (void)seleFaPiaoBtnEvent
{
    NSLog(@"选择发票");
    
    FrankSelectFaPiaoView * sfVC = [[FrankSelectFaPiaoView alloc]init];
    sfVC.delegate = self;
    [self.navigationController pushViewController:sfVC animated:YES];
    
}

//- (void)seleCarIdBtnEvent
//{
//    NSLog(@"选择车牌");
//    
//    lhSelectCarIdViewController * sciVC = [[lhSelectCarIdViewController alloc]init];
//    sciVC.delegate = self;
//    [self.navigationController pushViewController:sciVC animated:YES];
//    
//}

#pragma mark - selectCarIdAndFaPiaoTitleDelegate
- (void)setCarIdDic:(NSDictionary *)carIdDic withType:(NSInteger)type
{
    if(type == 5){//车牌设置
//        nowCarIdDic = carIdDic;
//        foView.carIdLabel.text = [nowCarIdDic objectForKey:@"name"];
    }
    else{//发票抬头设置
        nowFaPiaoDic = carIdDic;
        foView.faPiaoLabel.text = [nowFaPiaoDic objectForKey:@"name"];
    }
}

#pragma mark - 提交订单
- (void)submitBtnEvent
{
    NSLog(@"提交订单");
    
    if ([@"" isEqualToString:foView.faPiaoLabel.text] || !nowFaPiaoDic || nowFaPiaoDic.count == 0) {
        [lhUtilObject showAlertWithMessage:@"请选择一个公司名称~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
//    if ([@"" isEqualToString:foView.carIdLabel.text] || !nowCarIdDic || nowCarIdDic.count == 0) {
//        [lhUtilObject showAlertWithMessage:@"请选择一个车牌信息~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
//        return;
//    }
    
    NSString * serviceRate = [self.firmDic objectForKey:@"serviceMoney"];
    CGFloat servicePrice = [serviceRate doubleValue]*[[self.firmDic objectForKey:@"sum"] doubleValue];
    NSString * serviceRateStr = [NSString stringWithFormat:@"%.2f",[serviceRate doubleValue]*1000];
    NSString * oilStr = [NSString stringWithFormat:@"%.2f元",_totalPrice];
    NSString * serviceStr = [NSString stringWithFormat:@"%.2f元",servicePrice];
    NSString * totalStr = [NSString stringWithFormat:@"%.2f元",_totalPrice+servicePrice];
    
    NSString * priceStr = [NSString stringWithFormat:@"购油费：%@\n服务费：%@(油款总价的千分之%@)\n合计金额：%@",oilStr,serviceStr,[FrankTools floatStringZero:serviceRateStr],totalStr];
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:priceStr];
    
    [as addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(4, oilStr.length-1)];
    [as addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(9+oilStr.length, serviceStr.length-1)];
    [as addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(priceStr.length-totalStr.length, totalStr.length-1)];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, priceStr.length)];
    
//    NSString * tStr = [NSString stringWithFormat:@"您(%@)将消费：",foView.faPiaoLabel.text];
    NSString * tStr = @"您将消费：";
    lhAlertView * alertView = [[lhAlertView alloc]initWithFrame2:self.view.bounds noticeStr:tStr attributedS1:as];
    alertView.delegate = self;
    [self.view addSubview:alertView];
    
//    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:priceStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
}

#pragma mark - firmBtnClickProtocol
//确定
- (void)firmBtnClick:(lhAlertView *)alertView
{
    NSLog(@"确定按钮");
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhFirmOrderViewModel firmOrderArray:firmArray invoiceData:nowFaPiaoDic success:^(id response) {
        
        [lhUtilObject shareUtil].isRefreshShopCar = YES;//提交成功，刷新购物车
        
        NSString * cartSize = [NSString stringWithFormat:@"%@",[response objectForKey:@"cartSize"]];
        [[lhTabBar shareTabBar] sizeToFitWithText:cartSize];
        
        FrankDirectView * fdVC = [[FrankDirectView alloc]init];
        fdVC.type = 5;
        [self.navigationController pushViewController:fdVC animated:YES];
        
        [lhHubLoading disAppearActivitiView];
    }];
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
