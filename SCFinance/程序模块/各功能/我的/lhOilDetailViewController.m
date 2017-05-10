//
//  lhOilDetailViewController.m
//  SCFinance
//
//  Created by bosheng on 16/6/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhOilDetailViewController.h"
#import "lhOilDetailTableViewCell.h"
#import "lhPersonalViewModel.h"
#import "MJRefresh.h"

@interface lhOilDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView * oilTableView;
    
    NSArray * oilArray;
}

@end

@implementation lhOilDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lhNavigationBar * nBar = [[lhNavigationBar alloc]initWithVC:self title:@"已购油量" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nBar];
    
    oilTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    oilTableView.showsVerticalScrollIndicator = NO;
    oilTableView.delegate = self;
    oilTableView.dataSource = self;
    oilTableView.separatorColor = [UIColor clearColor];
    oilTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:oilTableView];
    
    [oilTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    [lhHubLoading addActivityView:self.view];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下拉刷新
- (void)headerRefresh
{
    [self requestData];
}

- (void)requestData
{

    [lhPersonalViewModel requestOilDetailSuccess:^(id response) {
        
        oilArray = response;
        if (oilArray && oilArray.count) {
        
            [lhUtilObject removeNullLabelWithSuperView:oilTableView];
        }
        else{
            [lhUtilObject addANullLabelWithSuperView:oilTableView withText:@"暂未购油"];
        }
        
        [oilTableView reloadData];
        [lhHubLoading disAppearActivitiView];
        [oilTableView headerEndRefreshing];
    }fail:^(id error) {
        [lhMainRequest checkRequestFail:error];
        
        [lhHubLoading disAppearActivitiView];
        [oilTableView headerEndRefreshing];
    }];

}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return oilArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"oilCell";
    
    NSDictionary * dic = [oilArray objectAtIndex:indexPath.row];
    
    lhOilDetailTableViewCell * odtCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (odtCell == nil) {
        odtCell = [[lhOilDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier withData:dic];
    }
    

    return odtCell;
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
