//
//  lhMessageViewController.m
//  SCFinance
//
//  Created by bosheng on 16/5/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMessageViewController.h"
#import "lhMainRequest.h"
#import "FrankBaseCell.h"
#import "FrankBaseModel.h"
#import "FrankAutoLayout.h"
#import "FrankDetailsView.h"
#import "MJRefresh.h"
#import "LHJsonModel.h"
#import "FrankTools.h"
#import "UIColor+lhColor.h"
#import "lhUtilObject.h"


@interface lhMessageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *titleScrollView;  //显示滚动标题
    UIScrollView *maxScrollView;    //主ScrollView
    UIView  *titleView;             //标题View
    NSMutableArray *titleArray;            //资讯标题数据
    NSInteger nowTag;               //现在的Tag值
    NSMutableDictionary *pageDataDic;//每页的数据
    NSInteger currentPage;             //当前页码
    
    NSMutableDictionary *lunboDic;  //轮播字典
    
    NSInteger pNo;      //消息当前页数
    NSInteger allPno;   //消息总页数
}

@end

@implementation lhMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:nil isBackBtn:NO rightBtn:nil];
    [self.view addSubview:nb];
    nowTag = 100;
    pageDataDic = [NSMutableDictionary new];
    titleArray = [NSMutableArray new];
    lunboDic = [NSMutableDictionary new];
    
    [lhHubLoading addActivityView:self.view];
    [self initData];
    [self requstTitleData];
}

-(void)initData
{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:saveInformationToFile];
    if (dic && dic.count) {
        pageDataDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:saveInformationToFile];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSDictionary *lDic = [[NSUserDefaults standardUserDefaults] objectForKey:saveLunboInformationToFile];
    if (lDic && lDic.count) {
        lunboDic = [[NSMutableDictionary alloc] initWithDictionary:lDic];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:saveLunboInformationToFile];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:saveTitleInformationToFile];
    if (array && array.count) {
        titleArray = [[NSMutableArray alloc] initWithArray:array];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:saveTitleInformationToFile];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerRefresh];
}

#pragma mark - 刷新和加载
//下拉刷新
- (void)headerRefresh
{
    pNo = 1;
    [self reqestPageData:nowTag-100];
}

//上拉加载
- (void)footerRefresh
{
    if (pNo >= allPno) {
        [lhUtilObject showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-88];
        UITableView *tab = (UITableView *)[maxScrollView viewWithTag:100+nowTag];
        [tab footerEndRefreshing];
        return;
    }
    
    pNo++;
    [self reqestPageData:nowTag-100];
}

-(void)requstTitleData
{
    FLLog(@"%@",titleArray);
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findCategorys") parameters:@{} method:@"POST" success:^(id responseObject) {
        titleArray = [[NSMutableArray alloc] initWithArray:responseObject];
        if (![[titleArray[0] objectForKey:@"id"] isEqualToString:@"hot"]) {
            NSDictionary *dic = @{@"id":@"hot",@"name":@"热点资讯"};
            [titleArray insertObject:dic atIndex:0];
        }
        NSLog(@"titleArray = %@",titleArray);
        if ([lhUtilObject shareUtil].isOnLine) {//登录就加“我的收藏”
            NSDictionary *dic = @{@"id":@"collect",@"name":@"我的收藏"};
            [titleArray addObject:dic];
        }
        [self reqestPageData:0];
        [self initFrameView];
        [[NSUserDefaults standardUserDefaults] setObject:titleArray forKey:saveTitleInformationToFile];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }fail:^(id error){
        [self initFrameView];
        [lhMainRequest checkRequestFail:error];
    }];
    if (![[titleArray[0] objectForKey:@"id"] isEqualToString:@"hot"]) {
        NSDictionary *dic = @{@"id":@"hot",@"name":@"热点资讯"};
        [titleArray insertObject:dic atIndex:0];
    }
}

