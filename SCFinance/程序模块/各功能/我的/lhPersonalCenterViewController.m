//
//  lhPersonalCenterViewController.m
//  SCFinance
//
//  Created by bosheng on 16/5/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhPersonalCenterViewController.h"
#import "FrankUserSetView.h"
#import "lhPersonalView.h"
#import "lhPersonalViewModel.h"
#import "lhMineTableViewCell.h"
#import "FrankDirectView.h"
#import "FrankTools.h"
#import "lhOilDetailViewController.h"
#import "FrankPersonalMsg.h"
#import "FrankGroupView.h"
#import "lhUserProtocolViewController.h"
#import "FrankTakeOilView.h"
#import "lhMessageListViewController.h"

@interface lhPersonalCenterViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    lhPersonalView * pView;
    
    lhNavigationBar * nBar;//导航栏
    
    UIImageView * hImgView;//头像
    UILabel * nameLabel;//姓名
}

@end

@implementation lhPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    pView = [[lhPersonalView alloc]initWithFrame:self.view.bounds];
    pView.maxScrollView.delegate = self;
    [pView.topView addGestureRecognizer:tapG];
    [pView.buyBtn addTarget:self action:@selector(buyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [pView.teamBuyBtn addTarget:self action:@selector(teamBuyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    pView.funTableView.delegate = self;
    pView.funTableView.dataSource = self;
    [self.view addSubview:pView];
    
    nBar = [[lhNavigationBar alloc]initWithVC:self title:@"" isBackBtn:NO rightBtn:nil];
    nBar.alpha = 0;
    [self.view addSubview:nBar];
    
    hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 22, 40, 40)];
    hImgView.layer.masksToBounds = YES;
    hImgView.layer.cornerRadius = 20;
    hImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImageEvent)];
    [hImgView addGestureRecognizer:tapImage];
    [self.view addSubview:hImgView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate+45, 22, DeviceMaxWidth/2, 40)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nameLabel];
    
    UIButton * setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setTitle:@"设置" forState:UIControlStateNormal];
    [setButton setTitleColor:lhmainColor forState:UIControlStateNormal];
    setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    setButton.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
    [setButton addTarget:self action:@selector(setButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    CGFloat heih = pView.funTableView.frame.origin.y+CGRectGetHeight(pView.funTableView.frame)+20*widthRate;
    
    if (heih > CGRectGetHeight(pView.maxScrollView.frame)+0.5) {
        pView.maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
    }
    else{
        pView.maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, CGRectGetHeight(pView.maxScrollView.frame)+0.5);
    }
    
    [pView setMyOilView:[lhUtilObject shareUtil].remainOilArray];
    
}

-(void)tapHeadImageEvent
{
    FrankPersonalMsg *personView = [FrankPersonalMsg new];
    [[lhTabBar shareTabBar].navigationController pushViewController:personView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击查看余油详情
- (void)tapEvent
{
    /*//暂时注释掉
    lhOilDetailViewController * odVC = [[lhOilDetailViewController alloc]init];
    [[lhTabBar shareTabBar].navigationController pushViewController:odVC animated:YES];
     */
    FrankTakeOilView *oilView = [FrankTakeOilView new];
    [[lhTabBar shareTabBar].navigationController pushViewController:oilView animated:YES];
}

#pragma mark - 跳转到设置界面
-(void)setButtonEvent
{
    if([lhUtilObject loginIsOrNot]){
        FrankUserSetView *setView = [FrankUserSetView new];
        [[lhTabBar shareTabBar].navigationController pushViewController:setView animated:YES];
    }
}

#pragma mark - 直购订单和团购订单事件
- (void)buyBtnEvent
{
    NSLog(@"直购订单");
    FrankDirectView * oVC = [[FrankDirectView alloc]init];
    [[lhTabBar shareTabBar].navigationController pushViewController:oVC animated:YES];
}

- (void)teamBuyBtnEvent
{
    NSLog(@"团购订单");
    FrankGroupView * oVC = [[FrankGroupView alloc]init];
    [[lhTabBar shareTabBar].navigationController pushViewController:oVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    nBar.alpha = scrollView.contentOffset.y/(216*widthRate);
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        
        lhMessageListViewController * mlVC = [[lhMessageListViewController alloc]init];
        [[lhTabBar shareTabBar].navigationController pushViewController:mlVC animated:YES];
    }
    else if(indexPath.row == 1){
        
        lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
        upVC.urlStr = [NSString stringWithFormat:@"%@help_findHelpList",[lhUtilObject shareUtil].webUrl];
        upVC.titleStr = @"帮助中心";
        [[lhTabBar shareTabBar].navigationController pushViewController:upVC animated:YES];
        
    }
    else {
        [lhUtilObject detailPhone:ourServicePhone];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lhPersonalViewModel funArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"cCell";
    lhMineTableViewCell * cCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cCell == nil) {
        cCell = [[lhMineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSArray * funArray = [lhPersonalViewModel funArray];
    
    cCell.titleLab.text = [[funArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cCell.hImgView.image = imageWithName([[funArray objectAtIndex:indexPath.row] objectForKey:@"image"]);
    
    if (indexPath.row == 0) {
        NSString * messageCount = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:saveAllMessageFile]];
        if ([messageCount integerValue] < [[lhUserModel shareUserModel].messageNum integerValue]) {
            cCell.circleView.hidden = NO;
        }
        else{
            cCell.circleView.hidden = YES;
        }
        cCell.subTitleLab.text = [lhUserModel shareUserModel].messageTitle;
    }
    else{
        cCell.subTitleLab.text = [[funArray objectAtIndex:indexPath.row] objectForKey:@"subTitle"];
        cCell.circleView.hidden = YES;
    }
    
//    if (indexPath.row == funArray.count-1) {
//        cCell.lineView.hidden = YES;
//    }
//    else{
//        cCell.lineView.hidden = NO;
//    }
    
    return cCell;
}

#pragma mark - 登录和未登录赋值
//已登录
- (void)isLogin
{
    hImgView.hidden = NO;
    
    NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,[lhUserModel shareUserModel].photo];
    [lhUtilObject checkImageWithImageView:hImgView withImage:[lhUserModel shareUserModel].photo withImageUrl:allStr withPlaceHolderImage:imageWithName(defaultHeadUser)];
    if ([[lhUserModel shareUserModel].name isEqualToString:@""] || [lhUserModel shareUserModel].name == nil) {
        nameLabel.text = [FrankTools replacePhoneNumber:[lhUserModel shareUserModel].phone];
    }else{
        nameLabel.text = [lhUserModel shareUserModel].name;
    }
    
    //刷新余油信息
    [lhMainRequest HTTPPOSTNormalRequestForURL:[NSString stringWithFormat:@"%@client_myAllRemainOil",[lhUtilObject shareUtil].webUrl] parameters:@{@"userId":[lhUserModel shareUserModel].userId} method:@"POST" success:^(id responseObject) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [pView setMyOilView:responseObject];
        });
        
    } fail:nil];
    
}

//未登录
- (void)noLogin
{
    hImgView.hidden = YES;
    
    nameLabel.frame = CGRectMake(15*widthRate, 22, DeviceMaxWidth/2, 40);
    nameLabel.text = @"未登录";
    
    [pView setMyOilView:nil];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([lhUtilObject shareUtil].isOnLine) {
        [self isLogin];
//    }
//    else{
//        [self noLogin];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
