//
//  FrankDetailsView.m
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankDetailsView.h"
#import "FrankAutoLayout.h"
#import "NJKWebViewProgressView.h"
#import "lhUtilObject.h"
#import "FrankTools.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface FrankDetailsView ()<UIWebViewDelegate>
{
    UIScrollView *maxScrollView;
    UIWebView * fxWebView;
    //加载进度条显示
    UIProgressView * fxProgressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIView *bgView;
}

@end

@implementation FrankDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:nil isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nb];
    if (self.type == 5) { //表示咨询收藏页面
        [self initTitleView];
    }else{ //表示普通网页
        
    }
    
    if ([self.myWebUrl isEqualToString:@""] || self.myWebUrl == nil) {
        NSLog(@"暂无数据");
    }else{
        [self initFrameView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initTitleView
{
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(DeviceMaxWidth-72, 20, 30, 44);
    [collectBtn setImage:imageWithName(@"shouchang_no") forState:UIControlStateNormal];
    [collectBtn setImage:imageWithName(@"shouchang_yes") forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(clickCollectEvent:) forControlEvents:UIControlEventTouchUpInside];
    if (self.isCollected == 1) {
        collectBtn.selected = YES;
    }else
    {
        collectBtn.selected = NO;
    }
    [self.view addSubview:collectBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(DeviceMaxWidth-36, 20, 30, 44);
    [editBtn setImage:imageWithName(@"edit__edit") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEditEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
}

-(void)clickCollectEvent:(UIButton *)button_
{
    if ([lhUtilObject loginIsOrNot]) {
        button_.selected = !button_.selected;
        [self collectionData];
    }
}

-(void)collectionData
{
    if ([lhUtilObject loginIsOrNot]) {
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        NSDictionary *dic = @{@"articleId":self.articleId,
                              @"userId":[lhUserModel shareUserModel].userId};
        FLLog(@"dic = %@",dic);
        [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_collectArticle") parameters:dic method:@"POST" success:^(id responseObject) {
            [lhHubLoading disAppearActivitiView];
            FLLog(@"responseObject = %@",responseObject);
            SHOW_ALERT([responseObject objectForKey:@"msg"]);
        } fail:nil];
    }
}

#pragma mark -UIActionSheetDelegate
-(void)clickEditEvent:(UIButton *)button_
{
    NSString * imageStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,self.imageStr];
    NSString * urlStr = [NSString stringWithFormat:@"%@?articleId=%@",self.myWebUrl,self.articleId];
    [lhUtilObject fxViewAppear:imageStr conStr:self.titleStr withUrlStr:urlStr withVc:self];
}

-(void)initFrameView
{
    fxWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    fxWebView.delegate = self;
    fxWebView.scalesPageToFit = YES;
    [self.view addSubview:fxWebView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    fxWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 2.0)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_progressView];
    
    [_progressView setProgress:0 animated:NO];
    NSString *urlString = nil;
    if (self.type == 5) {
        urlString = [NSString stringWithFormat:@"%@?articleId=%@",self.myWebUrl,self.articleId];
    }else{
        urlString = self.myWebUrl;
    }
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [fxWebView loadRequest:req];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressView setProgress:0 animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSLog(@"加载完成");
    fxWebView.scrollView.contentOffset = CGPointMake(0, 0);
    
//    NSLog(@"aaa == %@",[fxWebView stringByEvaluatingJavaScriptFromString:@"document.title"]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
