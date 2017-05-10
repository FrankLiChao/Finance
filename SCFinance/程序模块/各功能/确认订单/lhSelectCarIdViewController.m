//
//  lhSelectCarIdViewController.m
//  GasStation
//
//  Created by liuhuan on 15/9/17.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSelectCarIdViewController.h"
#import "lhSelectCarIdCell.h"
#import "lhFirmOrderViewModel.h"
#import "MJRefresh.h"

@interface lhSelectCarIdViewController ()<UIAlertViewDelegate>
{
    UITableView * myTableView;//车牌号显示
    
    NSInteger tempIndex;
}

@end

@implementation lhSelectCarIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lhNavigationBar * nBar = [[lhNavigationBar alloc]initWithVC:self title:@"选择车牌" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nBar];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-25*widthRate, 60*widthRate, 18*widthRate)];
    logo.image = imageWithName(@"refreshLogo");
    [self.view addSubview:logo];
    
    _carNumList = [NSMutableArray array];
    
    [self initFrameView];
    [lhHubLoading addActivityView:self.view];
    [self requstCarNumberList];
    
}

-(void)initFrameView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
//    myTableView.scrollEnabled = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    [myTableView addHeaderWithTarget:self action:@selector(headerRefreshEvent)];
    
//    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 5*widthRate)];
//    hView.backgroundColor = lhviewColor;
//    myTableView.tableHeaderView = hView;

}

-(void)requstCarNumberList
{
    [lhFirmOrderViewModel getCarIdDataSuccess:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _carNumList = response;
            
            if (_carNumList && _carNumList.count) {
                [lhUtilObject removeNullLabelWithSuperView:myTableView];
            }
            else{
                [lhUtilObject addANullLabelWithSuperView:myTableView withText:@"暂无配送车辆信息\n请到网站后台添加"];
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

#pragma mark - 下拉刷新
- (void)headerRefreshEvent
{
    [self requstCarNumberList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _carNumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"couCell";
    
    lhSelectCarIdCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[lhSelectCarIdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    if ([_carNumList count]) {
        NSDictionary * dic = [_carNumList objectAtIndex:indexPath.row];
//        NSString * typeStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
//        if ([typeStr integerValue] == 1) {
//            cell.hImgView.image = imageWithName(@"carIdBackgroundBlue");
//        }
//        else if([typeStr integerValue] == 2) {
            cell.hImgView.image = imageWithName(@"carIdBackgroundYellow");
//        }
        NSString * carNumStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        cell.bgCarIdLabel.text = [NSString stringWithFormat:@"%@·%@",[carNumStr substringToIndex:2],[carNumStr substringFromIndex:2]];
        cell.carIdLabel.text = [NSString stringWithFormat:@"%@ %@",[carNumStr substringToIndex:2],[carNumStr substringFromIndex:2]];;
//        if ([[dic objectForKey:@"carnum"] isEqualToString:self.titleS]) {
//            cell.seleImgView.image = imageWithName(@"seletedzhifu");
//        }
//        else{
//            cell.seleImgView.image = imageWithName(@"selectzhifu");
//        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    FrankCarNumberCell *cell = (FrankCarNumberCell *)[myTableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(setCarIdDic:withType:)]) {
        [self.delegate setCarIdDic:[_carNumList objectAtIndex:indexPath.row] withType:5];
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
