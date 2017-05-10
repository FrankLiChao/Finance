//
//  lhUserProtocolViewController.m
//  GasStation
//
//  Created by liuhuan on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "lhUserProtocolViewController.h"
#import "NJKWebViewProgressView.h"
#import "lhStartViewController.h"

@interface lhUserProtocolViewController ()<rightBtnDelegate>
{
    //显示服务条款
    UIWebView * fxWebView;
    //加载进度条显示
    UIProgressView * fxProgressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation lhUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:self.titleStr isBackBtn:YES rightBtn:nil];
    nb.delegate = self;
    [self.view addSubview:nb];
    
    fxWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    fxWebView.scrollView.showsVerticalScrollIndicator = NO;
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
    
    if (self.urlStr && self.urlStr.length) {
        NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
//        NSLog(@"%@",self.urlStr);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [fxWebView loadRequest:req];
        });
    }
    else if(self.htmlStr && self.htmlStr.length){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [fxWebView loadHTMLString:self.htmlStr baseURL:nil];
        });
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressView setProgress:0 animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完成");
    fxWebView.scrollView.contentOffset = CGPointMake(0, 0);
    [_progressView setProgress:1 animated:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}

#pragma mark - 返回事件
- (void)backBtnEvent
{
    if (self.type == 5) {
        [lhStartViewController gotoMainView:nil];
    }
    else{
        if([fxWebView canGoBack]){
            [fxWebView goBack];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
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
