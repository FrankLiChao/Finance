//
//  lhMainViewModel.m
//  SCFinance
//
//  Created by bosheng on 16/5/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMainViewModel.h"
#import "LHJsonModel.h"
#import "lhLoginViewModel.h"
#import "lhGoodsTableViewCell.h"
#import "MyMD5.h"
#import "lhStartViewController.h"

static lhMainViewModel * shareViewModel;

@interface lhMainViewModel()<UIAlertViewDelegate>

@end

@implementation lhMainViewModel

+ (instancetype)shareMainViewModel
{
    if (shareViewModel) {
        return shareViewModel;
    }
    shareViewModel = [[lhMainViewModel alloc]init];
    
    return shareViewModel;
}

//获取主页数据
+ (void)getMainDataAreaId:(NSString *)areaId success:(void (^)(id response))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"product_index"];
    NSDictionary * parameters = @{@"areaId":areaId};
    
    if ([lhUtilObject shareUtil].isOnLine) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dic setObject:[lhUserModel shareUserModel].userId forKey:@"userId"];
        parameters = dic;
    }
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
    
}

//添加商品到购物车
+ (void)addProductToShopCar:(NSString *)productId numStr:(NSString *)numStr success:(void (^)(id))success
{
    if ([lhUtilObject loginIsOrNot]) {//已登录
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_addToCart"];
        NSDictionary * parameters = @{@"productId":productId,
                                      @"purchaseNumber":numStr,
                                      @"userId":[NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId]};
        
        [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
            if (success) {
                success(responseObject);
            }
        }fail:nil];
    }
    
}

//请求直购或团购数据
+ (void)requestData:(NSDictionary *)filterDict areaId:(NSString *)areaId type:(NSInteger)type pageSize:(NSInteger)pageSize pageNo:(NSInteger)pageNo success:(void (^)(id data))success fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,type==5?@"product_groupPurchaseList":@"product_directPurchaseList"];
    NSMutableDictionary * parameters =[
  @{@"pm.pageSize":[NSNumber numberWithInteger:pageSize],
    @"pm.pageNo":[NSNumber numberWithInteger:pageNo],
    @"areaId":areaId} mutableCopy];
    
    if (filterDict && filterDict.count) {
        for (int i = 0; i < [filterDict allKeys].count; i++) {
            NSString * keyStr = [[filterDict allKeys] objectAtIndex:i];
            NSMutableSet * set = [filterDict objectForKey:keyStr];
            NSArray * fArray = [set allObjects];
            NSMutableString * s = [NSMutableString stringWithFormat:@"%@",[[fArray objectAtIndex:0] objectForKey:@"id"]];
            for (int j=1; j < fArray.count; j++) {
                NSDictionary * d = [fArray objectAtIndex:j];
                [s appendFormat:@",%@",[d objectForKey:@"id"]];
            }
            [parameters setObject:s forKey:keyStr];
        }
    }
    
    if ([lhUtilObject shareUtil].isOnLine) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dic setObject:[lhUserModel shareUserModel].userId forKey:@"userId"];
        parameters = dic;
    }
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

//获取筛选条件
+ (void)requestFilterData:(NSDictionary *)areaDic type:(NSInteger)type success:(void (^)(id))success fail:(void (^)(id))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,type==5?@"product_findGroupChooseCondition":@"product_findChooseCondition"];
    NSDictionary * parameters = @{@"areaId":[areaDic objectForKey:@"id"]};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }fail:fail];
}

//直接购买
+ (void)rightNowBuy:(NSDictionary *)buyDic num:(NSString *)numStr success:(void (^)(id response))success
{
    if ([lhUtilObject loginIsOrNot]) {
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"product_directPurchase"];
        NSDictionary * parameters = @{
                        @"userId":[lhUserModel shareUserModel].userId,
                        @"productId":[buyDic objectForKey:@"id"],
                        @"purchaseNumber":numStr
                        };
        
        [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
            if (success) {
                success(responseObject);
            }
        }fail:nil];
    }
    
}

//获取本地轮播图片数据
+ (NSArray *)lunboImageArray
{
    NSMutableArray * lA = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:mainViewlunboPicFile]];
    if (lA && lA.count > 0) {
        return lA;
    }
    return @[imageWithName(@"lunboPic0.jpg")];
}

