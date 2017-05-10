//
//  FrankChooseCityView.m
//  SCFinance
//
//  Created by lichao on 16/6/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankChooseCityView.h"
#import "FrankCityCell.h"
#import "FrankAutoLayout.h"
#import "FrankNowCityCell.h"
#import "FrankTools.h"
#import "lhMainViewController.h"
#import "lhShopCarViewController.h"
#import "lhMessageViewController.h"
#import "lhPersonalCenterViewController.h"
#import "lhTabBar.h"
#import "lhTeamBuyViewController.h"
#import "lhStartViewController.h"

@interface FrankChooseCityView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    NSMutableArray *cityArray;
    
    NSString * nowCityStr;
}

@end

@implementation FrankChooseCityView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"区域选择" isBackBtn:!_noBack rightBtn:nil];
    [self.view addSubview:nb];
    
    [self initData];
}

-(void)initData
{
    [lhHubLoading addActivityView:self.view];
    [[lhUtilObject shareUtil]locationCity:^(NSString *city) {
        [self locationFailOrSuccess:city];
    } error:^(NSError *error) {
        [self locationFailOrSuccess:@""];
    }];
    
}

//定位城市结果
- (void)locationFailOrSuccess:(NSString *)cityStr
{
    nowCityStr = cityStr;
    
    NSDictionary * dic = nil;
    if (cityStr && cityStr.length) {
        dic = @{@"name":cityStr};
    }
    else{
        dic = @{@"name":@"获取失败"};
    }
    
    cityArray = [NSMutableArray arrayWithArray:[lhUtilObject shareUtil].allCityArray];
    [cityArray insertObject:dic atIndex:0];
    
    [self initFrameView];
}

-(void)initFrameView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = lhviewColor;
    [self.view addSubview:myTableView];
    
    [lhHubLoading disAppearActivitiView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100*widthRate;
    }
    else{
        CGFloat hight = [myTableView cellHeightForIndexPath:indexPath cellContentViewWidth:DeviceMaxWidth-40*widthRate tableView:tableView];
        
        return hight+10*widthRate;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { //FrankNowCityCell
        static NSString * tifier = @"FrankNowCityCell";
        
        FrankNowCityCell *nCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (nCell == nil) {
            nCell = [[FrankNowCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        nCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * cityStr = [[cityArray objectAtIndex:0] objectForKey:@"name"];
        
        CGFloat widsize = [FrankTools sizeForString:cityStr withSizeOfFont:[UIFont systemFontOfSize:15]];
        nCell.nowCityLab.frame = CGRectMake(23*widthRate, 0, widsize, 30*widthRate);
        nCell.nowCityLab.text = cityStr;
        
        nCell.bgView.frame = CGRectMake(20*widthRate, 60*widthRate, CGRectGetWidth(nCell.nowCityLab.frame)+28*widthRate, 30*widthRate);
        
        nCell.nowCityBtn.frame = nCell.bgView.frame;
        [nCell.nowCityBtn addTarget:self action:@selector(nowCityBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        
        return nCell;
    }else
    {
        static NSString * tifier1 = @"cellName";
        
        FrankCityCell *cell = [tableView dequeueReusableCellWithIdentifier:tifier1];
        NSDictionary *dic = [cityArray objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[FrankCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier1 withData:dic];
        }
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clickCityButtonEvent:(NSString *)cityStr
{
    for (int j = 0; j < [lhUtilObject shareUtil].allCityArray.count; j++) {
        NSDictionary * pDic = [[lhUtilObject shareUtil].allCityArray objectAtIndex:j];
        NSArray * cArray = [pDic objectForKey:@"children"];
        for (int i = 0; i < cArray.count; i++) {
            NSDictionary * oneD = [cArray objectAtIndex:i];
            if ([[oneD objectForKey:@"name"]rangeOfString:cityStr].length) {
                if (self.type == 5) {
                    self.delegate.filterCityDic = oneD;
                }
                else{
                    [[NSUserDefaults standardUserDefaults]setObject:oneD forKey:lastCityInfoFile];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [lhUtilObject shareUtil].nowCityDic = oneD;
                }
            }
        }
    }
    
    if (_noBack) {
        [lhStartViewController gotoMainView:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//点击定位城市
- (void)nowCityBtnEvent
{
    if (nowCityStr && nowCityStr.length) {
        BOOL isCunZai = NO;//当前定位城市是否支持服务
        for (int j = 0; j < [lhUtilObject shareUtil].allCityArray.count; j++) {
            NSDictionary * pDic = [[lhUtilObject shareUtil].allCityArray objectAtIndex:j];
            NSArray * cArray = [pDic objectForKey:@"children"];
            for (int i = 0; i < cArray.count; i++) {
                NSDictionary * oneD = [cArray objectAtIndex:i];
                if ([[oneD objectForKey:@"name"]rangeOfString:nowCityStr].length) {
                    isCunZai = YES;
                   
                    if (self.type == 5) {
                        self.delegate.filterCityDic = oneD;
                    }
                    else{
                        [[NSUserDefaults standardUserDefaults]setObject:oneD forKey:lastCityInfoFile];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [lhUtilObject shareUtil].nowCityDic = oneD;
                    }
                    
                }
            }
        }
        
        if (isCunZai) {
            if (_noBack) {
                [lhStartViewController gotoMainView:nil];
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [lhUtilObject showAlertWithMessage:@"当前城市暂不支持购油服务" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        }
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
