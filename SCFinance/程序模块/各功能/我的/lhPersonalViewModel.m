//
//  lhPersonalViewModel.m
//  SCFinance
//
//  Created by bosheng on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhPersonalViewModel.h"

@implementation lhPersonalViewModel


//获取余油详情
+ (void)requestOilDetailSuccess:(void (^)(id))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_myListRemainOil"];
    
    NSDictionary * parameters = @{@"userId":[lhUserModel shareUserModel].userId};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

+ (void)requestMessageInfoPno:(NSInteger)pno success:(void (^)(id))success fail:(void (^)(id))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_messageCenter"];
    
    NSDictionary * parameters = @{
        @"userId":[lhUserModel shareUserModel].userId,
        @"pageNo":[NSString stringWithFormat:@"%ld",(long)pno],
        @"pageSize":@"12"};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}


+ (NSArray *)funArray
{
    return @[
  @{@"subTitle":@"个人中心的消息中心",@"title":@"消息中心",@"image":@"personalMessageImage"},
  @{@"subTitle":@"遇到问题，查看帮助中心",@"title":@"帮助中心",@"image":@"personalHelpImage"},
  @{@"subTitle":[NSString stringWithFormat:@"客服热线：%@",ourServicePhone],@"title":@"客服热线",@"image":@"personalServiceImage"}];
}

+ (NSArray *)colorArray
{
    return @[
             [UIColor colorFromHexRGB:@"fdcf10"],
             [UIColor colorFromHexRGB:@"ff8562"],
             [UIColor colorFromHexRGB:@"9bcb63"],
             [UIColor colorFromHexRGB:@"fbd960"],
             [UIColor colorFromHexRGB:@"f3a53a"],
             [UIColor colorFromHexRGB:@"60c1dd"],
             [UIColor colorFromHexRGB:@"d7504a"]
             ];
}


@end
