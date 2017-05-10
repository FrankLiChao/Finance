//
//  lhTabBar.m
//  SCFinance
//
//  Created by bosheng on 16/5/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhTabBar.h"
//#import "FrankAutoLayout.h"

static lhTabBar * shareTB;

@interface lhTabBar()<UITabBarControllerDelegate>
{
    UIButton * lastTabBtn;//当前tab字btn
    UIButton * mainTabBtn;//主页
    UIButton * newsTabBtn;//资讯
    UIButton * mineTabBtn;//我的
}

@end

@implementation lhTabBar

+ (instancetype)shareTabBar
{
    if (shareTB) {
        return shareTB;
    }
    
    shareTB = [[lhTabBar alloc]init];
    return shareTB;
}

- (instancetype)initWithTabViewControlers:(NSArray *)viewControlers
{
    if (!shareTB) {
        [lhTabBar shareTabBar];
    }
//    self.tabBC = [[UITabBarController alloc]init];
//    self.tabBC.viewControllers = viewControlers;
//    self.tabBC.delegate = self;
//    [self.view addSubview:self.tabBC.view];
    
    self = shareTB;
    self.viewControllers = viewControlers;
    self.delegate = self;
    
    //设置tabbar的字体大小和颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:lhmainColor} forState:UIControlStateSelected];
//    self.tabBC.tabBar.tintColor = lhmainColor;//设置选中图片的颜色
//    self.tabBC.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = lhmainColor;//设置选中图片的颜色
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    //设置tabbar图片
    UITabBarItem * mItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:0];
    [mItem setTitle:nil];
    [mItem setImage:imageWithName(@"tabbarMain")];
    [mItem setSelectedImage:imageWithName(@"tabbarMain_S")];
    UITabBarItem * bItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:1];
    [bItem setTitle:nil];
    [bItem setImage:imageWithName(@"tabbarShopCar")];
    [bItem setSelectedImage:imageWithName(@"tabbarShopCar_S")];
    UITabBarItem * xItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:2];
    [xItem setTitle:nil];
    [xItem setImage:imageWithName(@"tabbarNews")];
    [xItem setSelectedImage:imageWithName(@"tabbarNew_S")];
    UITabBarItem * pItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:3];
    [pItem setTitle:nil];
    [pItem setImage:imageWithName(@"tabbarPersonal")];
    [pItem setSelectedImage:imageWithName(@"tabbarPersonal_S")];
   
    //设置tabbar文字
    NSArray * tArray = @[@"首页",@"",@"资讯",@"我的"];
    for (int i=0; i < viewControlers.count; i++) {
        if (i == 1) {
            continue;
        }
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth/viewControlers.count*i, 31, DeviceMaxWidth/viewControlers.count, 18)];
        btn.tag = i;
        [btn setTitle:[tArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:lhmainColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shopCarTabBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            btn.userInteractionEnabled = NO;
            mainTabBtn = btn;
            lastTabBtn = mainTabBtn;
        }
        else if(i == 2){
            newsTabBtn = btn;
        }
        else{
            mineTabBtn = btn;
        }
    }
    
    //这是tabbar购物车
    _shopCarTabBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth/viewControlers.count+1, 31, DeviceMaxWidth/viewControlers.count, 18)];
    _shopCarTabBtn.tag = 1;
    [_shopCarTabBtn setTitle:@"购物车" forState:UIControlStateNormal];
    _shopCarTabBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_shopCarTabBtn setTitleColor:lhmainColor forState:UIControlStateSelected];
    [_shopCarTabBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_shopCarTabBtn addTarget:self action:@selector(shopCarTabBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_shopCarTabBtn];

    //初始化购物车上标记（badge）
    _shopCarBadge = [[UILabel alloc]init];
    _shopCarBadge.textAlignment = NSTextAlignmentCenter;
    _shopCarBadge.textColor = [UIColor whiteColor];
    _shopCarBadge.backgroundColor = lhredColorStr;
    _shopCarBadge.font = [UIFont systemFontOfSize:13];
    [self.tabBar addSubview:_shopCarBadge];
    
    if ([lhUserModel shareUserModel].cartSize) {
        [self sizeToFitWithText:[lhUserModel shareUserModel].cartSize];
    }
    
    return shareTB;
}

#pragma mark - 切换
- (void)shopCarTabBtnEvent:(UIButton *)button_
{
    if (button_.selected) {
        return;
    }
    
    if (button_.tag == 1 || button_.tag == 3) {
        if (![lhUtilObject loginIsOrNot]) {
            return;
        }
    }
    
    lastTabBtn.selected = NO;
    lastTabBtn.userInteractionEnabled = YES;
    button_.selected = YES;
    button_.userInteractionEnabled = NO;

    self.selectedIndex = button_.tag;
    UIViewController * viewController = [self.viewControllers objectAtIndex:button_.tag];
    [viewController viewWillAppear:NO];
    lastTabBtn = button_;
//    [self checkWithIndex:button_.tag];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [tabBarController selectedIndex];
    
    if (index == 1 || index == 3) {
        if (![lhUtilObject loginIsOrNot]) {
            self.selectedIndex = lastTabBtn.tag;
            return;
        }
    }
    
    if (lastTabBtn.tag == index) {
        return;
    }
    [viewController viewWillAppear:NO];
    
    [self mergeTabBarState];
//    [self checkWithIndex:index];
}

#pragma mark - 设置badge并调整其大小
- (void)sizeToFitWithText:(NSString *)badgeStr
{
    NSString * str = [NSString stringWithFormat:@"%@",badgeStr];
    
    if ([str integerValue] > 0) {
        _shopCarBadge.hidden = NO;
        _shopCarBadge.text = str;
        
        CGSize scSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        CGFloat width = scSize.width+10;
        if (width < 18) {
            width = 18;
        }
        CGFloat x = _shopCarTabBtn.frame.origin.x+(CGRectGetWidth(_shopCarTabBtn.frame)-30)/2+16;
        _shopCarBadge.frame = CGRectMake(x, 2, width, 18);
        _shopCarBadge.layer.cornerRadius = 9;
        _shopCarBadge.layer.masksToBounds = YES;
    }
    else{
        _shopCarBadge.hidden = YES;
    }
}

//#pragma mark - 判断，未登录点击我的
//- (void)checkWithIndex:(NSInteger)index
//{
//    if (index == 3) {
//        [lhUtilObject loginIsOrNot];
//    }
//}

//修改tabBar按钮状态
- (void)mergeTabBarState
{
    lastTabBtn.selected = NO;
    lastTabBtn.userInteractionEnabled = YES;
    switch (self.selectedIndex) {
        case 0:{
            mainTabBtn.selected = YES;
            lastTabBtn = mainTabBtn;
            break;
        }
        case 1:{
            _shopCarTabBtn.selected = YES;
            lastTabBtn = _shopCarTabBtn;
            break;
        }
        case 2:{
            newsTabBtn.selected = YES;
            lastTabBtn = newsTabBtn;
            break;
        }
        case 3:{
            mineTabBtn.selected = YES;
            lastTabBtn = mineTabBtn;
            break;
        }
        default:
            break;
    }
    lastTabBtn.userInteractionEnabled = NO;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIViewController * viewController = [self.viewControllers objectAtIndex:lastTabBtn.tag];
    [viewController viewWillAppear:animated];
    
    [self mergeTabBarState];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
