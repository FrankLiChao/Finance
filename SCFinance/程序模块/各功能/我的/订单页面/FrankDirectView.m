//
//  FrankDirectView.m
//  SCFinance
//
//  Created by lichao on 16/6/16.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankDirectView.h"
#import "FrankOrderCell.h"
#import "FrankListCell.h"
#import "FrankTools.h"
#import "FrankDirectOrderView.h"
#import "lhMainRequest.h"
#import "lhHubLoading.h"
#import "MJRefresh.h"
#import "lhUserProtocolViewController.h"

@interface FrankDirectView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,rightBtnDelegate>
{
    UIScrollView *myScrollView;
    UITableView *myTableView;   //待处理
    UITableView *finishTable;   //已完成
    UITextField *oilField;
    UIButton *handleBtn;     //待处理
    UIButton *finishBtn;     //已完成
    UIView *lineV;
    NSArray *directArray;   //直购数组
    NSArray *finishArray;   //已完成数组
    
    NSInteger pNo;      //消息当前页数
    NSInteger allPno;   //消息总页数
}

@end

@implementation FrankDirectView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * tBar = [[lhNavigationBar alloc]initWithVC:self title:@"直购订单" isBackBtn:YES rightBtn:nil];
    tBar.delegate = self;
    [self.view addSubview:tBar];
    
    if (self.type == 5) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.backgroundColor = lhviewColor;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth*2, CGRectGetHeight(myScrollView.frame));
    
    [self initHeadView];
    [self initDirectView];
    
    [lhHubLoading addActivityView:self.view];
    myScrollView.contentOffset = CGPointMake(0, 0);
    [self requestDirectViewData];
}

-(void)initDirectView
{
    if (!myTableView) {
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60*widthRate, DeviceMaxWidth, CGRectGetHeight(myScrollView.frame)-60*widthRate) style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = lhviewColor;
        [myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
        [myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
        [myScrollView addSubview:myTableView];
    }
    if (!finishTable) {
        finishTable = [[UITableView alloc] initWithFrame:CGRectMake(DeviceMaxWidth, 60*widthRate, DeviceMaxWidth, CGRectGetHeight(myScrollView.frame)-60*widthRate) style:UITableViewStylePlain];
        finishTable.delegate = self;
        finishTable.dataSource = self;
        finishTable.showsVerticalScrollIndicator = NO;
        finishTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        finishTable.backgroundColor = lhviewColor;
        [finishTable addHeaderWithTarget:self action:@selector(headerRefresh)];
        [finishTable addFooterWithTarget:self action:@selector(footerRefresh)];
        [myScrollView addSubview:finishTable];
    }
}

-(void)reloadTableView:(UITableView *)tableView
{
    [tableView reloadData];
    CGFloat hight = 40;
    for (int i=0; i<finishArray.count; i++) {
        UIImageView *imageV = (UIImageView *)[self.view viewWithTag:i+200];
        if (imageV) {
            [imageV removeFromSuperview];
        }
        UIImageView *finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-110*widthRate, hight, 75*widthRate, 45*widthRate)];
        finishImage.tag = i+200;
        if ([[finishArray[i] objectForKey:@"orderStatus"] integerValue]>4) {
            [finishImage setImage:imageWithName(@"failureImageView")];
        }else{
            [finishImage setImage:imageWithName(@"finishImageView")];
        }
        [tableView addSubview:finishImage];
        [tableView insertSubview:finishImage aboveSubview:tableView];
        hight += 90+40*widthRate;
    }
}

#pragma mark - 刷新和加载
//下拉刷新
- (void)headerRefresh
{
    pNo = 1;
    [self requestDirectViewData];
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= allPno) {
        [lhUtilObject showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        if (myScrollView.contentOffset.x == DeviceMaxWidth) {
            [finishTable footerEndRefreshing];
        }
        else{
            [myTableView footerEndRefreshing];
        }
        return;
    }
    
    pNo++;
    [self requestDirectViewData];
}

