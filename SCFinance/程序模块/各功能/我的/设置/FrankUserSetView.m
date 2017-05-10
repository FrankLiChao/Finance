//
//  FrankUserSetView.m
//  Drive
//
//  Created by lichao on 15/8/20.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankUserSetView.h"
#import "FrankSetView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "lhNavigationBar.h"
#import "FrankFeedbackView.h"
#import "FrankAboutUsView.h"
#import "lhUserProtocolViewController.h"

@interface FrankUserSetView (){
    UIScrollView * maxScrollView;
    NSArray     *tabArray;//表格数据
    NSString    * urlStr;//给我评分URL
}

@end

@implementation FrankUserSetView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"设置" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nb];
    self.view.backgroundColor = [UIColor whiteColor];
    urlStr = @"";
    
    unsigned long long length = [[SDImageCache sharedImageCache]getSize];
    NSLog(@"大小=%f==%f",(CGFloat)length/1000/1000,[lhUtilObject cacheLength]);
    
    [self initFrameView];
}

-(void)initFrameView{
    tabArray = @[@[@"战略合作",@"消息推送"],
                 @[@"给我好评",@"意见反馈",@"清除缓存"],
                 @[@"分享给朋友",@"关于优品"]];
    maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.backgroundColor = lhviewColor;
    [self.view addSubview:maxScrollView];
    
    CGFloat heih = 0;
    
    UITableView * sTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 409*widthRate) style:UITableViewStylePlain];
    sTableView.scrollEnabled = NO;
    sTableView.delegate = self;
    sTableView.dataSource = self;
    sTableView.separatorColor = [UIColor clearColor];
    sTableView.backgroundColor = [UIColor clearColor];
    [maxScrollView addSubview:sTableView];
    
    heih += 431*widthRate;
    
    UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(0, heih, DeviceMaxWidth, 49*widthRate);
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn setTitle:@"退出优品" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [exitBtn setTitleColor:[UIColor colorFromHexRGB:@"f96268"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [maxScrollView addSubview:exitBtn];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [exitBtn addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49*widthRate-0.5, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [exitBtn addSubview:lineView1];
    
//    heih += 49*widthRate + 40*widthRate;
    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-40*widthRate)/2, heih, 40*widthRate, 30*widthRate)];
//    imageV.backgroundColor = [UIColor lightGrayColor];
//    [maxScrollView addSubview:imageV];
    
    heih += 80*widthRate;
    
//    UILabel *bqLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, heih, DeviceMaxWidth-30*widthRate, 20*widthRate)];
//    bqLab.text = @"2016 @@ 版权号 版权号";
//    bqLab.textColor = [UIColor lightGrayColor];;
//    bqLab.font = [UIFont systemFontOfSize:13];
//    bqLab.textAlignment = NSTextAlignmentCenter;
//    [maxScrollView addSubview:bqLab];
    
    NSString * str = @"Copyright ©2016\n成都博晟创信科技有限公司";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
    BOOL isEnouph = NO;
    if (iPhone5 || iPhone6 || iPhone6plus) {
        isEnouph = YES;
    }
    UILabel * bqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, isEnouph?CGRectGetHeight(maxScrollView.frame)-60*widthRate:heih, DeviceMaxWidth-20*widthRate, 60*widthRate)];
    bqLabel.numberOfLines = 2;
    bqLabel.font = [UIFont systemFontOfSize:12];
    bqLabel.text = str;
    bqLabel.attributedText = as;
    bqLabel.textColor = lhcontentTitleColorStr2;
    bqLabel.textAlignment = NSTextAlignmentCenter;
    [maxScrollView addSubview:bqLabel];

    heih += 60*widthRate;
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, heih);
}

