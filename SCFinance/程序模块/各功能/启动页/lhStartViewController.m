//
//  lhStartViewController.m
//  SCFinance
//
//  Created by bosheng on 16/6/16.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhStartViewController.h"
#import "lhMainViewController.h"
#import "lhShopCarViewController.h"
#import "lhMessageViewController.h"
#import "lhPersonalCenterViewController.h"
#import "lhTabBar.h"
#import "lhMainViewModel.h"
#import "FrankChooseCityView.h"
#import "lhFirstMainView.h"
#import "UIImage+Cut.h"
#import "UIImageView+WebCache.h"
#import "lhUserProtocolViewController.h"
#import "lhFirstMainView.h"

static lhStartViewController * shareStartVC;

@interface lhStartViewController ()<UIAlertViewDelegate>
{
    BOOL isFirst;//是否第一次运行app
}

@end

@implementation lhStartViewController

+ (instancetype)shareStartVC
{
    if (shareStartVC) {
        return shareStartVC;
    }
    
    shareStartVC = [[lhStartViewController alloc]init];
    return shareStartVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f5f6f7"];
    
    //launch图
    UIImageView * sloganImgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:sloganImgView];
    
    if (iPhone5) {
        sloganImgView.image = imageWithName(@"iPhone5LaunchImage");
    }
    else if(iPhone6){
        sloganImgView.image = imageWithName(@"iPhone6LaunchImage");
    }
    else if (iPhone6plus){
        sloganImgView.image = imageWithName(@"iPhone6pLaunchImage");
    }
    else{
        sloganImgView.image = imageWithName(@"iPhone4LaunchImage");
    }
    
    NSDictionary * adsDic = [[NSUserDefaults standardUserDefaults]objectForKey:mainAdsInfoFile];//本地存储
    if(adsDic && adsDic.count){
        NSString * nameStr = [NSString stringWithFormat:@"%@",[adsDic objectForKey:@"image"]];
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,nameStr];
        
        if ([[lhUtilObject shareUtil]isImageWithName:nameStr]) {
            UIImage * adsImg = [[lhUtilObject shareUtil] readImageWithNameOther:nameStr];
            if (iPhone5 || iPhone6 || iPhone6plus) {
                sloganImgView.image = adsImg;
            }
            else{
                sloganImgView.image = [adsImg clipImageWithScaleWithsize:CGSizeMake(640, 960)];
            }
        }
        else{
            __block UIImageView * tempSloganImgView = sloganImgView;
            [sloganImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:sloganImgView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if(image){
                    [[lhUtilObject shareUtil]saveImagesOther:image withName:nameStr];
                    UIImage * adsImg = image;
                    if (iPhone5 || iPhone6 || iPhone6plus) {
                        tempSloganImgView.image = adsImg;
                    }
                    else{
                        tempSloganImgView.image = [adsImg clipImageWithScaleWithsize:CGSizeMake(640, 960)];
                    }
                }
            }];
        }
    }
    
    NSString * runCountStr = [[NSUserDefaults standardUserDefaults]objectForKey:runCount];
    if ([runCountStr integerValue] != 1) {//第一次运行程序，开场动画
        isFirst = YES;
        [self viewForFirstRun];
        [lhUtilObject shareUtil].noShowKaiChang = YES;
    }
    else{
        //启动页或者版本介绍页完成后
        [self startRequstData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//第一次运行app的引导页
- (void)viewForFirstRun
{
    UIScrollView * maxScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    maxScrollView.tag = 101;
    maxScrollView.pagingEnabled = YES;
    maxScrollView.showsHorizontalScrollIndicator = NO;
    maxScrollView.backgroundColor = [UIColor colorFromHexRGB:@"fbfdff"];
    [self.view addSubview:maxScrollView];
    
    NSArray * imageArray;
    if (iPhone5 || iPhone6 || iPhone6plus) {
        imageArray = @[imageWithName(@"yindaoImage0"),
                       imageWithName(@"yindaoImage1"),
                       imageWithName(@"yindaoImage2")];
    }
    else{
        imageArray = @[imageWithName(@"yindaoImage0_phone4"),
                       imageWithName(@"yindaoImage1_phone4"),
                       imageWithName(@"yindaoImage2_phone4")];
    }
    
    for (int i=0; i<imageArray.count; i++) {
        @autoreleasepool {
            UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*i, 0, DeviceMaxWidth, DeviceMaxHeight)];
            imgView.image = [imageArray objectAtIndex:i];
            [maxScrollView addSubview:imgView];
            if (i == imageArray.count-1) {
                UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                rightBtn.frame = imgView.frame;
                [rightBtn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
                [maxScrollView addSubview:rightBtn];
            }
        }
    }
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth*imageArray.count, DeviceMaxHeight);

}

