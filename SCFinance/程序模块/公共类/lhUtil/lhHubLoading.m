//
//  lhHubLoading.m
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhHubLoading.h"
#import "UIImage+GIF.h"

static UIView * nowView;

@implementation lhHubLoading

#pragma mark - 正在加载仅显示一个activity
+ (void)addActivityView1OnlyActivityView:(UIView *)nView
{
    [self disAppearActivitiView];
    
    nowView = nView;
    
    UIActivityIndicatorView *waitActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((DeviceMaxWidth-60)/2, (DeviceMaxHeight-60)/2, 60, 60)];
    waitActivity.tag = activityTag;
    waitActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [nView addSubview:waitActivity];
    [waitActivity startAnimating];
    
    [self closeUserEnable];
}

//正在连接
+ (void)addActivityView:(UIView *)nView
{
    [self disAppearActivitiView];
    nowView = nView;

    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 95)];
    aView.layer.cornerRadius = 10;
    aView.layer.allowsEdgeAntialiasing = YES;
    aView.layer.masksToBounds = YES;
    aView.tag = activityTag;
    aView.center = nView.center;
    aView.backgroundColor = lhmainColorBlack;
    [nView addSubview:aView];
    
    UIActivityIndicatorView *waitActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30, 5, 60, 60)];
    waitActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [aView addSubview:waitActivity];
    [waitActivity startAnimating];
    
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 120, 15)];
    la.textAlignment = NSTextAlignmentCenter;
    la.textColor = [UIColor whiteColor];
    la.font = [UIFont systemFontOfSize:15];
    la.text = @"努力加载中";
    [aView addSubview:la];
    
    [self closeUserEnable];
}

//+ (void)addActivityView123:(UIView *)nView activityType:(lhActivityType)aType
//{
//    [self disAppearActivitiView];
//    nowView = nView;
//    
//    CGFloat originY = 0.0;
//    CGFloat heih = DeviceMaxHeight;
//    switch (aType) {
//        case lhActivityTypeTop:{
//            originY = 64;
//            heih = DeviceMaxHeight-64;
//            break;
//        }
//        case lhActivityTypeLow:{
//            originY = 0;
//            heih = DeviceMaxHeight-49;
//            break;
//        }
//        case lhActivityTypeMin:{
//            originY = 64;
//            heih = DeviceMaxHeight-113;
//            break;
//        }
//        default:
//            break;
//    }
//    
//    UIView * maxView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, CGRectGetWidth(nView.frame), heih)];
//    maxView.tag = activityTag;
//    maxView.backgroundColor = [UIColor whiteColor];
//    [nView addSubview:maxView];
//    
//    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, (heih-148*widthRate)/2, 120*widthRate, 148*widthRate)];
//    //    aView.layer.cornerRadius = 4*widthRate;
//    //    aView.layer.masksToBounds = YES;
//    aView.center = CGPointMake(nView.center.x, nView.center.y-64);
//    aView.backgroundColor = [UIColor clearColor];
//    [maxView addSubview:aView];
//    
////    NSMutableArray * imgA = [NSMutableArray array];
////    for (int i = 11; i >= 0; i--) {
////        NSString * imgStr = [NSString stringWithFormat:@"activityImage%d",i];
////        [imgA addObject:imageWithName(imgStr)];
////    }
//    
//    UIImageView * actImgView = [[UIImageView alloc]initWithFrame:CGRectMake(30*widthRate, 44*widthRate, 60*widthRate, 60*widthRate)];
//    actImgView.tag = activityImgTag;
////    actImgView.image = imgA;
////    actImgView.animationRepeatCount = 100000;
////    actImgView.animationDuration = 0.15;
//    [aView addSubview:actImgView];
////    [actImgView startAnimating];
//    
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"refreshImage" ofType:@"gif"];;
//    NSData * picData = [[NSData alloc]initWithContentsOfFile:path];
//    if (picData) {
//        UIImage * img = [UIImage sd_animatedGIFWithData:picData];//可自己控制执行时间
//        dispatch_async(dispatch_get_main_queue(), ^{
//            actImgView.image = img;
//        });
//    }
//    
//    [self closeUserEnable];
//}

+ (void)disAppearActivitiView
{
    
    UIView * aView = (UIView *)[nowView viewWithTag:activityTag];
    UIImageView * imgView = (UIImageView *)[nowView viewWithTag:activityImgTag];
    if (aView) {
        if (imgView) {
            [imgView stopAnimating];
        }
        [aView removeFromSuperview];
        aView = nil;
        
        [self openUserEnable];
    }
    
}

+ (void)closeUserEnable
{
    for (UIView * view in nowView.subviews) {
        view.userInteractionEnabled = NO;
//        for (UIView * v in view.subviews) {
//            if (v.tag == backBtnTag) {
//                view.userInteractionEnabled = YES;
//                v.userInteractionEnabled = YES;
//            }
//            else{
//               v.userInteractionEnabled = NO;
//            }
//        }
    }
}

+ (void)openUserEnable
{
    for (UIView * view in nowView.subviews) {
//        for (UIView * v in view.subviews) {
//            v.userInteractionEnabled = YES;
//        }
        view.userInteractionEnabled = YES;
    }
}

@end
