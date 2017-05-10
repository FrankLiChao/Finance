//
//  lhMessageListViewController.m
//  GasStation
//
//  Created by liuhuan on 15/8/26.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhMessageListViewController.h"
#import "FrankMessageCell.h"
#import "MJRefresh.h"
#import "lhUserProtocolViewController.h"
#import "lhPersonalViewModel.h"

@interface lhMessageListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTabView;//消息显示
    NSInteger pNo;//消息当前页数
    NSInteger allPno;//消息总页数
    NSMutableArray *dataArray;//消息数据
}

@end

@implementation lhMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lhNavigationBar * tBar = [[lhNavigationBar alloc]initWithVC:self title:@"消息中心" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:tBar];
    
    dataArray = [NSMutableArray array];
    pNo = 1;
    allPno = 1;
    [self initFrameView];
    
    [lhHubLoading addActivityView:self.view];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFrameView
{
    myTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTabView.showsVerticalScrollIndicator = NO;
    myTabView.delegate = self;
    myTabView.dataSource = self;
    myTabView.separatorColor = [UIColor clearColor];
    myTabView.backgroundColor = lhviewColor;
//    myTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTabView];
    
    [myTabView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [myTabView addFooterWithTarget:self action:@selector(footerRefresh)];
}

//下拉刷新
- (void)headerRefresh
{
    pNo = 1;
    [self requestData];
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= allPno) {
        [lhUtilObject showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [myTabView footerEndRefreshing];
        return;
    }
    
    pNo++;
    [self requestData];
}

//请求数据
- (void)requestData
{
    if ([lhUtilObject loginIsOrNot]) {

        [lhPersonalViewModel requestMessageInfoPno:pNo success:^(id response) {
            if (pNo == 1) {
                [myTabView headerEndRefreshing];
            }
            else{
                [myTabView footerEndRefreshing];
            }
            
            NSLog(@"%@",response);
            
            NSString * nowMessageStr = [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].messageNum];
            [[NSUserDefaults standardUserDefaults]setObject:nowMessageStr forKey:saveAllMessageFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSDictionary * dic = response;
            if (pNo == 1) {
                allPno = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"pageNo"]]integerValue];
                dataArray = [dic objectForKey:@"messageList"];
            }
            else{
                NSArray * tempA = [dic objectForKey:@"messageList"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:dataArray];
                    [tArray addObjectsFromArray:tempA];
                    dataArray = tArray;
                }
            }
            if (dataArray && dataArray.count > 0) {
                [lhUtilObject removeNullLabelWithSuperView:myTabView];
            }
            else{
                [lhUtilObject addANullLabelWithSuperView:myTabView withText:@"暂无消息信息~"];
            }
            [myTabView reloadData];
            
            [lhHubLoading disAppearActivitiView];
        } fail:^(id error) {
            if (pNo == 1) {
                [myTabView headerEndRefreshing];
            }
            else{
                [myTabView footerEndRefreshing];
            }
            
            if (dataArray && dataArray.count > 0) {
                [lhUtilObject removeNullLabelWithSuperView:myTabView];
            }
            else{
                [lhUtilObject addANullLabelWithSuperView:myTabView withText:@"暂无消息信息~"];
            }
            [myTabView reloadData];
            
            [lhMainRequest checkRequestFail:error];
            [lhHubLoading disAppearActivitiView];
        }];
        
    }

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * oneD = [dataArray objectAtIndex:indexPath.section];
    
//    if (oneD && oneD.count) {
//        NSString * operateType = [NSString stringWithFormat:@"%@",[oneD objectForKey:@"operateType"]];
//        
//        if (operateType && ![@"" isEqualToString:operateType] && ![operateType rangeOfString:@"null"].length && [operateType integerValue] != 0) {
//            [lhColor pushToVCWithType:operateType params:[NSString stringWithFormat:@"%@",[oneD objectForKey:@"operateParams"]]];
//        }
//        else{
    
            NSString * urlStr = [NSString stringWithFormat:@"%@",[oneD objectForKey:@"url"]];
            if (urlStr && ![@"" isEqualToString:urlStr] && ![urlStr rangeOfString:@"null"].length) {
                lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
                upVC.titleStr = @"详情";
                upVC.urlStr = urlStr;
                [self.navigationController pushViewController:upVC animated:YES];
            }
