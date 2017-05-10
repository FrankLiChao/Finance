//
//  lhShopCarViewController.m
//  SCFinance
//
//  Created by bosheng on 16/5/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhShopCarViewController.h"
#import "lhLoginViewController.h"
#import "lhTabBar.h"
#import "lhShopCarView.h"
#import "lhShopCarTableViewCell.h"
#import "lhShopCarViewModel.h"
#import "MJRefresh.h"
#import "LHJsonModel.h"
#import "lhHubLoading.h"
#import "lhMainRequest.h"
#import "lhFirmOrderViewController.h"
#import "lhShopCarModel.h"

@interface lhShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray * shopCarArray;
    NSArray * selectArray;//已选择
    lhShopCarView * shopCarView;
    UITextField * nowTextField;
    
//    NSMutableDictionary *headBtnDic; //表头的selectBtn
//    NSMutableDictionary *cellBtnDic; //cell中的selectBtn
    
    CGFloat totalPrice;//总价
    NSInteger totalNum;//总数量，并非总吨数
    
}

@end

@implementation lhShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    headBtnDic = [[NSMutableDictionary alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;//0点从顶部开始
    self.navigationController.navigationBar.hidden = YES;//影藏系统的导航栏
    
    //购物车
    shopCarView = [[lhShopCarView alloc]initWithFrame:self.view.bounds];
    shopCarView.shopCarTableView.delegate = self;
    shopCarView.shopCarTableView.dataSource = self;
    [shopCarView.shopCarTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [shopCarView.settleBtn addTarget:self action:@selector(settleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [shopCarView.selectBtn addTarget:self action:@selector(allSelectBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [shopCarView.maxControl addTarget:self action:@selector(maxControlEvent) forControlEvents:UIControlEventTouchUpInside];
    shopCarView.lowView.hidden = YES;
    [self.view addSubview:shopCarView];
    
    //导航栏
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"购物车" isBackBtn:NO rightBtn:nil];
    [self.view addSubview:nb];
    
    if (![lhUtilObject shareUtil].isRefreshShopCar) {
        [lhHubLoading addActivityView:self.view];
        [self requstGWCData];
    }
    
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [self requstGWCData];
}

#pragma mark - 请求数据
-(void)requstGWCData
{
    [lhShopCarViewModel getShopCarDataSuccess:^(id response) {

        if ([lhUtilObject shareUtil].isRefreshShopCar) {
            [lhUtilObject shareUtil].isRefreshShopCar = NO;
        }
        
        NSMutableArray * tempArray = [NSMutableArray array];
        NSArray * tArray = [response objectForKey:@"dataList"];
        for (int i = 0; i < tArray.count; i++) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[tArray objectAtIndex:i]];
            [dic setObject:@"1" forKey:@"isSelected"];
            [tempArray addObject:dic];
        }
        
        shopCarArray = tempArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setPriceView];
            
            [shopCarView.shopCarTableView headerEndRefreshing];
            [lhHubLoading disAppearActivitiView];
        });
    }fail:^(id error){
        
        [lhMainRequest checkRequestFail:error];
        
//        shopCarArray = [NSArray array];

        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [self setPriceView];
            
            [shopCarView.shopCarTableView headerEndRefreshing];
            [lhHubLoading disAppearActivitiView];
        });
    }];
}

