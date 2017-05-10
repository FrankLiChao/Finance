//
//  FrankAboutUsView.m
//  SCFinance
//
//  Created by lichao on 16/6/6.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankAboutUsView.h"
#import "FrankSetView.h"
#import "lhUserProtocolViewController.h"
#import "lhContactUsViewController.h"
#define WXFacialNumber @"优品购油宝"

@interface FrankAboutUsView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * tArray;
}

@end

@implementation FrankAboutUsView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"关于" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nb];
    tArray = @[@[@"用户协议",@"版本介绍",@"联系我们"],
               @[@"关注微信公众号"]];
    [self initFrameView];
}

-(void)initFrameView
{
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, 64+20*widthRate, 60*widthRate, 60*widthRate)];
    imgView.image = imageWithName(@"iconImageClear");
    [self.view addSubview:imgView];
    
    NSDictionary * infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString * nowVersion = [NSString stringWithFormat:@"%@v%@",WXFacialNumber,[infoDict objectForKey:@"CFBundleShortVersionString"]];
    UILabel * versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 64+90*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    versionLabel.text = nowVersion;
    versionLabel.textColor = lhmainColor;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont fontWithName:nowVersion size:14];
    [self.view addSubview:versionLabel];
    
    UITableView * fTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+115*widthRate, DeviceMaxWidth, 239*widthRate) style:UITableViewStylePlain];
    fTableView.scrollEnabled = NO;
    fTableView.delegate = self;
    fTableView.dataSource = self;
    fTableView.separatorColor = [UIColor clearColor];
    fTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fTableView];
    
    NSString * str = @"Copyright ©2016\n成都博晟创信科技有限公司";
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:6];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
    UILabel * bqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, DeviceMaxHeight-60*widthRate, DeviceMaxWidth-20*widthRate, 60*widthRate)];
    bqLabel.numberOfLines = 2;
    bqLabel.font = [UIFont systemFontOfSize:12];
    bqLabel.text = str;
    bqLabel.attributedText = as;
    bqLabel.textColor = lhcontentTitleColorStr2;
    bqLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bqLabel];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                NSString * aStr = @"http://www.gou-you.com/agreement.html";
                lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
                upVC.titleStr = @"用户协议";
                upVC.urlStr = aStr;
                [self.navigationController pushViewController:upVC animated:YES];
                FLLog(@"用户协议");
                break;
            }
            case 1:{
                //版本介绍
                lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
                upVC.urlStr = [NSString stringWithFormat:@"%@client_versionInfo",[lhUtilObject shareUtil].webUrl];
                upVC.titleStr = @"版本介绍";
                [self.navigationController pushViewController:upVC animated:YES];
                FLLog(@"版本介绍");
                break;
            }
            case 2:{
                lhContactUsViewController * cuVC = [[lhContactUsViewController alloc]init];
                [self.navigationController pushViewController:cuVC animated:YES];
                FLLog(@"联系我们");
                break;
            }
            default:
                break;
        }
    }
    else{
        if (indexPath.row == 0) {//关注微信公众号
            //            contact
            //            search
            NSString * str = @"weixin://dl/officialaccounts";
            //    http://weixin.qq.com/r/g3WHn2XETzgwrSH89yCR
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }
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
    
    return tArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [tArray objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"fCell";
    FrankSetView * fCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (fCell == nil) {
        fCell = [[FrankSetView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSArray * arr = [tArray objectAtIndex:indexPath.section];
    
    fCell.titleLabel.text = [arr objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        fCell.topLine.hidden = NO;
    }
    else{
        fCell.topLine.hidden = YES;
    }
    CGRect rec = fCell.lowLine.frame;
    if (indexPath.row < arr.count-1) {
        rec.origin.x = 20*widthRate;
    }
    else{
        rec.origin.x = 0;
    }
    fCell.lowLine.frame = rec;
    
    fCell.yjtImgView.hidden = NO;
    
    if (indexPath.section == 1) {
        CGRect rec = fCell.titleLabel.frame;
        rec.origin.x = 45*widthRate;
        fCell.titleLabel.frame = rec;
        
        UIImageView * hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*widthRate, 14.5*widthRate, 20*widthRate, 20*widthRate)];
        [fCell addSubview:hImgView];
        
        UILabel * conLabel = [[UILabel alloc] initWithFrame:CGRectMake(150*widthRate, 0, DeviceMaxWidth-180*widthRate, 49*widthRate)];
        conLabel.textAlignment = NSTextAlignmentRight;
        conLabel.textColor = lhcontentTitleColorStr1;
        conLabel.font = [UIFont systemFontOfSize:12];
        [fCell addSubview:conLabel];
        
        if (indexPath.row == 0) {
            hImgView.image = imageWithName(@"aboutWeChatIcon");
            conLabel.text = WXFacialNumber;
        }
    }
    
    return fCell;
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
