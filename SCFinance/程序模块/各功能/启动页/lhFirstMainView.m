//
//  lhMainView.m
//  GasStation
//
//  Created by bosheng on 16/3/14.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhFirstMainView.h"
#import "UIImage+Cut.h"
#import "UIImageView+WebCache.m"
#import "lhStartViewController.h"
#import "lhUserProtocolViewController.h"

#define lastShowTime @"mainAdsLastShowTime"

static lhFirstMainView * onlyMainView;

@interface lhFirstMainView()<UIAlertViewDelegate>
{
    BOOL appIsLaunchRun;//上次是否大退
    
    UINavigationController * tempVC;//父视图
}

@end

@implementation lhFirstMainView

+ (instancetype)shareMainView
{
    if (onlyMainView) {
        return onlyMainView;
    }
    
    onlyMainView = [[lhFirstMainView alloc]init];
    [onlyMainView firmInit];
    
    return onlyMainView;
}

- (void)firmInit
{
    self.desImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    self.desImgView.alpha = 0;
    self.desImgView.backgroundColor = [UIColor whiteColor];
    self.desImgView.userInteractionEnabled = YES;
    [onlyMainView addSubview:self.desImgView];

    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.frame = CGRectMake(DeviceMaxWidth-76*widthRate, 20+10*widthRate, 66*widthRate, 40*widthRate);
    [self.skipButton setImage:imageWithName(@"skipButtonImage") forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [onlyMainView addSubview:self.skipButton];
    
    self.skipButton.hidden = YES;
    self.desImgView.userInteractionEnabled = NO;
    self.skipButton.userInteractionEnabled = NO;
}

+ (void)removeSelfFromSuperView
{
    if (onlyMainView) {
        [onlyMainView removeFromSuperview];
        onlyMainView = nil;
    }
}

+ (instancetype)gOnlyMainView
{
    return onlyMainView;
}

#pragma mark - 检测显示进场广告
- (void)checkAndShow:(BOOL)isLaunchRun superView:(UINavigationController *)superView
{
    if([lhUtilObject shareUtil].noShowKaiChang){//不检测展示广告
        return;
    }
    appIsLaunchRun = isLaunchRun;
    tempVC = superView;
    
    onlyMainView.frame = [UIScreen mainScreen].bounds;
    onlyMainView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:onlyMainView action:@selector(tapMainAdsEvent)];
    [onlyMainView.desImgView addGestureRecognizer:tapG];
    
    [self checkAndShowMainAds1];
}

- (void)checkAndShowMainAds1
{
    //同一个广告间隔一个小时显示一次，不同广告直接显示
    NSDictionary * adsDic = [[NSUserDefaults standardUserDefaults]objectForKey:mainAdsInfoFile];//本地存储
    if(adsDic && adsDic.count){

        NSString * lastIdStr = [NSString stringWithFormat:@"%@",[adsDic objectForKey:@"image"]];
        NSString * nowIdStr = [NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].mainAdsDic objectForKey:@"image"]];
        if (![lastIdStr isEqualToString:nowIdStr]) {
            [self addAds];
        }
        else{
            if (appIsLaunchRun) {//app大退后打开
                [self addAds];
            }
            else{
                NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
                NSTimeInterval lastTime = [[adsDic objectForKey:lastShowTime] doubleValue];
                if (nowTime - lastTime >= 1200) {//1200,大于等于20分钟
                    [self addAds];
                }
                else{
                    [lhFirstMainView removeSelfFromSuperView];
                }
            }
        }
    }
    else{
        [self addAds];
    }
    
}

