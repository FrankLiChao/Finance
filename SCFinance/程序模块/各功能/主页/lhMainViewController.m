//
//  lhMainViewController.m
//  SCFinance
//
//  Created by bosheng on 16/5/16.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMainViewController.h"
#import "LHJsonModel.h"
#import "lhLoginViewModel.h"
#import "lhMainView.h"
#import "lhMainViewModel.h"
#import "lhTeamBuyViewController.h"
#import "lhGoodsTableViewCell.h"
#import "FrankChooseCityView.h"
#import "FrankTools.h"
#import "lhMainRequest.h"
#import "FrankTuanGouView.h"
#import "lhMainTeamBuyModel.h"
#import "lhMainBuyModel.h"
#import "lhFirmOrderViewController.h"
#import "lhShopCarView.h"
#import "UIScrollView+lhMineRefresh.h"

#import "lhAlertView.h"

@interface lhMainViewController ()
<UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate>
{
    lhMainView * mView;
    lhNavigationBar * nBar;
    UIImageView * locationImgView;
    UIButton * locationButton;
    
    NSDictionary * allDic;//所有数据
    NSArray * lunBoArray;
    NSArray * oilArray;//主页团购和直购数据
    
//    NSDictionary * oilDict;//以字典存团购和直购数据
    NSTimer * moveTimer;//轮播自动跳转计时器
    NSTimer * mainTeamBuyTimer;//主页团购倒计时
    NSTimeInterval systemTime;//系统时间
    NSMutableSet * cellSet;//存储倒计时cell
    
    NSArray * areaArray;//地区列表
    UITextField * inputField;//直接购买输入数量
    
    UIControl * maxControl;//收起键盘事件
//    NSString * buyNumStr;//直购立即购买数量
    
    NSInteger forceUpdate;
}

@end

@implementation lhMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    cellSet = [NSMutableSet set];
    
    mView = [[lhMainView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight) imgageArray:[lhMainViewModel lunboImageArray] controller:self];
    mView.backgroundColor = [UIColor clearColor];
    mView.maxScrollView.delegate = self;
    mView.shopTableView.delegate = self;
    mView.shopTableView.dataSource = self;
    [self.view addSubview:mView];
    
    mView.maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth, CGRectGetHeight(mView.maxScrollView.frame)+0.5);
    
    [mView.maxScrollView addHeaderWithTarget1:self action:@selector(headerRefreshEvent)];
    
    nBar = [[lhNavigationBar alloc]initWithVC:self title:@"首页" isBackBtn:NO rightBtn:nil];
    nBar.alpha = 0;
    [self.view addSubview:nBar];
    
    locationImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-62, 36.5, 15, 15)];
    locationImgView.image = imageWithName(@"locationImage");
    [self.view addSubview:locationImgView];
    
    NSString * cityStr = [[lhUtilObject shareUtil].nowCityDic objectForKey:@"name"];
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setTitle:cityStr forState:UIControlStateNormal];
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationButton.titleLabel.font = [UIFont systemFontOfSize:15];
    locationButton.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
    [locationButton addTarget:self action:@selector(locationButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    [lhMainViewModel updateTableFrame:mView.shopTableView oilArray:oilArray scollView:mView.maxScrollView];
    
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [self checkVersionData];
    
    
//    NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:changeTestAndProFile]];
//    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveButton.backgroundColor = [UIColor whiteColor];
//    [saveButton setTitle:@"测试" forState:UIControlStateNormal];
//    [saveButton setTitle:@"正式" forState:UIControlStateSelected];
//    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    saveButton.frame = CGRectMake(10, 22, 60, 44);
//    [saveButton addTarget:self action:@selector(saveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:saveButton];
//    
//    saveButton.selected = [str integerValue];

//    NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:changeTestAndProFile]];
//    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveButton.backgroundColor = [UIColor clearColor];
//    [saveButton setTitle:@"测试" forState:UIControlStateNormal];
//    [saveButton setTitle:@"正式" forState:UIControlStateSelected];
//    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    saveButton.frame = CGRectMake(10, 22, 60, 44);
//    [saveButton addTarget:self action:@selector(saveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:saveButton];
    
}

- (void)saveButtonEvent:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:changeTestAndProFile];
    }
    else{
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:changeTestAndProFile];
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 下拉刷新
- (void)headerRefreshEvent
{
    [self requestMainData];
}