#pragma mark - 退出登录
- (void)exitBtnEvent
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - 清除缓存
- (void)clearTmpPics
{
    [lhHubLoading addActivityView:self.view];
    [[lhUtilObject shareUtil]removeAllImage];
    [[SDImageCache sharedImageCache] clearDisk:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [lhHubLoading disAppearActivitiView];
            [lhUtilObject showAlertWithMessage:@"清除缓存成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        });
    }];
    
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) //战略合作
            {
                FLLog(@"点击战略合作");
                
                lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
                upVC.titleStr = @"战略合作";
                upVC.urlStr = @"http://www.gou-you.com/cooperation.html";
                [self.navigationController pushViewController:upVC animated:YES];
            }
            break;
        }
        case 1:{
            if (indexPath.row == 0) //给我好评
            {
                urlStr = @"https://itunes.apple.com/us/app/you-pin-gou-you-bao-tuan-hao/id1128290296?l=zh&ls=1&mt=8";
                if (!urlStr || [@"" isEqualToString:urlStr] || [urlStr rangeOfString:@"null"].length)
                {
                    [lhUtilObject showAlertWithMessage:@"暂无链接" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                }
                else if ([@"0" isEqualToString:urlStr])
                {
                    [lhUtilObject showAlertWithMessage:@"获取链接失败" withSuperView:self.view withHeih:DeviceMaxHeight/2];
                }
                else
                {
                    [lhUtilObject shareUtil].noShowKaiChang = YES;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }else if (indexPath.row == 1) //表示意见反馈
            {
                FrankFeedbackView *feedBack = [[FrankFeedbackView alloc] init];
                [self.navigationController pushViewController:feedBack animated:YES];
            
            }
            else if (indexPath.row == 2) //清除缓存
            {
                [self clearTmpPics];
            }
            break;
        }
        case 2:{
            if (indexPath.row == 0) //APP分享
            {
                NSString * cStr= @"我正在使用<优品购油宝>，买油也能团购，单次购买越多，优惠越大；直购公开透明，品质保障无差价。再也不用担心买油无门啦~";
                UIImage * imgV = imageWithName(@"iconImg");
                NSString * urlString = @"http://www.gou-you.com/downApp.html";
                [lhUtilObject fxViewAppear:imgV conStr:cStr withUrlStr:urlString withVc:self];
            }else if (indexPath.row == 1)
            {
                FLLog(@"点击关于优品");
                FrankAboutUsView *aboutView = [FrankAboutUsView new];
                [self.navigationController pushViewController:aboutView animated:YES];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {
        
        [lhUtilObject shareUtil].isOnLine = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //退出登录后将自动登录时间改为当前时间
        double tim = (double)[[NSDate date]timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [lhTabBar shareTabBar].selectedIndex = 0;
        [[lhTabBar shareTabBar] sizeToFitWithText:@"0"];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49*widthRate;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 22*widthRate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 22*widthRate)];
    hView.backgroundColor = lhviewColor;
    
    return hView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return tabArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [tabArray objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"sCell";
    FrankSetView * sCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (sCell == nil) {
        sCell = [[FrankSetView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSArray * arr = [tabArray objectAtIndex:indexPath.section];
    sCell.titleLabel.text = [arr objectAtIndex:indexPath.row];
    sCell.mSwitch.on = ![[lhUserModel shareUserModel].tokenSwitch boolValue];
    
    sCell.topLine.hidden = YES;
    sCell.lowLine.hidden = NO;
    
    if (indexPath.row == 0) {
        sCell.topLine.hidden = NO;
    }
    else{
        sCell.topLine.hidden = YES;
    }
    CGRect rec = sCell.lowLine.frame;
    if (indexPath.row < arr.count-1 && arr.count > 1) {
        rec.origin.x = 15*widthRate;
    }
    else{
        rec.origin.x = 0;
    }
    sCell.lowLine.frame = rec;
    if (indexPath.row == 1 && indexPath.section == 0) {
        sCell.yjtImgView.hidden = YES;
        sCell.mSwitch.hidden = NO;
        [sCell.mSwitch addTarget:self action:@selector(mySwitchEvent:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    return sCell;
}

-(void)mySwitchEvent:(UISwitch *)swich_
{
    
    NSDictionary *dic = @{@"userId":[lhUserModel shareUserModel].userId,
                          @"isOpen":[NSString stringWithFormat:@"%@",swich_.on?@"0":@"1"]};
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"clientInfo_updateTokenSwitch") parameters:dic method:@"POST" success:^(id responseObject) {
        NSString *showStr = nil;
        if (swich_.isOn) {
            showStr = @"开关打开~";
            [lhUserModel shareUserModel].tokenSwitch = @"0";
        }else{
            showStr = @"开关关闭~";
            [lhUserModel shareUserModel].tokenSwitch = @"1";
        }
        [lhUtilObject showAlertWithMessage:showStr withSuperView:self.view withHeih:DeviceMaxHeight/2];
        [lhHubLoading disAppearActivitiView];
    } fail:^(id error){
        [lhMainRequest checkRequestFail:error];
        [lhHubLoading disAppearActivitiView];
        swich_.on = ![[lhUserModel shareUserModel].tokenSwitch boolValue];
    }];
}

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