//获取资讯列表
-(void)reqestPageData:(NSInteger)page
{
    if (titleArray.count) {
        NSDictionary *dic = nil;
        if ([lhUtilObject shareUtil].isOnLine) {
            NSString *userId = [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
            dic = @{@"categoryId":[titleArray[page] objectForKey:@"id"],
                    @"userId":userId,
                    @"pm.pageSize":@"20",
                    @"pm.pageNo":@"1"};
        }else
        {
            dic = @{@"categoryId":[titleArray[page] objectForKey:@"id"],
                    @"pm.pageSize":@"20",
                    @"pm.pageNo":@"1"};
        }
//        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findArticleByPage") parameters:dic method:@"POST" success:^(id responseObject) {
            [lhHubLoading disAppearActivitiView];
            NSArray *array = [NSArray new];
            NSArray *lunboA = [NSArray new];
            if (pNo == 1) {
                allPno = [[[responseObject objectForKey:@"pm"] objectForKey:@"totalPages"]integerValue];
                array = [[responseObject objectForKey:@"pm"] objectForKey:@"data"];
                lunboA = [responseObject objectForKey:@"slideArticle"];
            }
            else{
                NSArray * tempA = [[responseObject objectForKey:@"pm"]objectForKey:@"data"];
                if (tempA && tempA.count > 0) {
                    NSMutableArray * tArray = [NSMutableArray arrayWithArray:array];
                    [tArray addObjectsFromArray:tempA];
                    array = tArray;
                }
            }
            if (!array.count) {
                array = @[];
            }
            //缓存页面数据
            [pageDataDic setObject:array forKey:[NSString stringWithFormat:@"%@",[titleArray[page] objectForKey:@"id"]]];
            [[NSUserDefaults standardUserDefaults] setObject:pageDataDic forKey:saveInformationToFile];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //缓存轮播数据
            if (!lunboA.count) {
                lunboA = @[];
            }
            [lunboDic setObject:lunboA forKey:[NSString stringWithFormat:@"%@",[titleArray[page] objectForKey:@"id"]]];
            [[NSUserDefaults standardUserDefaults] setObject:lunboDic forKey:saveLunboInformationToFile];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //取出当前页面的Data数据
            NSArray *nowArray = [pageDataDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
            
            UITableView *tab = (UITableView *)[maxScrollView viewWithTag:200+page];
            [tab reloadData];
            if (nowArray.count) {
                [lhUtilObject removeNullLabelWithSuperView:tab];
                tab.backgroundColor = [UIColor whiteColor];
            }else
            {
                [lhUtilObject addANullLabelWithSuperView:tab withText:@"暂无数据"];
                tab.backgroundColor = lhviewColor;
            }
            [tab footerEndRefreshing];
            [tab headerEndRefreshing];
            
        }fail:^(id error){
            [lhHubLoading disAppearActivitiView];
            UITableView *tab = (UITableView *)[maxScrollView viewWithTag:200+page];
            [tab reloadData];
            [tab headerEndRefreshing];
            [tab footerEndRefreshing];
            [lhUtilObject wangluoAlertShow];
        }];
    }
}

-(NSMutableArray *)arrayToModel:(NSArray *)array
{
    NSMutableArray *tempArray= [NSMutableArray new];
    for (int i = 0; i<array.count; i++) {
        FrankBaseModel *model = [FrankBaseModel new];
        model.adsTitle = [array[i] objectForKey:@"title"];
        model.adsTime = [FrankTools LongTimeToString:[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"createTime"]] withFormat:@"YYYY-MM-dd"];
        model.readCount = [FrankTools stringToNSNumber:[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"hits"]]];
        model.collectCount = [FrankTools stringToNSNumber:[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"collects"]]];
        model.adsId = [array[i] objectForKey:@"id"];
        model.imgsrc = [array[i] objectForKey:@"image"];
        NSInteger type = [[array[i] objectForKey:@"type"] integerValue];
        if (type == 1) {
            model.imgType = @1;
        }
        
        [tempArray addObject:model];
    }
    return tempArray;
}