#pragma mark - 请求主页数据
- (void)requestMainData
{
    
    [lhMainViewModel getMainDataAreaId:[[lhUtilObject shareUtil].nowCityDic objectForKey:@"id"] success:^(id response) {
        
        allDic = response;
        systemTime = [[allDic objectForKey:@"systemTime"]doubleValue]/1000;
        
        lunBoArray = [allDic objectForKey:@"slideList"];
        [mView.topScrollView setImageArray:lunBoArray];
        mView.topScrollView.lunboPC.currentPage = 0;
        
        NSMutableArray * arr = [NSMutableArray array];
        if ([[allDic allKeys]containsObject:@"groupPurchase"]) {
            NSArray * tArray = [allDic objectForKey:@"groupPurchase"];
            if (tArray && tArray.count) {
                [arr addObject:[allDic objectForKey:@"groupPurchase"]];
            }
            else{
               [arr addObject:[NSArray array]];
            }
        }
        else{
            [arr addObject:[NSArray array]];
        }
        if ([[allDic allKeys]containsObject:@"directPurchase"]) {
            NSArray * tArray = [allDic objectForKey:@"directPurchase"];
            if (tArray && tArray.count) {
                [arr addObject:[allDic objectForKey:@"directPurchase"]];
            }
            else{
                [arr addObject:[NSArray array]];
            }
        }
        else{
            [arr addObject:[NSArray array]];
        }
     
        oilArray = [NSArray arrayWithArray:arr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (oilArray && oilArray.count) {
                [lhUtilObject removeNullLabelWithSuperView:mView.shopTableView];
            }
            else{
                [lhUtilObject addANullLabelWithSuperView:mView.shopTableView withText:@"暂时没有获取到购油信息"];
            }
            [cellSet removeAllObjects];
            
            [lhMainViewModel updateTableFrame:mView.shopTableView oilArray:oilArray scollView:mView.maxScrollView];
            
            [mView.shopTableView reloadData];
            [lhHubLoading disAppearActivitiView];
            
            [mView.maxScrollView headerEndRefreshing1];
            
        });
    }fail:^(id error) {
        
        [lhMainRequest checkRequestFail:error];
        
        [lhHubLoading disAppearActivitiView];
        
        [mView.maxScrollView headerEndRefreshing1];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击定位城市
- (void)locationButtonEvent
{
    
    FrankChooseCityView *cityView = [[FrankChooseCityView alloc] init];
    [[lhTabBar shareTabBar].navigationController pushViewController:cityView animated:YES];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([lhUtilObject loginIsOrNot]) {
        NSDictionary *dic = oilArray[0][indexPath.row];
        NSString *groupBuyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        FrankTuanGouView *tgView = [FrankTuanGouView new];
        tgView.groupBuyId = groupBuyId;
        [[lhTabBar shareTabBar].navigationController pushViewController:tgView animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (oilArray && oilArray.count) {
        NSArray * tempArray = [oilArray objectAtIndex:indexPath.section];
    
        if(indexPath.section == 0){
            if (indexPath.row == tempArray.count-1) {
                return 215;
            }
            return 225;
        }
        else{
            if (indexPath.row == tempArray.count-1) {
                return 180;
            }
            return 190;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (oilArray && oilArray.count) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (oilArray && oilArray.count) {
        
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
        UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
        [hView addGestureRecognizer:tapG];
        hView.tag = section;
        hView.backgroundColor = lhviewColor;
        
        UIImageView * hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 13.5, 13, 13)];
        hImgView.image = section==0?imageWithName(@"mainTeamBuySymbolImage"):imageWithName(@"mainBuySymbolImage");
        [hView addSubview:hImgView];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate+13, 0, DeviceMaxWidth-100*widthRate, 40)];
        tLabel.font = [UIFont systemFontOfSize:15];
        tLabel.textColor = lhcontentTitleColorStr2;
        tLabel.text = section==0?@"团购：一起买，更优惠！":@"直购：供应商直销！";
        [hView addSubview:tLabel];
        
        UIImageView * yjtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-15*widthRate-8, 16, 8, 8)];
        yjtImgView.image = imageWithName(@"youjiantouImage");
        [hView addSubview:yjtImgView];
        
        NSString * numStr = [NSString stringWithFormat:@"%@",section==0?[allDic objectForKey:@"groupMore"]:[allDic objectForKey:@"directMore"]];
        
        NSString * moreStr = @"更多";
        if ([numStr integerValue] > 0) {
            moreStr = nil;
            moreStr = [NSString stringWithFormat:@"更多(%@)",section==0?[allDic objectForKey:@"groupMore"]:[allDic objectForKey:@"directMore"]];
        }
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:moreStr];
        
        if ([numStr integerValue] > 0) {
            [as addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(3, moreStr.length-4)];
        }
        
        UILabel * mLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceMaxWidth-75*widthRate-8, 0, 60*widthRate, 40)];
        mLabel.textAlignment = NSTextAlignmentRight;
        mLabel.font = [UIFont systemFontOfSize:12];
        mLabel.textColor = lhcontentTitleColorStr2;
        mLabel.attributedText = as;
        [hView addSubview:mLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [hView addSubview:lineView];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, DeviceMaxWidth, 0.5)];
        lineView1.backgroundColor = tableDefSepLineColor;
        [hView addSubview:lineView1];
        
        return hView;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (oilArray && oilArray.count) {
        return oilArray.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (oilArray && oilArray.count) {
        NSArray * tempArray = [oilArray objectAtIndex:section];
        
        return tempArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (oilArray && oilArray.count) {
        NSArray * tempArray = [oilArray objectAtIndex:indexPath.section];
        
        if (tempArray.count == 0) {
            return [UITableViewCell new];
        }
    }
    
    if(indexPath.section == 0){
        static NSString * tifier = @"teamBuyCell";
        lhGoodsTableViewCell * gtCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (gtCell == nil) {
            gtCell = [[lhGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier withSection:indexPath.section];
        }
        
        NSDictionary * dic = [[oilArray objectAtIndex:0] objectAtIndex:indexPath.row];
        
        lhMainTeamBuyModel * tbModel = [LHJsonModel modelWithDict:dic className:@"lhMainTeamBuyModel"];
        
        NSString * str = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,tbModel.companyLogo];
        [lhUtilObject checkImageWithImageView:gtCell.hImgView withImage:tbModel.companyLogo withImageUrl:str withPlaceHolderImage:imageWithName(placeHolderImg)];
        gtCell.nameLabel.text = tbModel.companyName;
        gtCell.oilLabel.text = [NSString stringWithFormat:@"%@ %@",tbModel.name,tbModel.oilName];
        gtCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",tbModel.currentPromotion];
        gtCell.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",tbModel.price];
        gtCell.sPriceLabel.text = [NSString stringWithFormat:@"最低省%ld元/吨",(long)[tbModel.price integerValue] - [tbModel.currentPromotion integerValue]];
        gtCell.progressShowView.text = [NSString stringWithFormat:@"%@t",tbModel.currentPurchase];
        gtCell.moreLabel.text = [NSString stringWithFormat:@"%@t",tbModel.nextMax];
        
        gtCell.alreadyLabel.text = [NSString stringWithFormat:@"已有%ld人报名",(long)[tbModel.signNumber integerValue]];
        
        if((NSInteger)([tbModel.deadline longLongValue]/1000 - systemTime) > 0){
            gtCell.timeLabel.tag = (NSInteger)([tbModel.deadline longLongValue]/1000 - systemTime);
            
            [lhMainViewModel dealSYWithLabel:gtCell.timeLabel];
            [cellSet addObject:gtCell.timeLabel];
            
            if (!mainTeamBuyTimer) {
                mainTeamBuyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:mainTeamBuyTimer forMode:NSRunLoopCommonModes];
            }
            gtCell.finishImage.hidden = YES;
            gtCell.detailBtn.hidden = NO;
            [gtCell.detailBtn setTitle:@"立即参团" forState:UIControlStateNormal];
        }
        else{
            gtCell.timeLabel.text = @"已截止";
            gtCell.finishImage.hidden = NO;
//            [gtCell.detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            gtCell.detailBtn.hidden = YES;
        }

        CGFloat rate = 1;
        if ([tbModel.nextMax doubleValue] > 0) {
            rate = [tbModel.currentPurchase doubleValue]/[tbModel.nextMax doubleValue];
            if (rate > 1) {
                rate = 1;
            }
        }
        [lhMainViewModel updateCell:gtCell section:indexPath.section withRate:rate];
        
        gtCell.detailBtn.tag = indexPath.row;
        [gtCell.detailBtn addTarget:self action:@selector(clickBuyTeamEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        return gtCell;
    }
    else if(indexPath.section == 1){
        
        static NSString * tifier = @"buyCell";
        lhGoodsTableViewCell * gtCell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (gtCell == nil) {
            gtCell = [[lhGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier withSection:indexPath.section];
        }
        
        NSDictionary * dic = [[oilArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        lhMainBuyModel * bModel = [LHJsonModel modelWithDict:dic className:@"lhMainBuyModel"];
        
        NSString * str = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,bModel.depotLogo];
        [lhUtilObject checkImageWithImageView:gtCell.hImgView withImage:bModel.depotLogo withImageUrl:str withPlaceHolderImage:imageWithName(placeHolderImg)];
        gtCell.nameLabel.text = bModel.depotName;
        gtCell.oilLabel.text = [NSString stringWithFormat:@"%@ %@",bModel.name,bModel.oilName];
        gtCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",bModel.exclusivePrice];
        gtCell.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",bModel.price];
        gtCell.sPriceLabel.text = [NSString stringWithFormat:@"最低省%ld元/吨",(long)[bModel.price integerValue] - [bModel.exclusivePrice integerValue]];
        
        gtCell.tellBtn.tag = indexPath.row;
        [gtCell.tellBtn addTarget:self action:@selector(tellBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        gtCell.shopCarBtn.tag = indexPath.row;
        [gtCell.shopCarBtn addTarget:self action:@selector(shopCarBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        gtCell.buyBtn.tag = indexPath.row;
        [gtCell.buyBtn addTarget:self action:@selector(buyBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [lhMainViewModel updateCell:gtCell section:indexPath.section withRate:0];
        [gtCell.shopCarBtn addTarget:self action:@selector(shopCarBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
        return gtCell;
    }
    
    return nil;
}

#pragma mark - 团购详情
-(void)clickBuyTeamEvent:(UIButton *)button_
{
//    FLLog(@"%ld",button_.tag);
    if ([lhUtilObject loginIsOrNot]) {
        NSDictionary *dic = oilArray[0][button_.tag];
        NSString *groupBuyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        FrankTuanGouView *tgView = [FrankTuanGouView new];
        tgView.groupBuyId = groupBuyId;
        [[lhTabBar shareTabBar].navigationController pushViewController:tgView animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSArray * tArray = [[[oilArray objectAtIndex:1] objectAtIndex:actionSheet.tag] objectForKey:@"managerList"];

    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",[[tArray objectAtIndex:buttonIndex-1] objectForKey:@"phone"]];
    
    if (![NSURL URLWithString:str]) {
        [lhUtilObject showAlertWithMessage:@"电话号码格式错误~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    NSString * idStr = [NSString stringWithFormat:@"%@",[[[oilArray objectAtIndex:1] objectAtIndex:actionSheet.tag] objectForKey:@"id"]];
    NSString *userId = [lhUserModel shareUserModel].userId;
    NSDictionary *dic = @{@"userId":userId,
                          @"productId":idStr};
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"clientInfo_addClientPhone") parameters:dic method:@"POST" success:^(id responseObject) {
        [lhHubLoading disAppearActivitiView];
        
        [lhUtilObject shareUtil].noShowKaiChang = YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } fail:nil];
    
}

#pragma mark - 打电话、立即购买
- (void)tellBtnEvent:(UIButton *)button_
{
    if([lhUtilObject loginIsOrNot]){
        
        NSArray * tArray = [[[oilArray objectAtIndex:1] objectAtIndex:button_.tag] objectForKey:@"managerList"];
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [tArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * btnStr =[NSString stringWithFormat:@"%@:%@",[obj objectForKey:@"name"],[obj objectForKey:@"phone"]];
            [actionSheet addButtonWithTitle:btnStr];
        }];
        
        actionSheet.tag = button_.tag;
        [actionSheet showInView:self.view];
        
//        for (int i = 0; i < tArray.count; i++) {
//            NSDictionary * dic = [tArray objectAtIndex:i];
//            NSString * btnStr =[NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"name"],[dic objectForKey:@"phone"]];
//            [actionSheet addButtonWithTitle:btnStr];
//        }

    }
    
}

- (void)buyBtnEvent:(UIButton *)button_
{
    NSLog(@"立即购买");
    
    if (![lhUtilObject loginIsOrNot]) {
        return;
    }
    
//    if ([[lhUserModel shareUserModel].certificationStatus integerValue] == 0) {
//        [lhUtilObject showAlertWithMessage:@"您还未认证，请先认证~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
//        
//        return;
//    }
    
    if (inputField) {
        [inputField removeFromSuperview];
        inputField = nil;
    }
    if (maxControl) {
        [maxControl removeFromSuperview];
        maxControl = nil;
    }
    
    maxControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    maxControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [maxControl addTarget:self action:@selector(cancelInputEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maxControl];
    
    inputField = [UITextField new];
    inputField.tag = button_.tag;
    inputField.text = @"30";
    inputField.delegate = self;
    inputField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:inputField];
    inputField.inputAccessoryView = [[lhShopCarView shareShopCarView] anInputAccessoryView];
//    [lhShopCarView shareShopCarView].showLabel.cursor.hidden = NO;
    [lhShopCarView shareShopCarView].cancelBtn.hidden = NO;
    [[lhShopCarView shareShopCarView].cancelBtn addTarget:self action:@selector(cancelInputEvent) forControlEvents:UIControlEventTouchUpInside];
    [[lhShopCarView shareShopCarView].finishBtn addTarget:self action:@selector(maxControlEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [inputField becomeFirstResponder];
}

- (void)maxControlEvent
{
    NSDictionary * dic = [[oilArray objectAtIndex:1] objectAtIndex:inputField.tag];
//    NSLog(@"吨数 %@",inputField.text);
    if ([inputField.text integerValue] <= 0) {
        [lhUtilObject showAlertWithMessage:@"请输入您要购买的吨数" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhMainViewModel rightNowBuy:dic num:inputField.text success:^(id response) {
        
        [lhHubLoading disAppearActivitiView];
        
        lhFirmOrderViewController * foVC = [[lhFirmOrderViewController alloc]init];
        foVC.firmDic = response;
        foVC.type = 5;
        [[lhTabBar shareTabBar].navigationController pushViewController:foVC animated:YES];
        
    }];
    
//    [self cancelInputEvent];
}

- (void)cancelInputEvent
{
    [inputField resignFirstResponder];
}

- (void)removeView
{
    [lhShopCarView shareShopCarView].showLabel.cursor.hidden = YES;
    
    [inputField removeFromSuperview];
    inputField = nil;
    
    [maxControl removeFromSuperview];
    maxControl = nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(textFieldChanged) withObject:nil afterDelay:0.05];
    
    return YES;
}

- (void)textFieldChanged
{
    if ([@"" isEqualToString:inputField.text] || [inputField.text integerValue] < 1) {
        inputField.text = @"";
        [lhShopCarView shareShopCarView].showLabel.text = @"";
    }
    else{
        [lhShopCarView shareShopCarView].showLabel.text = [@"数量：" stringByAppendingString:inputField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    inputField = textField;
    
    [lhShopCarView shareShopCarView].showLabel.text = [@"数量：" stringByAppendingString:inputField.text];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([@"" isEqualToString:inputField.text] || [inputField.text integerValue] < 1) {
        inputField.text = @"1";
        [lhShopCarView shareShopCarView].showLabel.text = [@"数量：" stringByAppendingString:inputField.text];
    }

    [self performSelector:@selector(removeView) withObject:nil afterDelay:0.5];
}

#pragma mark - 加入购物车
- (void)shopCarBtnEvent:(UIButton *)button_
{
    NSDictionary * dic = [[oilArray objectAtIndex:1] objectAtIndex:button_.tag];
    [self addCartEvent:dic];
}

-(void)addCartEvent:(NSDictionary *)dic
{
    lhMainBuyModel * bModel = [LHJsonModel modelWithDict:dic className:@"lhMainBuyModel"];

    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhMainViewModel addProductToShopCar:bModel.id numStr:@"1" success:^(id response) {
        [lhUtilObject shareUtil].isRefreshShopCar = YES;
        [lhHubLoading disAppearActivitiView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                [lhTabBar shareTabBar].shopCarBadge.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    [lhTabBar shareTabBar].shopCarBadge.transform = CGAffineTransformMakeScale(1, 1);
                    NSString * cartSizeStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"cartSize"]];
                    [[lhTabBar shareTabBar]sizeToFitWithText:cartSizeStr];
                }];
            }];
        });
    }];
}

#pragma mark - 查看更多
- (void)tapEvent:(UITapGestureRecognizer *)tapG_
{
    lhTeamBuyViewController * tbVC = [[lhTeamBuyViewController alloc]init];
    tbVC.filterCityDic = [lhUtilObject shareUtil].nowCityDic;
    tbVC.type = tapG_.view.tag+5;
    [[lhTabBar shareTabBar].navigationController pushViewController:tbVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        locationButton.hidden = YES;
        locationImgView.hidden = YES;
    }
    else{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        locationButton.hidden = NO;
        locationImgView.hidden = NO;
    }
    
    nBar.alpha = scrollView.contentOffset.y/(200*widthRate-64);
    
}

#pragma mark - 计时器
- (void)timeCount
{
    systemTime += 1.0;

    UILabel * deleteLabel = nil;
    if (cellSet && cellSet.count) {
        for (UILabel * djsLabel in [cellSet allObjects]) {
            if (djsLabel.tag >= 1) {
                djsLabel.tag -= 1;
                
                [lhMainViewModel dealSYWithLabel:djsLabel];
            }
            else{
                djsLabel.text = @"已截止";
                
                deleteLabel = djsLabel;
                
                lhGoodsTableViewCell * gtCell = (lhGoodsTableViewCell *)djsLabel.superview;
                gtCell.finishImage.hidden = NO;
//                [gtCell.detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
                gtCell.detailBtn.hidden = YES;
            }
        }
    }
    else{
        if (mainTeamBuyTimer) {
            [mainTeamBuyTimer invalidate];
            mainTeamBuyTimer = nil;
        }
    }
    
    if (deleteLabel) {
        [cellSet removeObject:deleteLabel];
    }
}

#pragma mark - 进入页面数据判断
- (void)checkVersionData
{
    NSDictionary * infoDict = [[NSBundle mainBundle]infoDictionary];
    NSMutableString * nowVersion = [NSMutableString stringWithFormat:@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
    NSString * nowVersionS = [nowVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSMutableString * foStr = [NSMutableString stringWithFormat:@"%@",[[lhUtilObject shareUtil].versionDic objectForKey:@"iosVersion"]];
    NSString * foreVersion = [foStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([nowVersionS integerValue] < [foreVersion integerValue]) {
        
        forceUpdate = [[NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].versionDic objectForKey:@"iosForcedUpdate"]] integerValue];
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"新版本 %@",foStr] message:[NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].versionDic objectForKey:@"content"]] delegate:self cancelButtonTitle:forceUpdate==0?@"稍后再说":@"立即更新" otherButtonTitles:forceUpdate==0?@"立即更新":nil, nil];
        alertView.tag = 3;
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3) {
        if (forceUpdate == 0) {
            if (buttonIndex == 1) {
                NSString * urlStr = @"https://itunes.apple.com/us/app/you-pin-gou-you-bao-tuan-hao/id1128290296?l=zh&ls=1&mt=8";
                [lhUtilObject shareUtil].noShowKaiChang = YES;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            }
        }
        else{
            NSString * urlStr = @"https://itunes.apple.com/us/app/you-pin-gou-you-bao-tuan-hao/id1128290296?l=zh&ls=1&mt=8";
            [lhUtilObject shareUtil].noShowKaiChang = YES;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        }

    }
}

#pragma mark - 设置城市
- (void)updateCityButton
{
    NSString * cicyStr = [[lhUtilObject shareUtil].nowCityDic objectForKey:@"name"];
    [locationButton setTitle:cicyStr forState:UIControlStateNormal];
    
    CGRect rect = locationButton.frame;
    rect.size.width = [FrankTools sizeForString:cicyStr withSizeOfFont:[UIFont systemFontOfSize:15]];
    rect.origin.x = DeviceMaxWidth-rect.size.width-20;
    locationButton.frame = rect;
    
    CGRect rect1 = locationImgView.frame;
    rect1.origin.x = rect.origin.x-15;
    
    locationImgView.frame = rect1;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCityButton];
    
    if (moveTimer) {
        [moveTimer invalidate];
    }
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:mView selector:@selector(moveCount) userInfo:nil repeats:YES];
    
    if ([lhUtilObject shareUtil].teamBuyTimer) {
        [[lhUtilObject shareUtil].teamBuyTimer invalidate];
        [lhUtilObject shareUtil].teamBuyTimer = nil;
    }
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [self requestMainData];
    
    if (!mainTeamBuyTimer) {
        mainTeamBuyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:mainTeamBuyTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (moveTimer) {
        [moveTimer invalidate];
        moveTimer = nil;
    }
    
    if (mainTeamBuyTimer) {
        [mainTeamBuyTimer invalidate];
        mainTeamBuyTimer = nil;
    }
}

@end