//获取启动数据
+ (void)requestStartDataSuccess:(void (^)())success
{
    //检查是否有已登录账户
    double tim = [[NSDate date]timeIntervalSince1970];
    double remTim = [[[NSUserDefaults standardUserDefaults]objectForKey:autoLoginTimeFile]doubleValue];
    NSDictionary * uDic = [[NSUserDefaults standardUserDefaults] objectForKey:saveLoginInfoFile];
    if (tim < remTim && uDic && uDic.count > 0) {//自动登录没过期，登陆
        
        [lhUtilObject shareUtil].isOnLine = YES;
        [LHJsonModel modelWithDict:uDic className:@"lhUserModel"];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_startApp"];
        NSMutableDictionary * parameters = [@{@"userId":[lhUserModel shareUserModel].userId,
                                      @"clientType":@"1"} mutableCopy];
        NSDictionary * cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:lastCityInfoFile];
        if (cityDic && cityDic.count) {
            [parameters setObject:[cityDic objectForKey:@"id"] forKey:@"areaId"];
        }

        [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:parameters method:@"POST" success:^(id responseObject) {
            
            //购物车数量设置
            NSString * cartSizeStr = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"user"] objectForKey:@"cartSize"]];
            [[lhTabBar shareTabBar]sizeToFitWithText:cartSizeStr];
            
            //咨询类目
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"category"] forKey:saveTitleInformationToFile];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //城市列表
            [lhUtilObject shareUtil].allCityArray = [responseObject objectForKey:@"areaList"];
            
            //版本信息
            [lhUtilObject shareUtil].versionDic = [responseObject objectForKey:@"versionInfo"];
            
            //余油信息
            [lhUtilObject shareUtil].remainOilArray = [responseObject objectForKey:@"remainOil"];
            
            //开场图片信息
            [lhUtilObject shareUtil].mainAdsDic = [responseObject objectForKey:@"loadingAd"];
            
//            [lhUtilObject shareUtil].userInfor = [responseObject objectForKey:@"user"];
            
            //登陆成功后延长自动登陆时间,30天
            double tim = (double)[[NSDate date]timeIntervalSince1970]+3600*24*30;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [LHJsonModel modelWithDict:[responseObject objectForKey:@"user"] className:@"lhUserModel"];
            
            if (success) {
                success();
            }
            
        } fail:^(id error) {
            
            if([@"-111" isEqualToString:error]){
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:[lhMainViewModel shareMainViewModel] cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:[lhMainViewModel shareMainViewModel] cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                [lhUtilObject shareUtil].isOnLine = NO;
                double tim = (double)[[NSDate date]timeIntervalSince1970];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        }];
        
    }
    else{
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_startApp"];
        NSMutableDictionary * parameters = [@{} mutableCopy];
        NSDictionary * cityDic = [[NSUserDefaults standardUserDefaults]objectForKey:lastCityInfoFile];
        if (cityDic && cityDic.count) {
            [parameters setObject:[cityDic objectForKey:@"id"] forKey:@"areaId"];
        }
        [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:parameters method:@"POST" success:^(id responseObject) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"category"] forKey:saveTitleInformationToFile];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //城市列表
            [lhUtilObject shareUtil].allCityArray = [responseObject objectForKey:@"areaList"];
            
            //版本信息
            [lhUtilObject shareUtil].versionDic = [responseObject objectForKey:@"versionInfo"];
            
            //余油信息
            [lhUtilObject shareUtil].remainOilArray = [responseObject objectForKey:@"remainOil"];
            
            //开场图片信息
            [lhUtilObject shareUtil].mainAdsDic = [responseObject objectForKey:@"loadingAd"];
            
            if (success) {
                success();
            }
            
        } fail:^(id error) {
            
            if([@"-111" isEqualToString:error]){
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:[lhMainViewModel shareMainViewModel] cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:[lhMainViewModel shareMainViewModel] cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }];
    }
}

//更新token
+ (void)updateToken
{
    NSDictionary * uDic = [[NSUserDefaults standardUserDefaults] objectForKey:saveLoginInfoFile];
    if (uDic && uDic.count > 0) {//本地有存储信息

        [lhUtilObject shareUtil].isOnLine = YES;
        [LHJsonModel modelWithDict:uDic className:@"lhUserModel"];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_login"];
        NSString * pwd = [lhUserModel shareUserModel].password;
        NSDictionary * parameters = @{@"phone":[lhUserModel shareUserModel].phone,
                                      @"password":pwd.length>25?pwd:[MyMD5 md5:pwd],
                                      @"token":[lhUtilObject shareUtil].realToken};
        
        [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:parameters method:@"POST" success:^(id responseObject) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[lhUtilObject shareUtil].realToken forKey:saveLocalTokenFile];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        } fail:^(id error) {
            
        }];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[lhStartViewController shareStartVC] startRequstData];
}