#pragma mark - 设置价格
- (void)setPriceView
{
    totalNum = 0;
    if (shopCarArray && shopCarArray.count) {
        shopCarView.lowView.hidden = NO;
        
        totalPrice = 0.0;
        selectArray = nil;
        NSMutableArray * tempA = [NSMutableArray array];
        for (int i = 0; i < shopCarArray.count; i++) {
            NSDictionary * dic = [shopCarArray objectAtIndex:i];
            lhShopCarModel * scModel = [LHJsonModel modelWithDict:dic className:@"lhShopCarModel"];
            if ([scModel.isSelected integerValue] == 1) {
                totalNum += 1;
                totalPrice += [scModel.price doubleValue]*[scModel.purchaseNumber integerValue];
                
                [tempA addObject:dic];
            }
            
        }
        
        selectArray = tempA;
        
        if (totalNum == shopCarArray.count) {
            shopCarView.selectBtn.selected = YES;
        }
        else{
            shopCarView.selectBtn.selected = NO;
        }
        
        NSString * priceStr = [NSString stringWithFormat:@"合计:%.2f元",totalPrice];
        shopCarView.totalLabel.attributedText = [lhShopCarViewModel setLabelStyle:priceStr];
        
        NSString * numStr = [NSString stringWithFormat:@"%ld",(long)totalNum];
        
        [shopCarView.settleBtn setTitle:[NSString stringWithFormat:@"结算(%@)",numStr] forState:UIControlStateNormal];
        
        [lhUtilObject removeNullLabelWithSuperView:shopCarView.shopCarTableView];
        CGRect tableRect = shopCarView.shopCarTableView.frame;
        tableRect.size.height = DeviceMaxHeight-164;
        shopCarView.shopCarTableView.frame = tableRect;
    }
    else{
        shopCarView.lowView.hidden = YES;
        
        [lhUtilObject addANullLabelWithSuperView:shopCarView.shopCarTableView withText:@"您的购物车没有商品\n快去逛逛吧"];
        
        CGRect tableRect = shopCarView.shopCarTableView.frame;
        tableRect.size.height = DeviceMaxHeight-113;
        shopCarView.shopCarTableView.frame = tableRect;
    }
    
    NSString * numStr = [NSString stringWithFormat:@"%ld",(long)shopCarArray.count];
    [[lhTabBar shareTabBar]sizeToFitWithText:numStr];
    
    [shopCarView.shopCarTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 全选
- (void)allSelectBtnEvent:(UIButton *)button_
{
    NSLog(@"全选");
    button_.selected = !button_.selected;
    
    if (button_.selected) {
        for (int i=0; i<shopCarArray.count; i++) {
            
            NSMutableDictionary * dic = [shopCarArray objectAtIndex:i];
            [dic setObject:@"1" forKey:@"isSelected"];

        }
    }
    else
    {
        for (int i=0; i<shopCarArray.count; i++) {
            
            NSMutableDictionary * dic = [shopCarArray objectAtIndex:i];
            [dic setObject:@"0" forKey:@"isSelected"];

        }
    }
    
    [self setPriceView];
}

#pragma mark - 结算
- (void)settleBtnEvent
{
    NSLog(@"结算详情");
    
//    if ([[lhUserModel shareUserModel].certificationStatus integerValue] == 0) {
//        [lhUtilObject showAlertWithMessage:@"您还未认证，请先认证~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
//        
//        return;
//    }
    
    if(totalPrice > 0){
        
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        [lhShopCarViewModel settle:selectArray success:^(id response) {
            [lhHubLoading disAppearActivitiView];
            
            lhFirmOrderViewController * foVC = [[lhFirmOrderViewController alloc]init];
            foVC.firmDic = response;
            [[lhTabBar shareTabBar].navigationController pushViewController:foVC animated:YES];
        }];
        
    }
    else{
        [lhUtilObject showAlertWithMessage:@"您还没有选择任何东西~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    }
    
}

#pragma mark - 点击结束键盘输入
- (void)maxControlEvent
{
    [self setPriceView];
    
    shopCarView.maxControl.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        [nowTextField resignFirstResponder];
    }completion:^(BOOL finished) {
        [lhShopCarView shareShopCarView].showLabel.cursor.hidden = YES;
    }];
    
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteOneData:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(shopCarArray && shopCarArray.count){

        return shopCarArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"sCell";
    
    lhShopCarTableViewCell * sCell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (sCell == nil) {
        sCell = [[lhShopCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    
    NSDictionary * dic = [shopCarArray objectAtIndex:indexPath.row];
    
    lhShopCarModel * scModel = [LHJsonModel modelWithDict:dic className:@"lhShopCarModel"];
    
    sCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",scModel.name,scModel.oilName];
    
    sCell.priceLabel.text = [NSString stringWithFormat:@"%@元/吨",scModel.price];
    sCell.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",scModel.policyPrice];
    
    sCell.inputField.tag = indexPath.row;
    sCell.inputField.delegate = self;
    sCell.inputField.text = [NSString stringWithFormat:@"%@",scModel.purchaseNumber];
    
    NSString * xjStr = [NSString stringWithFormat:@"小计: %.0f元",(CGFloat)[scModel.price integerValue]*[scModel.purchaseNumber integerValue]];
    sCell.totalLabel.text = xjStr;
    
    NSString * jsStr = [NSString stringWithFormat:@"已省 %.0f元",(CGFloat)([scModel.policyPrice integerValue]-[scModel.price integerValue])*[scModel.purchaseNumber integerValue]];
    sCell.jsLabel.text = jsStr;
    
    if([scModel.isSelected integerValue] == 1){
        sCell.selectBtn.selected = YES;
    }
    else{
        sCell.selectBtn.selected = NO;
    }
    
    sCell.selectBtn.tag = 3*indexPath.row+2;
    [sCell.selectBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    sCell.subBtn.tag = 3*indexPath.row;
    [sCell.subBtn addTarget:self action:@selector(subBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    sCell.addBtn.tag = 3*indexPath.row+1;
    [sCell.addBtn addTarget:self action:@selector(addBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [lhShopCarViewModel updateCell:sCell];
    
    return sCell;
}

#pragma mark - 表格选择
- (void)selectedBtn:(UIButton *)button_
{
    NSInteger row = (button_.tag-2)/3;
    button_.selected = !button_.selected;
    
    NSMutableDictionary * dic = [shopCarArray objectAtIndex:row];
    if (button_.selected) {
        [dic setObject:@"1" forKey:@"isSelected"];
    }
    else{
        [dic setObject:@"0" forKey:@"isSelected"];
    }
    
    [self setPriceView];
}

#pragma mark - 加减
- (void)subBtnEvent:(UIButton *)button_
{
    NSInteger row = (button_.tag)/3;
    
    NSMutableDictionary * dic = [shopCarArray objectAtIndex:row];
    NSString * pnStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"purchaseNumber"]];
    if ([pnStr integerValue] > 1) {
        NSString * pnStr0 = [NSString stringWithFormat:@"%ld",(long)[pnStr integerValue]-1];
        [dic setObject:pnStr0 forKey:@"purchaseNumber"];
        
        [self setPriceView];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除该商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = row;
        [alertView show];
    }

}

- (void)addBtnEvent:(UIButton *)button_
{
    NSInteger row = (button_.tag-1)/3;
    
    NSMutableDictionary * dic = [shopCarArray objectAtIndex:row];
    NSString * pnStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"purchaseNumber"]];
    NSString * pnStr1 = [NSString stringWithFormat:@"%ld",(long)[pnStr integerValue]+1];
    [dic setObject:pnStr1 forKey:@"purchaseNumber"];
    
    [self setPriceView];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {//删除购物车一条数据
        [self deleteOneData:alertView.tag];
    }
    
}

#pragma mark - 删除一条数据
- (void)deleteOneData:(NSInteger)tag
{
    __weak typeof(self) wSelf = self;
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhShopCarViewModel deleteOne:[shopCarArray objectAtIndex:tag] success:^(id response) {
        
        NSString * cartSizeStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"cartSize"]];
        [[lhTabBar shareTabBar]sizeToFitWithText:cartSizeStr];
        
        if (tag < shopCarArray.count) {
            NSMutableArray * tempA = [NSMutableArray arrayWithArray:shopCarArray];
            [tempA removeObjectAtIndex:tag];
            shopCarArray = tempA;
        }
        
        [wSelf setPriceView];
        
        [lhHubLoading disAppearActivitiView];
    } fail:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(textFieldChanged) withObject:nil afterDelay:0.05];
    
    return YES;
}

- (void)textFieldChanged
{
    if ([@"" isEqualToString:nowTextField.text] || [nowTextField.text integerValue] < 1) {
        nowTextField.text = @"";
        [lhShopCarView shareShopCarView].showLabel.text = @"";
    }
    else{
        [lhShopCarView shareShopCarView].showLabel.text = [@"数量：" stringByAppendingString:nowTextField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [[lhShopCarView shareShopCarView] anInputAccessoryView];
    [lhShopCarView shareShopCarView].cancelBtn.hidden = YES;
    [[lhShopCarView shareShopCarView].finishBtn addTarget:self action:@selector(maxControlEvent) forControlEvents:UIControlEventTouchUpInside];
    
    shopCarView.maxControl.hidden = NO;
    nowTextField = textField;
    
    [lhShopCarView shareShopCarView].showLabel.text = [@"数量：" stringByAppendingString:nowTextField.text];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([@"" isEqualToString:nowTextField.text] || [nowTextField.text integerValue] < 1) {
        nowTextField.text = @"1";

    }
    
    NSMutableDictionary * dic = [shopCarArray objectAtIndex:nowTextField.tag];
    [dic setObject:nowTextField.text forKey:@"purchaseNumber"];
    
    [lhShopCarView shareShopCarView].showLabel.text = [@"数量：" stringByAppendingString:nowTextField.text];
    [self setPriceView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([lhUtilObject shareUtil].isRefreshShopCar) {
        [shopCarView.shopCarTableView headerBeginRefreshing];
    }
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
