//
//  lhShopCarViewModel.m
//  SCFinance
//
//  Created by bosheng on 16/5/31.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhShopCarViewModel.h"
#import "lhShopCarTableViewCell.h"

@implementation lhShopCarViewModel

//获取购物车数据
+ (void)getShopCarDataSuccess:(void (^)(id))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_cartIndex"];
//    if (![lhUtilObject shareUtil].userInfor) {
//        [lhUtilObject loginIsOrNot];
//    }
    NSDictionary * parameters = @{@"userId":[lhUserModel shareUserModel].userId};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

+ (void)settle:(NSArray *)buyArray success:(void (^)(id))success
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"product_confirm"];

    NSMutableString * ids = [NSMutableString stringWithFormat:@"%@",[[buyArray objectAtIndex:0] objectForKey:@"id"]];
    NSMutableString * nums = [NSMutableString stringWithFormat:@"%@",[[buyArray objectAtIndex:0] objectForKey:@"purchaseNumber"]];
    for (int i = 1; i < buyArray.count; i++) {
        [ids appendFormat:@",%@",[[buyArray objectAtIndex:i] objectForKey:@"id"]];
        [nums appendFormat:@",%@",[[buyArray objectAtIndex:i] objectForKey:@"purchaseNumber"]];
        
    }
    
    NSDictionary * parameters = @{
                        @"userId":[lhUserModel shareUserModel].userId,
                        @"productIds":ids,
                        @"purchaseNumbers":nums};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:nil];
}

//删除一条数据
+ (void)deleteOne:(NSDictionary *)oneDic success:(void (^)(id response))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_deleteFromCart"];
    NSDictionary * parameters = @{
                    @"userId":[lhUserModel shareUserModel].userId,
                    @"productId":[oneDic objectForKey:@"id"]};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

//总价label样式
+ (NSAttributedString *)setLabelStyle:(NSString *)text
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:text];
    [as addAttribute:NSForegroundColorAttributeName value:lhcontentTitleColorStr1 range:NSMakeRange(0, 3)];
    [as addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 3)];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(text.length-3, 2)];
    
    return as;
}

//更新购物车cell中原价label位置
+ (void)updateCell:(lhShopCarTableViewCell *)sCell
{
    CGSize pSize = [lhUtilObject sizeWithFontWhenIOS7:sCell.priceLabel.text font:sCell.priceLabel.font];
    
    CGRect oRect = sCell.oldPriceLabel.frame;
    oRect.origin.x = pSize.width+5+sCell.priceLabel.frame.origin.x;
    sCell.oldPriceLabel.frame = oRect;
    
    CGSize oSize = [lhUtilObject sizeWithFontWhenIOS7:sCell.oldPriceLabel.text font:sCell.oldPriceLabel.font];
    CGRect olRect = sCell.oldLineView.frame;
    olRect.size.width = oSize.width;
    sCell.oldLineView.frame = olRect;

}

@end