-(void)initFrameView
{
    titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10*widthRate, 20, DeviceMaxWidth-20*widthRate, 44)];
    titleScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleScrollView];
    CGFloat width = (DeviceMaxWidth-20*widthRate)/4;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(i*width, 0, (DeviceMaxWidth-20*widthRate)/4, 44);
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [titleBtn setTitle:[titleArray[i] objectForKey:@"name"] forState:UIControlStateNormal];
        titleBtn.tag = i+100;
        nowTag = 100;
        [titleBtn setTitleColor:lhmainColor forState:UIControlStateSelected];
        [titleBtn setTitleColor:[UIColor colorFromHexRGB:@"cecece"] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(clickTitleEvent:) forControlEvents:UIControlEventTouchUpInside];
        [titleScrollView addSubview:titleBtn];
        
        if (i == 0) {
            titleBtn.selected = YES;
            [UIView animateWithDuration:0.4 animations:^{
                titleBtn.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
            }];
        }
    }
    titleScrollView.contentSize = CGSizeMake(width*titleArray.count, 44);
   
    maxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64-49)];
    maxScrollView.pagingEnabled = YES;
    maxScrollView.showsHorizontalScrollIndicator = NO;
    maxScrollView.showsVerticalScrollIndicator = NO;
    maxScrollView.delegate = self;
    [self.view addSubview:maxScrollView];
    
    maxScrollView.contentSize = CGSizeMake(DeviceMaxWidth*titleArray.count, CGRectGetHeight(maxScrollView.frame));
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64-49) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 200;
    tableView.backgroundColor = lhviewColor;
    maxScrollView.contentOffset = CGPointMake(0, 0);
    [maxScrollView addSubview:tableView];
    
    [tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

-(void)initCurrentPage
{
    UITableView *tab = (UITableView *)[maxScrollView viewWithTag:200+currentPage];
    if (!tab) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(currentPage*DeviceMaxWidth, 0, DeviceMaxWidth, DeviceMaxHeight-64-49) style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = 200+currentPage;
        tableView.backgroundColor = lhviewColor;
        maxScrollView.contentOffset = CGPointMake(currentPage*DeviceMaxWidth, 0);
        [maxScrollView addSubview:tableView];
        [tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
        [tableView addFooterWithTarget:self action:@selector(footerRefresh)];
        
        NSArray *array = [pageDataDic objectForKey:[titleArray[currentPage] objectForKey:@"title"]];
        
        if (!array.count) {
            pNo = 1;
            [self reqestPageData:currentPage];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = DeviceMaxWidth;
    // 根据当前的x坐标和页宽度计算出当前页数
    
    if (scrollView == maxScrollView) {
        if ((int)scrollView.contentOffset.x%(int)DeviceMaxWidth == 0) {
            
            currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            
            int itemIndex = (scrollView.contentOffset.x + DeviceMaxWidth * 0.5) / DeviceMaxWidth;
            if (!titleArray.count) return;
            int indexOnPageControl = itemIndex % titleArray.count;
            nowTag = indexOnPageControl+100;
            currentPage = indexOnPageControl;
            [self initCurrentPage];
            [self setTitleView];
        }
    }
}

-(void)setTitleView
{
    if (nowTag<100) {
        return;
    }
    UIButton *button_ = [self.view viewWithTag:nowTag];
    for (int i=0; i<titleArray.count; i++) {
        if (i == nowTag-100) {
            button_.selected = YES;
            [UIView animateWithDuration:0.4 animations:^{
                button_.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
        }else{
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+100];
            btn.selected = NO;
            
            [UIView animateWithDuration:0.4 animations:^{
                btn.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
    }
    [titleScrollView scrollRectToVisible:CGRectMake(button_.frame.origin.x, 0, DeviceMaxWidth-20*widthRate, 44) animated:YES];
}

#pragma mark - UItabViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [pageDataDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    NSArray *lunboA = [lunboDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    if (lunboA.count) {
        return array.count+1;
    }
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [pageDataDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    NSMutableArray *arrayModel = [self arrayToModel:array];
    NSArray *lunboA = [lunboDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    if (lunboA.count) {
        FrankBaseModel *model1 = [FrankBaseModel new];
        model1.hasHeadImg = @1;
        model1.lunboArray = lunboA;
        model1.tempVc = self;
        [arrayModel insertObject:model1 atIndex:0];
    }
    FrankBaseModel *model =  arrayModel[indexPath.row];
    
    if (model.hasHeadImg) {
        return 210;
    }else if (model.imgType){
        return 242;
    }
    else{
        return 95;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FrankBaseCell * cell = nil;
    NSArray *array = [pageDataDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    NSArray *lunboA = [lunboDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    NSMutableArray *arrayModel = [self arrayToModel:array];
    if (lunboA.count) {
        FrankBaseModel *model1 = [FrankBaseModel new];
        model1.hasHeadImg = @1;
        model1.tempVc = self;
        model1.lunboArray = lunboA;
        [arrayModel insertObject:model1 atIndex:0];
    }
    FrankBaseModel *baseModel =  arrayModel[indexPath.row];
    
    NSString * identifier = [FrankBaseCell cellIdentifierForRow:baseModel];
    Class mClass =  NSClassFromString(identifier);
    
    cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[mClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.baseModel = baseModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [pageDataDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    NSArray *lunboA = [lunboDic objectForKey:[titleArray[nowTag-100] objectForKey:@"id"]];
    if (lunboA.count ) {
        array = [[NSMutableArray alloc] initWithArray:array];
        [array insertObject:lunboA atIndex:0];
    }
//    FLLog(@"array = %@,%ld",array,indexPath.row);
    FrankDetailsView *detailsView = [FrankDetailsView new];
    detailsView.titleStr = [NSString stringWithFormat:@"%@",[array[indexPath.row] objectForKey:@"title"]];
    detailsView.articleId = [NSString stringWithFormat:@"%@",[array[indexPath.row] objectForKey:@"id"]];
    detailsView.imageStr = [NSString stringWithFormat:@"%@",[array[indexPath.row] objectForKey:@"image"]];
    detailsView.myWebUrl = [NSString stringWithFormat:@"%@",PATH(@"client_findArticle")];
    detailsView.isCollected = [[array[indexPath.row] objectForKey:@"isCollected"] integerValue];
    detailsView.type = 5;
    [[lhTabBar shareTabBar].navigationController pushViewController:detailsView animated:YES];
}

-(void)clickTitleEvent:(UIButton *)button_
{
    if (button_.selected) {
        return;
    }
    
    nowTag = button_.tag;
    for (int i=0; i<titleArray.count; i++) {
        if (i == button_.tag-100) {
            button_.selected = YES;
            [UIView animateWithDuration:0.4 animations:^{
                button_.transform = CGAffineTransformMakeScale( 1.2, 1.2);
            }];
            
        }else{
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+100];
            btn.selected = NO;
            
            [UIView animateWithDuration:0.4 animations:^{
                button_.transform = CGAffineTransformMakeScale(1, 1);
            }];
            
        }
    }
    maxScrollView.contentOffset = CGPointMake((button_.tag-100)*DeviceMaxWidth, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