//更新团购和直购cell控件距离
+ (void)updateCell:(lhGoodsTableViewCell *)gCell section:(NSInteger)section withRate:(CGFloat)rate
{
    CGSize nameSize = [lhUtilObject sizeWithFontWhenIOS7:gCell.nameLabel.text font:gCell.nameLabel.font];
    
    CGRect nRect = gCell.nameLabel.frame;
    nRect.size.width = nameSize.width+10;
    gCell.nameLabel.frame = nRect;
    
    CGRect vRect = gCell.validateImgView.frame;
    vRect.origin.x = gCell.nameLabel.frame.origin.x+nameSize.width+10;
    gCell.validateImgView.frame = vRect;
    
    NSMutableAttributedString * as1 = [[NSMutableAttributedString alloc]initWithString:gCell.priceLabel.text];
    [as1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(0, gCell.priceLabel.text.length)];
    [as1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(gCell.priceLabel.text.length-3, 3)];
    gCell.priceLabel.attributedText = as1;
    
//    CGSize priceSize = [lhUtilObject sizeWithFontWhenIOS7:gCell.priceLabel.text font:gCell.priceLabel.font];

//    CGRect nowRect = gCell.todayPriceLabel.frame;
//    nowRect.size.width = (DeviceMaxWidth-priceSize.width+4)/2;
//    gCell.todayPriceLabel.frame = nowRect;
    
    CGSize oSize = [lhUtilObject sizeWithFontWhenIOS7:gCell.oldPriceLabel.text font:gCell.oldPriceLabel.font];
    
    CGRect oRect = gCell.oldPriceLabel.frame;
    oRect.origin.x = DeviceMaxWidth-80*widthRate-oSize.width;
    oRect.size.width = oSize.width;
    gCell.oldPriceLabel.frame = oRect;
    
    CGRect olRect = gCell.oldLineView.frame;
    olRect.size.width = oSize.width;
    gCell.oldLineView.frame = olRect;
    
    CGRect jRect = gCell.sPriceLabel.frame;
    jRect.origin.x = oRect.origin.x;
    gCell.sPriceLabel.frame = jRect;
    
    if (section == 0) {//团购调整进度条

        if (rate > 0) {
            gCell.progressForeView.hidden = NO;
            gCell.progressShowView.hidden = NO;
            
            CGRect pfRect = gCell.progressForeView.frame;
            CGSize sSize = [lhUtilObject sizeWithFontWhenIOS7:gCell.progressShowView.text font:gCell.progressShowView.font];
            CGFloat pfWidth = (CGRectGetWidth(gCell.progressBackView.frame)-4)*rate;//进度条长度
            if (pfWidth < sSize.width+10) {
                pfRect.size.width = sSize.width+10;
            }
            else{
                pfRect.size.width = pfWidth;
            }
            gCell.progressForeView.frame = pfRect;
            
            CGRect psRect = gCell.progressShowView.frame;
            psRect.origin.x = CGRectGetWidth(pfRect)-sSize.width-8;
            psRect.size.width = sSize.width+6;
            gCell.progressShowView.frame = psRect;
        }
        else{
            gCell.progressForeView.hidden = YES;
            gCell.progressShowView.hidden = YES;
        }
        
    }
}

//更新表格Frame
+ (void)updateTableFrame:(UITableView *)tempTableView oilArray:(NSArray *)oilArray scollView:(UIScrollView *)maxScrollView
{
    CGRect tableRect = tempTableView.frame;
    tableRect.size.height = 80;
    if (oilArray && oilArray.count) {
        NSArray * firstArray = [oilArray objectAtIndex:0];
        if (firstArray && firstArray.count) {
            tableRect.size.height += firstArray.count*225-10;
        }
        
        if (oilArray.count == 2) {
            NSArray * secondArray = [oilArray objectAtIndex:1];
            if (secondArray && secondArray.count) {
                tableRect.size.height += secondArray.count*190-10;
            }
        }
        
        if (tableRect.size.height < DeviceMaxHeight-210*widthRate-49) {
            tableRect.size.height = DeviceMaxHeight-210*widthRate-49;
        }
    }
    else{
        tableRect.size.height = DeviceMaxHeight-210*widthRate-49;
    }
    tempTableView.frame = tableRect;
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, CGRectGetHeight(tempTableView.frame)+tempTableView.frame.origin.y+0.5);
}

//倒计时处理及赋值
+ (void)dealSYWithLabel:(UILabel *)tpLabel
{
    long time = (long)tpLabel.tag;
    NSInteger day = time/(24*3600);//天
    NSInteger hour = (time%(24*3600))/3600;//时
    NSInteger minutes = (time%3600)/60;//分
    NSInteger seconds = time%60;//秒
    
    NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString * hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    if (hour < 10 && hour > 0) {
        hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    NSString * minutesStr = [NSString stringWithFormat:@"%ld",(long)minutes];
    if (minutes < 10 && minutes > 0) {
        minutesStr = [NSString stringWithFormat:@"0%@",minutesStr];
    }
    NSString * secondsStr = [NSString stringWithFormat:@"%ld",(long)seconds];
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%@",secondsStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(day <= 0){
            tpLabel.text = [NSString stringWithFormat:@"还剩 %@小时%@分%@秒",hourStr,minutesStr,secondsStr];
        }
        else{
            tpLabel.text = [NSString stringWithFormat:@"还剩%@天 %@:%@:%@",dayStr,hourStr,minutesStr,secondsStr];
        }
        
    });
}

@end