//点击立即体验
- (void)clickStart
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:runCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //启动页或者版本介绍页完成后
    [self startRequstData];
}

#pragma mark - 开始请求数据
- (void)startRequstData
{
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [[lhUtilObject shareUtil] locationCity:^(NSString *city) {
        
        [lhMainViewModel requestStartDataSuccess:^{
            
            [self checkCity:city];
            
            [lhHubLoading disAppearActivitiView];
            
        }];
    }error:^(NSError *error) {
        
        [lhMainViewModel requestStartDataSuccess:^{
           
            [self locationCityFail];
            
            [lhHubLoading disAppearActivitiView];
        }];
    }];
    
}


//定位失败
- (void)locationCityFail
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取您的位置失败" delegate:self cancelButtonTitle:@"手动选择" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //城市选择
    FrankChooseCityView * fccVC = [[FrankChooseCityView alloc]init];
    fccVC.noBack = YES;
    fccVC.window = self.window;
    [self.navigationController pushViewController:fccVC animated:YES];
    
}

#pragma mark - 判断城市
- (void)checkCity:(NSString *)city
{
    if (city && city.length > 0) {
        
        BOOL isCunZai = NO;//当前定位城市是否支持服务
        for (int j = 0; j < [lhUtilObject shareUtil].allCityArray.count; j++) {
            
            NSDictionary * pDic = [[lhUtilObject shareUtil].allCityArray objectAtIndex:j];
            NSArray * cArray = [pDic objectForKey:@"children"];
            for (int i = 0; i < cArray.count; i++) {
                
                NSDictionary * oneD = [cArray objectAtIndex:i];
                if ([[oneD objectForKey:@"name"]rangeOfString:city].length) {
                    isCunZai = YES;
                    [lhUtilObject shareUtil].nowCityDic = oneD;
                    
                    [[NSUserDefaults standardUserDefaults]setObject:oneD forKey:lastCityInfoFile];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
        }
        
        if (isCunZai) {
//            [lhStartViewController gotoMainView];
            
            if([lhUtilObject shareUtil].mainAdsDic && [lhUtilObject shareUtil].mainAdsDic.count){
                [[lhFirstMainView shareMainView] checkAndShow:YES superView:self.navigationController];
            }
            else{
                [lhStartViewController gotoMainView:nil];
            }
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您所在的城市暂不支持购油服务" delegate:self cancelButtonTitle:@"点击切换" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else{
        [self locationCityFail];
    }
}

#pragma mark - 启动主页
+ (void)gotoMainView:(lhFirstMainView *)kcView
{
    //界面
    lhMainViewController * mVC = [[lhMainViewController alloc]init];
    UINavigationController * nmVC = [[UINavigationController alloc]initWithRootViewController:mVC];
    
    lhShopCarViewController * scVC = [[lhShopCarViewController alloc]init];
    UINavigationController * nscVC = [[UINavigationController alloc]initWithRootViewController:scVC];
    
    lhMessageViewController * msVC = [[lhMessageViewController alloc]init];
    UINavigationController * nmsVC = [[UINavigationController alloc]initWithRootViewController:msVC];
    
    lhPersonalCenterViewController * pcVC = [[lhPersonalCenterViewController alloc]init];
    UINavigationController * npcVC = [[UINavigationController alloc]initWithRootViewController:pcVC];
    
    lhTabBar * tBar = [[lhTabBar shareTabBar]initWithTabViewControlers:@[nmVC,nscVC,nmsVC,npcVC]];
    UINavigationController * ntVC = [[UINavigationController alloc]initWithRootViewController:tBar];
    ntVC.navigationBar.hidden = YES;
    
    [lhStartViewController shareStartVC].window.rootViewController = ntVC;
    
    if(kcView){
        [tBar.view addSubview:kcView];
        
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMainAdsEvent)];
        [kcView.desImgView addGestureRecognizer:tapG];
    }
}

+ (void)tapMainAdsEvent
{
    //跳转url
    NSString * urlS = [NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].mainAdsDic objectForKey:@"link"]];
    
    if (urlS && ![@"" isEqualToString:urlS] && ![urlS rangeOfString:@"null"].length) {
        
        UINavigationController * tbNVC = (UINavigationController *)[lhStartViewController shareStartVC].window.rootViewController;
        
        lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
        upVC.titleStr = @"详情";
        upVC.type = 0;
        upVC.urlStr = urlS;
        [tbNVC pushViewController:upVC animated:YES];
    }
    
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
