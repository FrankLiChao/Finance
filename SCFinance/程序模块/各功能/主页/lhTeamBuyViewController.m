//
//  lhTeamBuyViewController.m
//  SCFinance
//
//  Created by bosheng on 16/5/31.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhTeamBuyViewController.h"
#import "lhGoodsTableViewCell.h"
#import "lhMainViewModel.h"
#import "lhFilterView.h"
#import "MJRefresh.h"
#import "lhMainTeamBuyModel.h"
#import "lhMainBuyModel.h"
#import "LHJsonModel.h"
#import "FrankChooseCityView.h"
#import "lhFirmOrderViewController.h"
#import "FrankTuanGouView.h"
#import "lhShopCarView.h"

@interface lhTeamBuyViewController ()<UITableViewDelegate,UITableViewDataSource,filterStrDictDelegate,UITextFieldDelegate,rightBtnDelegate,UIActionSheetDelegate>
{
    UITableView * tbTableView;//团购列表

    NSArray * oilArray;
    
    NSInteger pNo;//当前页数
    NSInteger totalPno;//总页数
    
    NSTimeInterval systemTime;//系统时间
    NSMutableSet * cellSet;//存储倒计时cell
    
    lhFilterView * filterView;//筛选控件
    NSDictionary * filterDict;//筛选条件
    
    UITextField * inputField;//直接购买输入数量
    
    BOOL isFirst;
    UIControl * maxControl;
}

@end

