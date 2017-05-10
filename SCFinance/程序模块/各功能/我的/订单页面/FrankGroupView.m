//
//  FrankGroupView.m
//  SCFinance
//
//  Created by lichao on 16/6/16.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankGroupView.h"
#import "FrankListCell.h"
#import "FrankTools.h"
#import "FrankGroupOrderView.h"
#import "lhMainRequest.h"
#import "lhHubLoading.h"
#import "MJRefresh.h"
#import "lhUserProtocolViewController.h"

@interface FrankGroupView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,rightBtnDelegate>
{
    UIScrollView *myScrollView;
    UITableView *myTableView;   //团购待处理
    UITableView *finishTable;   //已完成
    UITextField *oilField;
    UIButton *handleBtn;    //待处理
    UIButton *finishBtn;    //已完成
    
    UIView *lineV;
    NSArray *groupArray;    //团购数组
    NSArray *finishArray;   //已完成数组
    
    NSInteger pNo;      //消息当前页数
    NSInteger allPno;   //消息总页数
}

@end

@implementation FrankGroupView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * tBar = [[lhNavigationBar alloc]initWithVC:self title:@"团购订单" isBackBtn:YES rightBtn:nil];
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
    [self initGroupView];
    
    [lhHubLoading addActivityView:self.view];
    [self requestGroupViewData];
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


#pragma mark - 刷新和加载
//下拉刷新
- (void)headerRefresh
{
    pNo = 1;
    if (myScrollView.contentOffset.x == DeviceMaxWidth) {
        [self requestFinishGroupViewData];
    }else{
        [self requestGroupViewData];
    }
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= allPno) {
        [lhUtilObject showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        if (myScrollView.contentOffset.x == DeviceMaxWidth) {
            [finishTable footerEndRefreshing];
        }else{
            [myTableView footerEndRefreshing];
        }
        return;
    }
    
    pNo++;
    if (myScrollView.contentOffset.x == DeviceMaxWidth) {
        [self requestFinishGroupViewData];
    }else{
        [self requestGroupViewData];
    }
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

-(void)requestGroupViewData
{   
    NSString *userId =  [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
    NSDictionary *dic = @{@"type":@"",
                          @"pageSize":@"20",
                          @"pageNo":@"1",
                          @"userId":userId};
    FLLog(@"%@",dic);
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findProductList") parameters:dic method:@"POST" success:^(id responseObject)
     {
         FLLog(@"%@",responseObject);
         if (pNo == 1) {
             allPno = [[responseObject objectForKey:@"totalPages"]integerValue];
             groupArray = [responseObject objectForKey:@"data"];
         }
         else{
             NSArray * tempA = [responseObject objectForKey:@"data"];
             if (tempA && tempA.count > 0) {
                 NSMutableArray * tArray = [NSMutableArray arrayWithArray:groupArray];
                 [tArray addObjectsFromArray:tempA];
                 groupArray = tArray;
             }
         }
         if (pNo == 1) {
             [myTableView headerEndRefreshing];
         }
         else{
             [myTableView footerEndRefreshing];
         }
         if (groupArray.count) {
             [lhUtilObject removeNullLabelWithSuperView:myTableView];
         }else
         {
             [lhUtilObject addANullLabelWithSuperView:myTableView withText:@"暂无订单"];
         }
         [myTableView reloadData];
         [lhHubLoading disAppearActivitiView];
     }fail:^(id error){
         [lhHubLoading disAppearActivitiView];
         [lhMainRequest checkRequestFail:error];
         if (pNo == 1) {
             [myTableView headerEndRefreshing];
         }
         else{
             [myTableView footerEndRefreshing];
         }
     }];
}

-(void)requestFinishGroupViewData
{
    NSString *userId =  [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
    NSDictionary *dic = @{@"type":@"1",
                          @"pageSize":@"20",
                          @"pageNo":@"1",
                          @"userId":userId};
    FLLog(@"%@",dic);
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findProductList") parameters:dic method:@"POST" success:^(id responseObject)
     {
         FLLog(@"%@",responseObject);
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
        if ([[finishArray[i] objectForKey:@"orderStatus"] integerValue]>7) {
            [finishImage setImage:imageWithName(@"failureImageView")];
        }else{
            [finishImage setImage:imageWithName(@"finishImageView")];
        }
        [tableView addSubview:finishImage];
        
        hight += 90+40*widthRate;
    }
}

-(void)initGroupView
{
    if (!myTableView) {
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60*widthRate, DeviceMaxWidth, CGRectGetHeight(myScrollView.frame)-60*widthRate) style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.showsHorizontalScrollIndicator = NO;
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
        finishTable.showsHorizontalScrollIndicator = NO;
        finishTable.showsVerticalScrollIndicator = NO;
        finishTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        finishTable.backgroundColor = lhviewColor;
        [finishTable addHeaderWithTarget:self action:@selector(headerRefresh)];
        [finishTable addFooterWithTarget:self action:@selector(footerRefresh)];
        [myScrollView addSubview:finishTable];
    }
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
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
                if (!finishArray.count) {
                    [self requestFinishGroupViewData];
                }
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
        dic = groupArray[indexPath.section];
        type = 0;
    }else{
        dic = finishArray[indexPath.section];
        type = 1;
    }
    FrankGroupOrderView *gView = [FrankGroupOrderView new];
    gView.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
    gView.tgId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    gView.type = type;
    [self.navigationController pushViewController:gView animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90+40*widthRate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == myTableView) {
        return groupArray.count;
    }
    else{
        return finishArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"firmCell";
    FrankListCell * fCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    
    if (fCell == nil) {
        fCell = [[FrankListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSDictionary *dic = nil;
    if (tableView == myTableView) {
        dic = groupArray[indexPath.section];
    }else {
        dic = finishArray[indexPath.section];
    }
    fCell.orderName.text = [NSString stringWithFormat:@"订单号：%@",[dic objectForKey:@"orderId"]];
    fCell.dataName.text = [FrankTools LongTimeToString:[dic objectForKey:@"createTime"] withFormat:@"YYYY-MM-dd"];
    
    fCell.oilAddress.text = [dic objectForKey:@"depotName"];
    fCell.oilNumber.text = [dic objectForKey:@"oilName"];
    fCell.oilStock.text = [NSString stringWithFormat:@"%@吨",[dic objectForKey:@"purchaseNumber"]];
    
    CGFloat amount = [[dic objectForKey:@"amount"] floatValue];
    CGFloat serviceMoney = [[dic objectForKey:@"serviceMoney"] floatValue];
    NSString *totalMoney = [NSString stringWithFormat:@"%0.2f元",amount+amount*serviceMoney];
    NSString *totalStr = [NSString stringWithFormat:@"共%ld吨  合计:%@",(long)[[dic objectForKey:@"purchaseNumber"] integerValue],totalMoney];
    fCell.totalMoney.attributedText = [FrankTools setFontColorSize:[UIFont systemFontOfSize:15] WithColor:lhredColorStr WithString:totalStr WithRange:NSMakeRange(totalStr.length-totalMoney.length, totalMoney.length)];
    return fCell;
}

/*
 * 预览提油单
 */
/*
-(void)clickPreviewButtonEvent:(UIButton *)button_
{
    FLLog(@"点击预览按钮");
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


@end
