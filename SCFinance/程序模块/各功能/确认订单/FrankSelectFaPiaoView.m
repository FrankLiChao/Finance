//
//  FrankSelectFaPiaoView.m
//  GasStation
//
//  Created by lichao on 15/9/18.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankSelectFaPiaoView.h"
#import "FrankCarNumberCell.h"
#import "lhFirmOrderViewModel.h"
#import "MJRefresh.h"

@interface FrankSelectFaPiaoView (){
    UIButton *titleBtn;  //发票抬头的button
    
    NSInteger tempIndex;
}

@end

@implementation FrankSelectFaPiaoView

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[lhColor shareColor]originalInit:self title:@"选择发票抬头" imageName:nil backButton:YES];
    
    lhNavigationBar * nBar = [[lhNavigationBar alloc]initWithVC:self title:@"选择公司名称" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nBar];
    
    [lhHubLoading addActivityView:self.view];
    [self initFrameView];
    [self requstFaPiaoTitile];
}

/**
 *  请求发票抬头列表
 */
-(void)requstFaPiaoTitile
{
    [lhFirmOrderViewModel getFaPiaoDataSuccess:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _dataArray = response;
            
            if (_dataArray && _dataArray.count) {
                [lhUtilObject removeNullLabelWithSuperView:myTableView];
            }
            else{
                [lhUtilObject addANullLabelWithSuperView:myTableView withText:@"暂无公司名称信息\n请到网站后台添加"];
            }
            [myTableView reloadData];
            
            [myTableView headerEndRefreshing];
            [lhHubLoading disAppearActivitiView];
        });
    }fail:^(id error){
        [lhMainRequest checkRequestFail:error];
        
        [myTableView headerEndRefreshing];
        [lhHubLoading disAppearActivitiView];
    }];
}

/**
 *  初始化页面
 */
-(void)initFrameView
{

    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.separatorColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    [myTableView addHeaderWithTarget:self action:@selector(headerRefreshEvent)];
}

#pragma mark - 下拉刷新
- (void)headerRefreshEvent
{
    [self requstFaPiaoTitile];
}

#pragma mark - UITableViewDataSource

/**
 *  设置cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*widthRate;
}

/**
 *  设置表格的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

/**
 *  初始化cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"couCell";
    
    FrankCarNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[FrankCarNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    cell.carImage.hidden = YES;
    cell.carNumber.frame = CGRectMake(10*widthRate, 0, DeviceMaxWidth-60*widthRate, 40*widthRate);
    NSDictionary * oneD = [self.dataArray objectAtIndex:indexPath.row];
    cell.carNumber.text = [oneD objectForKey:@"name"];
//    if ([[oneD objectForKey:@"title"] isEqualToString:self.titleS]) {
//        cell.hdImage.hidden = NO;
//    }
//    else{
//        cell.hdImage.hidden = YES;
//    }
    
    return cell;
}

/**
 *  响应cell的点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FrankCarNumberCell *cell = (FrankCarNumberCell *)[myTableView cellForRowAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(setCarIdDic:withType:)]) {
        [self.delegate setCarIdDic:[self.dataArray objectAtIndex:indexPath.row] withType:6];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