@implementation lhTeamBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pNo = 1;
    totalPno = 1;
    isFirst = YES;
    cellSet = [NSMutableSet set];
    
    lhNavigationBar * nBar = [[lhNavigationBar alloc]initWithVC:self title:self.type==5?@"团购":@"直购" isBackBtn:YES rightBtn:@"筛选"];
    nBar.delegate = self;
    [self.view addSubview:nBar];
    
    tbTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    tbTableView.showsVerticalScrollIndicator = NO;
    tbTableView.delegate = self;
    tbTableView.dataSource = self;
    tbTableView.separatorColor = [UIColor clearColor];
    tbTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tbTableView];
    
    [tbTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tbTableView addFooterWithTarget:self action:@selector(footerRefresh)];

    filterView = [[lhFilterView alloc]initWithFrame:self.view.bounds];
    filterView.delegate = self;
    [filterView.cityButton addTarget:self action:@selector(cityButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterView];
    filterView.hidden = YES;
    
    [lhHubLoading addActivityView:self.view];
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击城市
- (void)cityButtonEvent
{
    NSLog(@"选择城市");
    
    FrankChooseCityView * fccVC = [[FrankChooseCityView alloc]init];
    fccVC.type = 5;
    fccVC.delegate = self;
    [self.navigationController pushViewController:fccVC animated:YES];
    
}

#pragma mark - 获取筛选条件
- (void)requestFilterData:(NSDictionary *)cityDic
{
    
    [lhMainViewModel requestFilterData:cityDic type:self.type success:^(id data) {
        
        NSArray * filterArray = data;
        
        if (filterArray && filterArray.count) {
            [lhUtilObject removeNullLabelWithSuperView:filterView];
            
            [filterView setFilterArray:filterArray];
        }
        else{
            [lhUtilObject addANullLabelWithSuperView:filterView withText:@"暂无筛选条件信息"];
        }
        if(!isFirst){
            [lhHubLoading disAppearActivitiView];
        }
        isFirst = NO;
    } fail:isFirst?nil:^(id error) {
        if (!isFirst) {
            [lhHubLoading disAppearActivitiView];
        }
        isFirst = NO;
    }];
    
}

#pragma mark - 点击筛选
- (void)rightBtnEvent
{
    [filterView appear];
    
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [self requestFilterData:self.filterCityDic];
}

- (void)setFilterStrDict:(NSDictionary *)dict
{
    filterDict = dict;
    
//    NSArray * tArr = [filterDict allKeys];
//    for (int i = 0; i < tArr.count; i++) {
//        NSLog(@"%@==%@",[tArr objectAtIndex:i],[filterDict objectForKey:[tArr objectAtIndex:i]]);
//    }
    
    //刷新控件
    [tbTableView headerBeginRefreshing];
    
}

#pragma mark - 下拉刷新、上拉加载
- (void)headerRefresh
{
    pNo = 1;
    [self requestData];
}

- (void)footerRefresh
{
    if(pNo >= totalPno){
        [lhUtilObject showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [tbTableView footerEndRefreshing];
        
        return;
    }
    
    pNo++;
    [self requestData];
}

- (void)requestData
{
    [lhMainViewModel requestData:filterDict areaId:[self.filterCityDic objectForKey:@"id"] type:self.type pageSize:12 pageNo:pNo success:^(id data) {
        totalPno = [[data objectForKey:@"totalPage"] integerValue];
        systemTime = [[data objectForKey:@"systemTime"]doubleValue]/1000;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(pNo != 1){
                NSMutableArray * tempA = [NSMutableArray arrayWithArray:oilArray];
                [tempA addObjectsFromArray:[data objectForKey:@"data"]];
                oilArray = tempA;
            }
            else{
                oilArray = [data objectForKey:@"data"];
            }
            
            if(oilArray && oilArray.count){
                [lhUtilObject removeNullLabelWithSuperView:tbTableView];
            }
            else{
                [lhUtilObject addANullLabelWithSuperView:tbTableView withText:self.type==5?@"无符合条件的团购信息":@"无符合条件的直购信息"];
            }
            
            [cellSet removeAllObjects];
            [tbTableView reloadData];
            
            if(pNo == 1){
                [tbTableView headerEndRefreshing];
            }
            else{
                [tbTableView footerEndRefreshing];
            }
            
            [lhHubLoading disAppearActivitiView];
        });
        
    }fail:^(id error){
        [lhMainRequest checkRequestFail:error];
        
        if(pNo == 1){
            [tbTableView headerEndRefreshing];
        }
        else{
            [tbTableView footerEndRefreshing];
        }
        
        [lhHubLoading disAppearActivitiView];
    }];
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([lhUtilObject loginIsOrNot]) {
        NSDictionary *dic = oilArray[indexPath.row];
        NSString *groupBuyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        FrankTuanGouView *tgView = [FrankTuanGouView new];
        tgView.groupBuyId = groupBuyId;
        [[lhTabBar shareTabBar].navigationController pushViewController:tgView animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.type == 5){
        if (indexPath.row == oilArray.count-1) {
            return 215;
        }
        return 225;
    }
    else{
        if (indexPath.row == oilArray.count-1) {
            return 180;
        }
        return 190;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return oilArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"goodsCell";
    lhGoodsTableViewCell * gCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (gCell == nil) {
        gCell = [[lhGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier withSection:self.type==5?0:1];
    }
    
    if(self.type != 5){//直购
        lhMainBuyModel * buyModel = [LHJsonModel modelWithDict:[oilArray objectAtIndex:indexPath.row] className:@"lhMainBuyModel"];
        
        NSString * str = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,buyModel.depotLogo];
        [lhUtilObject checkImageWithImageView:gCell.hImgView withImage:buyModel.depotLogo withImageUrl:str withPlaceHolderImage:imageWithName(placeHolderImg)];
        
        gCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",buyModel.exclusivePrice];
        
        gCell.tellBtn.tag = indexPath.row;
        [gCell.tellBtn addTarget:self action:@selector(tellBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        gCell.nameLabel.text = buyModel.depotName;
        gCell.oilLabel.text = [NSString stringWithFormat:@"%@ %@",buyModel.name,buyModel.oilName];
        
        NSInteger sPrice = 0.0;//节省
        if([buyModel.exclusivePrice integerValue] > 0){
            gCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",buyModel.exclusivePrice];
            sPrice = [buyModel.price integerValue]-[buyModel.exclusivePrice integerValue];
        }
        else{
            gCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",buyModel.price];
        }
        
        gCell.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",buyModel.price];
        
        gCell.sPriceLabel.text = [NSString stringWithFormat:@"最低省%ld元",(long)sPrice];
        
        gCell.shopCarBtn.tag = indexPath.row;
        [gCell.shopCarBtn addTarget:self action:@selector(shopCarBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        gCell.buyBtn.tag = indexPath.row;
        [gCell.buyBtn addTarget:self action:@selector(buyBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [lhMainViewModel updateCell:gCell section:self.type==5?0:1 withRate:0];
    }
    else{
        lhMainTeamBuyModel * tbModel = [LHJsonModel modelWithDict:[oilArray objectAtIndex:indexPath.row] className:@"lhMainTeamBuyModel"];
        
        NSString * str = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,tbModel.companyLogo];
        [lhUtilObject checkImageWithImageView:gCell.hImgView withImage:tbModel.companyLogo withImageUrl:str withPlaceHolderImage:imageWithName(placeHolderImg)];
        
        gCell.nameLabel.text = tbModel.companyName;
        gCell.oilLabel.text = [NSString stringWithFormat:@"%@ %@",tbModel.name,tbModel.oilName];
        gCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",tbModel.currentPromotion];
        gCell.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",tbModel.price];
        gCell.sPriceLabel.text = [NSString stringWithFormat:@"最低省%ld元/吨",(long)[tbModel.price integerValue] - [tbModel.currentPromotion integerValue]];
        gCell.progressShowView.text = [NSString stringWithFormat:@"%@t",tbModel.currentPurchase];
        gCell.moreLabel.text = [NSString stringWithFormat:@"%@t",tbModel.nextMax];
//        if ([tbModel.nextDiff integerValue] > 0) {
//            gCell.distanceNextLabel.text = [NSString stringWithFormat:@"还差%ld吨降至￥%ld/吨",(long)[tbModel.nextDiff integerValue],(long)[tbModel.nextPromotion integerValue]];
//        }
//        else{
//            gCell.distanceNextLabel.text = @"当前已达到最大优惠";
//        }
        gCell.alreadyLabel.text = [NSString stringWithFormat:@"已有%ld人报名",(long)[tbModel.signNumber integerValue]];
        
        if((NSInteger)([tbModel.deadline longLongValue]/1000 - systemTime) > 0){
            gCell.timeLabel.tag = (NSInteger)([tbModel.deadline longLongValue]/1000 - systemTime);
            
            [lhMainViewModel dealSYWithLabel:gCell.timeLabel];
            [cellSet addObject:gCell.timeLabel];
            
            if (![lhUtilObject shareUtil].teamBuyTimer) {
                [lhUtilObject shareUtil].teamBuyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(temBuyTimerEvent) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:[lhUtilObject shareUtil].teamBuyTimer forMode:NSRunLoopCommonModes];
            }
            gCell.finishImage.hidden = YES;
            gCell.detailBtn.hidden = NO;
            [gCell.detailBtn setTitle:@"立即参团" forState:UIControlStateNormal];
        }
        else{
            gCell.timeLabel.text = @"已截止";
            gCell.finishImage.hidden = NO;
//            [gCell.detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            gCell.detailBtn.hidden = YES;
        }
        
        gCell.detailBtn.tag = indexPath.row;
        [gCell.detailBtn addTarget:self action:@selector(detailBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat rate = 1;
        if ([tbModel.nextMax doubleValue] > 0) {
            rate = [tbModel.currentPurchase doubleValue]/[tbModel.nextMax doubleValue];
            if (rate > 1) {
                rate = 1;
            }
        }
        [lhMainViewModel updateCell:gCell section:self.type==5?0:1 withRate:rate];
    }
    
    
    
    return gCell;
}

#pragma mark - 计时器
- (void)temBuyTimerEvent
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
        if ([lhUtilObject shareUtil].teamBuyTimer) {
            [[lhUtilObject shareUtil].teamBuyTimer invalidate];
            [lhUtilObject shareUtil].teamBuyTimer = nil;
        }
    }
    
    if (deleteLabel) {
        [cellSet removeObject:deleteLabel];
    }
}

#pragma mark - 团购事件
- (void)detailBtnEvent:(UIButton *)button_
{
    NSLog(@"团购详情");
    if ([lhUtilObject loginIsOrNot]) {
        NSDictionary *dic = oilArray[button_.tag];
        NSString *groupBuyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        FrankTuanGouView *tgView = [FrankTuanGouView new];
        tgView.groupBuyId = groupBuyId;
        [[lhTabBar shareTabBar].navigationController pushViewController:tgView animated:YES];
    }
}

#pragma mark - 加入购物车和直购事件
//添加到购物车
- (void)shopCarBtnEvent:(UIButton *)button_
{
    
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    lhMainBuyModel * buyModel = [LHJsonModel modelWithDict:[oilArray objectAtIndex:button_.tag] className:@"lhMainBuyModel"];
    [lhMainViewModel addProductToShopCar:buyModel.id numStr:@"1" success:^(id response) {
        [lhUtilObject shareUtil].isRefreshShopCar = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [lhUtilObject showAlertWithMessage:@"加入成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [lhHubLoading disAppearActivitiView];
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

//直购
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
    NSDictionary * dic = [oilArray objectAtIndex:inputField.tag];

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
    
    [self cancelInputEvent];
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSArray * tArray = [[oilArray objectAtIndex:actionSheet.tag] objectForKey:@"managerList"];
    
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",[[tArray objectAtIndex:buttonIndex-1] objectForKey:@"phone"]];
    
    if (![NSURL URLWithString:str]) {
        [lhUtilObject showAlertWithMessage:@"电话号码格式错误~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    NSString * idStr = [NSString stringWithFormat:@"%@",[[oilArray objectAtIndex:actionSheet.tag] objectForKey:@"id"]];
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
        
        NSArray * tArray = [[oilArray objectAtIndex:button_.tag] objectForKey:@"managerList"];
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        for (int i = 0; i < tArray.count; i++) {
            NSDictionary * dic = [tArray objectAtIndex:i];
            NSString * btnStr =[NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"name"],[dic objectForKey:@"phone"]];
            [actionSheet addButtonWithTitle:btnStr];
        }
        actionSheet.tag = button_.tag;
        [actionSheet showInView:self.view];
        
    }
    
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString * cityS = [self.filterCityDic objectForKey:@"name"];
    [filterView setCityStr:cityS];
    
    if (!isFirst) {
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
    }
//    NSLog(@"=====%@",self.filterCityDic);
    [self requestFilterData:self.filterCityDic];
    
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