-(void)requestDirectViewData
{
    NSString *userId =  [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
    NSString *type = @"";
    if (myScrollView.contentOffset.x == 0) {
        type = @"";
    }else if (myScrollView.contentOffset.x == DeviceMaxWidth) {
        type = @"1";
    }
    NSDictionary *dic = @{@"type":type,
                          @"pageSize":@"20",
                          @"pageNo":@"1",
                          @"userId":userId};
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findPurchaseDirectList") parameters:dic method:@"POST" success:^(id responseObject)
     {
         FLLog(@"%@",responseObject)
         if (pNo == 1) {
             allPno = [[responseObject objectForKey:@"totalPages"]integerValue];
             NSArray *array = [responseObject objectForKey:@"data"];
             
             if (myScrollView.contentOffset.x == 0) {
                 directArray = array;
                 [myTableView headerEndRefreshing];
             }else if (myScrollView.contentOffset.x == DeviceMaxWidth) {
                 finishArray = array;
                 [finishTable headerEndRefreshing];
             }
         }
         else{
             NSArray * tempA = [responseObject objectForKey:@"data"];
             if (tempA && tempA.count > 0) {
                 if (myScrollView.contentOffset.x == 0) {
                     NSMutableArray * tArray = [NSMutableArray arrayWithArray:directArray];
                     [tArray addObjectsFromArray:tempA];
                     directArray = tArray;
                     [myTableView footerEndRefreshing];
                 }else if (myScrollView.contentOffset.x == DeviceMaxWidth) {
                     NSMutableArray * tArray = [NSMutableArray arrayWithArray:finishArray];
                     [tArray addObjectsFromArray:tempA];
                     finishArray = tArray;
                     [finishTable footerEndRefreshing];
                 }
             }
         }
         
         if (myScrollView.contentOffset.x == 0) {
             if (directArray.count) {
                 [lhUtilObject removeNullLabelWithSuperView:myTableView];
             }else
             {
                 [lhUtilObject addANullLabelWithSuperView:myTableView withText:@"暂无订单"];
             }
             [myTableView reloadData];
         }
         else if (myScrollView.contentOffset.x == DeviceMaxWidth) {
             if (finishArray.count) {
                 [lhUtilObject removeNullLabelWithSuperView:finishTable];
             }else
             {
                 [lhUtilObject addANullLabelWithSuperView:finishTable withText:@"暂无订单"];
             }
             [finishTable reloadData];
         }
         
        [lhHubLoading disAppearActivitiView];
     }fail:^(id error){
         [lhHubLoading disAppearActivitiView];
         [lhMainRequest checkRequestFail:error];
         if (myScrollView.contentOffset.x == 0) {
             [myTableView headerEndRefreshing];
             [myTableView footerEndRefreshing];
         }
         else if (myScrollView.contentOffset.x == DeviceMaxWidth) {
             [finishTable headerEndRefreshing];
             [finishTable footerEndRefreshing];
         }
     }];
}

-(void)requestFinishDirectViewData
{
    NSString *userId =  [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
    NSDictionary *dic = @{@"type":@"1",
                          @"pageSize":@"20",
                          @"pageNo":@"1",
                          @"userId":userId};
    FLLog(@"%@",dic);
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findPurchaseDirectList") parameters:dic method:@"POST" success:^(id responseObject)
     {
         if (pNo == 1) {
             allPno = [[responseObject objectForKey:@"totalPages"]integerValue];
             finishArray = [responseObject objectForKey:@"data"];
         }
         else{
             NSArray * tempA = [responseObject objectForKey:@"data"];
             if (tempA && tempA.count > 0) {
                 NSMutableArray * tArray = [NSMutableArray arrayWithArray:finishArray];
                 [tArray addObjectsFromArray:tempA];
                 finishArray = tArray;
             }
         }
         if (pNo == 1) {
             [finishTable headerEndRefreshing];
         }
         else{
             [finishTable footerEndRefreshing];
         }
         if (finishArray.count) {
             [lhUtilObject removeNullLabelWithSuperView:finishTable];
         }else
         {
             [lhUtilObject addANullLabelWithSuperView:finishTable withText:@"暂无订单"];
         }
         [self reloadTableView:finishTable];
         [lhHubLoading disAppearActivitiView];
     }fail:^(id error){
         [lhHubLoading disAppearActivitiView];
         [lhMainRequest checkRequestFail:error];
         if (pNo == 1) {
             [finishTable headerEndRefreshing];
         }
         else{
             [finishTable footerEndRefreshing];
         }
     }];
}

