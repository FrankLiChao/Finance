//
//  lhFirmOrderViewModel.m
//  SCFinance
//
//  Created by bosheng on 16/6/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhFirmOrderViewModel.h"
#import "lhFirmOrderTableViewCell.h"
#import "FrankAutoLayout.h"

@implementation lhFirmOrderViewModel

+ (void)getFaPiaoDataSuccess:(void (^)(id))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_findInvoice"];

    NSDictionary * parameters = @{@"userId":[lhUserModel shareUserModel].userId};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

+ (void)getCarIdDataSuccess:(void (^)(id))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_findMotorcade"];
    
    NSDictionary * parameters = @{@"userId":[lhUserModel shareUserModel].userId};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

+ (void)firmOrderArray:(NSArray *)buyArray invoiceData:(NSDictionary *)invoiceDic success:(void (^)(id))success
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"product_genDirectPurchase"];
    
    NSMutableString * ids = [NSMutableString stringWithFormat:@"%@",[[buyArray objectAtIndex:0] objectForKey:@"id"]];
    NSMutableString * nums = [NSMutableString stringWithFormat:@"%@",[[buyArray objectAtIndex:0] objectForKey:@"purchaseNumber"]];
    for (int i = 1; i < buyArray.count; i++) {
        [ids appendFormat:@",%@",[[buyArray objectAtIndex:i] objectForKey:@"id"]];
        [nums appendFormat:@",%@",[[buyArray objectAtIndex:i] objectForKey:@"purchaseNumber"]];
        
    }
    
    NSMutableDictionary * parameters = [@{
                        @"userId":[lhUserModel shareUserModel].userId,
                        @"productIds":ids,
                        @"purchaseNumbers":nums} mutableCopy];
//    if (carDic && carDic.count) {
//        [parameters setObject:[carDic objectForKey:@"id"] forKey:@"motorcadeId"];
//    }
    if (invoiceDic && invoiceDic.count) {
        [parameters setObject:[invoiceDic objectForKey:@"id"] forKey:@"invoiceId"];
    }
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:nil];
}

//更新table的高度
+ (void)updateTableSize:(UITableView *)tableView fArray:(NSArray *)fArray
{
    tableView.sd_layout.heightIs(fArray.count*75);
    
    [tableView.superview updateLayout];
    
}

//更新确认订单中cell中原价label位置及线的位置
+ (void)updateCell:(lhFirmOrderTableViewCell *)sCell
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

//总价label样式
+ (NSAttributedString *)setLabelStyle:(NSString *)text
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:text];
    [as addAttribute:NSForegroundColorAttributeName value:lhcontentTitleColorStr1 range:NSMakeRange(0, 3)];
    [as addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 3)];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(text.length-3, 2)];
    
    return as;
}

//设置每个油库合计金额label样式
//+ (NSAttributedString *)setEveryLabelStyle:(NSString *)text
//{
//    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:text];
//    NSRange range = [text rangeOfString:@"￥"];
//    
//    [as addAttribute:NSForegroundColorAttributeName value:lhcontentTitleColorStr range:NSMakeRange(0, range.location)];
//    [as addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, range.location+1)];
//    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(text.length-2, 2)];
    
//    return as;
//}

@end