- (void)addAds
{
    NSLog(@"bbbbbbb");
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    
    NSString * nameStr = [NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].mainAdsDic objectForKey:@"image"]];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,nameStr];
    
    if ([[lhUtilObject shareUtil]isImageWithName:nameStr]) {
        UIImage * adsImg = [[lhUtilObject shareUtil] readImageWithNameOther:nameStr];
        if (iPhone5 || iPhone6 || iPhone6plus) {
            onlyMainView.desImgView.image = adsImg;
        }
        else{
            onlyMainView.desImgView.image = [adsImg clipImageWithScaleWithsize:CGSizeMake(640, 960)];
        }
        [tempVC.view addSubview:onlyMainView];
        
        self.desImgView.alpha = 1;
        self.skipButton.hidden = NO;
        self.desImgView.userInteractionEnabled = YES;
        self.skipButton.userInteractionEnabled = YES;
        
        if (appIsLaunchRun) {
            [self skipButtonEvent];//现将其加在主页上
        }
        [self performSelector:@selector(skipButtonEvent) withObject:nil afterDelay:5.0];//5s后自动跳过
        
        NSLog(@"----------");
    }
    else{
        __weak lhFirstMainView * tempMainView = onlyMainView;
        [onlyMainView.desImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            if(image){
                
                NSLog(@"+++++++++");
                
                [[lhUtilObject shareUtil]saveImagesOther:image withName:nameStr];
                UIImage * adsImg = image;
                if (iPhone5 || iPhone6 || iPhone6plus) {
                    tempMainView.desImgView.image = adsImg;
                }
                else{
                    tempMainView.desImgView.image = [adsImg clipImageWithScaleWithsize:CGSizeMake(640, 960)];
                }
                [tempVC.view addSubview:onlyMainView];
                
                tempMainView.desImgView.alpha = 1;
                tempMainView.skipButton.hidden = NO;
                tempMainView.desImgView.userInteractionEnabled = YES;
                tempMainView.skipButton.userInteractionEnabled = YES;
                
                if (appIsLaunchRun) {
                    [self skipButtonEvent];//现将其加在主页上
                }
                [self performSelector:@selector(skipButtonEvent) withObject:nil afterDelay:5.0];//5s后自动跳过
            }
        }];
    }
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:[lhUtilObject shareUtil].mainAdsDic];
    NSString * showTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [tempDic setObject:showTime forKey:lastShowTime];
    
    [[NSUserDefaults standardUserDefaults]setObject:tempDic forKey:mainAdsInfoFile];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

//跳过
- (void)skipButtonEvent
{
    if (appIsLaunchRun) {
        appIsLaunchRun = NO;
        [lhStartViewController gotoMainView:[lhFirstMainView shareMainView]];
    }
    else{
        [NSObject cancelPreviousPerformRequestsWithTarget:onlyMainView selector:@selector(skipButtonEvent) object:nil];//取消延时操作
        
        [UIView animateWithDuration:0.5 animations:^{
            onlyMainView.alpha = 0;
            onlyMainView.transform = CGAffineTransformMakeScale(2, 2);
        }completion:^(BOOL finished) {
            [onlyMainView removeFromSuperview];
            onlyMainView = nil;
        }];
    }
}

- (void)tapMainAdsEvent
{
    [lhFirstMainView removeSelfFromSuperView];
    
    //跳转url
    NSString * urlS = [NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].mainAdsDic objectForKey:@"link"]];
    if (urlS && ![@"" isEqualToString:urlS] && ![urlS rangeOfString:@"null"].length) {
        
        lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
        upVC.titleStr = @"详情";
        upVC.type = appIsLaunchRun?5:0;
        upVC.urlStr = urlS;
        [tempVC pushViewController:upVC animated:YES];
    }
}

#pragma mark - 弹一个提示框，诱导用户评论
- (void)showComentAlert
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"致用户的一封信" message:@"您好，有了您的支持和反馈才能更好的为您服务，为您提供更加适合的app。您有什么问题也可以直接反馈给我们。" delegate:self cancelButtonTitle:@"好评赞赏" otherButtonTitles:@"残忍拒绝",@"我要吐槽", nil];
    [alert show];
    
    NSDictionary * infoDict = [[NSBundle mainBundle]infoDictionary];
    NSMutableString * nowVersion = [NSMutableString stringWithFormat:@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
    [[NSUserDefaults standardUserDefaults]setObject:nowVersion forKey:saveCommentLocalVersion];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 2) {
        NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/you-pin-gou-you-bao-tuan-hao/id1128290296?l=zh&ls=1&mt=8"];
        [[UIApplication sharedApplication]openURL:url];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