//        }
//    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * oned = [dataArray objectAtIndex:indexPath.section];
    NSString * contentStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"content"]];
    NSString * titleStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"title"]];
    
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:titleStr];
    NSMutableAttributedString * as1 = [[NSMutableAttributedString alloc]initWithString:contentStr];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, titleStr.length)];
    [as1 addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, contentStr.length)];
    
    CGFloat heih = 30.0f*widthRate;
    UILabel * labe = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 5*widthRate, DeviceMaxWidth-100*widthRate, 20*widthRate)];
    labe.numberOfLines = 0;
    labe.font = [UIFont systemFontOfSize:15];
    labe.attributedText = as;
    [labe sizeToFit];
    
    heih += CGRectGetHeight(labe.frame)+10*widthRate;
    
    UILabel * labe1 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 30*widthRate, DeviceMaxWidth-100*widthRate, 20*widthRate)];
    labe1.numberOfLines = 0;
    labe1.font = [UIFont systemFontOfSize:13];
    labe1.attributedText = as1;
    [labe1 sizeToFit];
    
    heih += CGRectGetHeight(labe1.frame)+10*widthRate;
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"url"]];
    NSString * operateType = [NSString stringWithFormat:@"%@",[oned objectForKey:@"operateType"]];

    if ((urlStr && ![@"" isEqualToString:urlStr] && ![urlStr rangeOfString:@"null"].length) || (operateType && ![@"" isEqualToString:operateType] && ![operateType rangeOfString:@"null"].length && [operateType integerValue] != 0)) {
        heih += 45*widthRate;
    }
    else{
        heih += 5*widthRate;
    }
    
    return heih;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30*widthRate;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30*widthRate)];
//    hView.backgroundColor = [UIColor whiteColor];
//    
//    NSDictionary * oned = [dataArray objectAtIndex:section];
//    NSString * dStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"createTime"]];
//    NSDateFormatter * df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * date = [df dateFromString:dStr];
//    [df setDateFormat:@"yyyy年MM月dd日"];
//
//    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 5*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
//    dataLab.text = [df stringFromDate:date];
//    dataLab.font = [UIFont systemFontOfSize:15];
//    dataLab.backgroundColor = [UIColor whiteColor];
//    [hView addSubview:dataLab];
//    
//    return hView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"myTeamCell";
    FrankMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSDictionary * oned = [dataArray objectAtIndex:indexPath.section];
    
    NSString * dStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"createTime"]];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [df dateFromString:dStr];
    [df setDateFormat:@"MM月dd日"];
    cell.timeLab.text = [df stringFromDate:date];
    
    NSString * pStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"imageUrl"]];
    NSString * allPstr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,pStr];
    [lhUtilObject checkImageWithImageView:cell.hdImage withImage:pStr withImageUrl:allPstr withPlaceHolderImage:imageWithName(placeHolderImg)];
    
    NSString * contentStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"content"]];
    NSString * titleStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"title"]];

    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:titleStr];
    NSMutableAttributedString * as1 = [[NSMutableAttributedString alloc]initWithString:contentStr];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, titleStr.length)];
    [as1 addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, contentStr.length)];
    
    cell.tLab.attributedText = as;
    [cell.tLab sizeToFit];
    cell.tLab.frame = CGRectMake(10*widthRate, 5*widthRate, DeviceMaxWidth-100*widthRate, CGRectGetHeight(cell.tLab.frame)+5*widthRate);
    
    cell.contentLab.attributedText = as1;
    [cell.contentLab sizeToFit];
    cell.contentLab.frame = CGRectMake(10*widthRate, 5*widthRate+CGRectGetHeight(cell.tLab.frame), DeviceMaxWidth-100*widthRate, CGRectGetHeight(cell.contentLab.frame)+10*widthRate);
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",[oned objectForKey:@"url"]];
    if (urlStr && ![@"" isEqualToString:urlStr] && ![urlStr rangeOfString:@"null"].length) {
        cell.lowView.hidden = NO;
        
        cell.lowView.frame = CGRectMake(10*widthRate, 10*widthRate+CGRectGetHeight(cell.tLab.frame)+CGRectGetHeight(cell.contentLab.frame), DeviceMaxWidth-100*widthRate, 40*widthRate);
        
        cell.bgLab.frame = CGRectMake(60*widthRate, 30*widthRate, DeviceMaxWidth-80*widthRate, 50*widthRate+CGRectGetHeight(cell.tLab.frame)+CGRectGetHeight(cell.contentLab.frame));
    }
    else{
        cell.lowView.hidden = YES;
        
        cell.bgLab.frame = CGRectMake(60*widthRate, 30*widthRate, DeviceMaxWidth-80*widthRate, 10*widthRate+CGRectGetHeight(cell.tLab.frame)+CGRectGetHeight(cell.contentLab.frame));
    }
    
    return cell;
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