-(void)initHeadView
{
    handleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    handleBtn.frame = CGRectMake(0, 64, DeviceMaxWidth/2, 50*widthRate);
    [handleBtn setTitle:@"待处理订单" forState:UIControlStateNormal];
    [handleBtn setTitleColor:lhmainColor forState:UIControlStateSelected];
    [handleBtn setTitleColor:lhcontentTitleColorStr2 forState:UIControlStateNormal];
    handleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [handleBtn addTarget:self action:@selector(clickHandleButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    handleBtn.selected = YES;
    handleBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:handleBtn];
    
    finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(DeviceMaxWidth/2, 64, DeviceMaxWidth/2, 50*widthRate);
    [finishBtn setTitle:@"已完成订单" forState:UIControlStateNormal];
    [finishBtn setTitleColor:lhmainColor forState:UIControlStateSelected];
    [finishBtn setTitleColor:lhcontentTitleColorStr2 forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    finishBtn.backgroundColor = [UIColor whiteColor];
    [finishBtn addTarget:self action:@selector(clickFinishButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 64+50*widthRate-1, DeviceMaxWidth/2, 1)];
    lineV.backgroundColor = lhmainColor;
    [self.view addSubview:lineV];
}

-(void)clickHandleButtonEvent
{
    handleBtn.selected = YES;
    finishBtn.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = lineV.frame;
        rect.origin.x = 0;
        lineV.frame = rect;
        myScrollView.contentOffset = CGPointMake(0, 0);
    }];
}

-(void)clickFinishButtonEvent
{
    handleBtn.selected = NO;
    finishBtn.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = lineV.frame;
        rect.origin.x = DeviceMaxWidth/2;
        lineV.frame = rect;
        myScrollView.contentOffset = CGPointMake(DeviceMaxWidth, 0);
    }];
    if (!finishArray.count) {
        pNo = 1;
        [self requestFinishDirectViewData];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView == myTableView)
//    {
//        UITableView *tableview = (UITableView *)scrollView;
//        CGFloat sectionHeaderHeight = 40;
//        CGFloat sectionFooterHeight = 50;
//        CGFloat offsetY = tableview.contentOffset.y;
//        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
//        {
//            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
//            
//        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
//        {
//            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
//        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
//        {
//            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
//        }
//    }
    
    CGFloat pageWidth = DeviceMaxWidth;
    // 根据当前的x坐标和页宽度计算出当前页数
    
    if (scrollView == myScrollView) {
        if ((int)scrollView.contentOffset.x%(int)DeviceMaxWidth == 0) {
            
            int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            
            if (currentPage == 0) {
                [self clickHandleButtonEvent];
            }else if (currentPage == 1)
            {
                [self clickFinishButtonEvent];
            }
        }
    }
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    NSInteger type = 0;
    if (tableView == myTableView) {
        dic = directArray[indexPath.section];
        type = 0;
    }else{
        dic = finishArray[indexPath.section];
        type = 1;
    }
    FrankDirectOrderView *dView = [FrankDirectOrderView new];
    dView.orderId = [dic objectForKey:@"id"];
    dView.type = type;
    [self.navigationController pushViewController:dView animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        return 40*widthRate;
    }else {
        return 90+40*widthRate;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == myTableView) {
        return directArray.count;
    }else{
        return finishArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        NSDictionary *dic = directArray[section];
        NSArray *array = [dic objectForKey:@"listProduct"];
        return array.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        return 40;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        NSDictionary *dic = directArray[section];
        UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
        hView.backgroundColor = [UIColor whiteColor];
        
        UILabel * nLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-110*widthRate, 40)];
        nLabel.font = [UIFont systemFontOfSize:14];
        nLabel.textColor = lhcontentTitleColorStr2;
        nLabel.text = [NSString stringWithFormat:@"订单号：%@",[dic objectForKey:@"orderId"]];
        [hView addSubview:nLabel];
        
        UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-120*widthRate, 0, 110*widthRate, 40)];
        dataLab.font = [UIFont systemFontOfSize:14];
        dataLab.textColor = lhcontentTitleColorStr2;
        dataLab.textAlignment = NSTextAlignmentRight;
        dataLab.text = [FrankTools LongTimeToString:[dic objectForKey:@"createTime"] withFormat:@"YYYY-MM-dd"];
        [hView addSubview:dataLab];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [hView addSubview:lineView];
        
        return hView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        return 50;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        NSDictionary *dic = directArray[section];
        UIView * fView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 50)];
        fView.backgroundColor = [UIColor whiteColor];
        
        NSString *totalMoney = nil;
        CGFloat serviceMoney = [[dic objectForKey:@"serviceMoney"] floatValue];
        if (tableView == myTableView)
        {
            CGFloat amount = [[dic objectForKey:@"amount"] floatValue];
            totalMoney = [NSString stringWithFormat:@"%0.2f元",amount*serviceMoney+amount];
        }else{
            CGFloat price = [[dic objectForKey:@"price"] floatValue];
            CGFloat purchaseNumber = [[dic objectForKey:@"purchaseNumber"] floatValue];
            totalMoney = [NSString stringWithFormat:@"%0.2f元",price*purchaseNumber*serviceMoney+price*purchaseNumber];
        }
        NSString *totalStr = [NSString stringWithFormat:@"合计:%@",totalMoney];
        UILabel * pLabel = [[UILabel alloc]initWithFrame:CGRectMake(40*widthRate, 0, DeviceMaxWidth-50*widthRate, 40)];
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
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        static NSString * tifier = @"firmCell";
        FrankOrderCell * fCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        NSDictionary *dic = nil;
        if (fCell == nil) {
            fCell = [[FrankOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        if (tableView == myTableView) {
            NSArray *array = [directArray[indexPath.section] objectForKey:@"listProduct"];
            dic = [array objectAtIndex:indexPath.row];
            if (array.count != indexPath.row+1) {
                CGRect rect = fCell.lineView.frame;
                rect.origin.x = 10*widthRate;
                rect.size.width = DeviceMaxWidth - 10*widthRate;
                fCell.lineView.frame = rect;
            }
        }else{
            dic = finishArray[indexPath.section];
        }
        fCell.oilAddress.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"depotName"]];
        fCell.oilNumber.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"oilName"]];
        fCell.oilStock.text = [NSString stringWithFormat:@"%@吨",[dic objectForKey:@"purchaseNumber"]];
        return fCell;
    }else {
        static NSString * tifier = @"fCell";
        FrankListCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
        
        if (cell == nil) {
            cell = [[FrankListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        
        NSDictionary *dic = finishArray[indexPath.section];
        cell.orderName.text = [NSString stringWithFormat:@"订单号：%@",[dic objectForKey:@"orderId"]];
        cell.dataName.text = [FrankTools LongTimeToString:[dic objectForKey:@"createTime"] withFormat:@"YYYY-MM-dd"];
        
        cell.oilAddress.text = [dic objectForKey:@"depotName"];
        cell.oilNumber.text = [dic objectForKey:@"oilName"];
        cell.oilStock.text = [NSString stringWithFormat:@"%@吨",[dic objectForKey:@"purchaseNumber"]];
        
        CGFloat serviceMoney = [[dic objectForKey:@"serviceMoney"] floatValue];
        CGFloat price = [[dic objectForKey:@"price"] floatValue];
        CGFloat purchaseNumber = [[dic objectForKey:@"purchaseNumber"] floatValue];
        NSString *totalMoney = [NSString stringWithFormat:@"%0.2f元",price*purchaseNumber*serviceMoney+price*purchaseNumber];
        NSString *totalStr = [NSString stringWithFormat:@"合计:%@",totalMoney];
        cell.totalMoney.attributedText = [FrankTools setFontColorSize:[UIFont systemFontOfSize:15] WithColor:lhredColorStr WithString:totalStr WithRange:NSMakeRange(totalStr.length-totalMoney.length, totalMoney.length)];
        return cell;
    }
}

/*
 * 预览提油单
 */
/*
-(void)clickPreviewButtonEvent:(UIButton *)button_
{
    FLLog(@"点击预览按钮");
    NSDictionary *dic = finishArray[button_.tag];

    NSString * aStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pdfUrl"]];
    lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
    upVC.titleStr = @"我的提油单";
    upVC.urlStr = aStr;
    [self.navigationController pushViewController:upVC animated:YES];
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - backEvent
- (void)backBtnEvent
{
    if (self.type == 5) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
