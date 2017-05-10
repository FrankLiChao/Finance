//
//  FrankFeedbackView.m
//  SCFinance
//
//  Created by lichao on 16/6/2.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankFeedbackView.h"
#import "lhNavigationBar.h"
#import "lhUtilObject.h"
#import "lhMainRequest.h"

@interface FrankFeedbackView ()<rightBtnDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView *feedTextView;
    UILabel *placeHolder;
}

@end

@implementation FrankFeedbackView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"意见反馈" isBackBtn:YES rightBtn:@"提交"];
    nb.delegate = self;
    [self.view addSubview:nb];
    [self initFrameView];
}

- (void)rightBtnEvent
{
    FLLog(@"点击提交按钮");
    [feedTextView resignFirstResponder];
    if ([@"" isEqualToString:feedTextView.text]) {
        [lhUtilObject showAlertWithMessage:@"请编辑反馈信息~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    [lhHubLoading addActivityView:self.view];
    NSDictionary *dic = @{@"userId":[lhUserModel shareUserModel].userId,
                          @"content":feedTextView.text};
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_addFeedback") parameters:dic method:@"POST" success:^(id responseObject) {
        FLLog(@"responseObject = %@",responseObject)
        
        [lhHubLoading disAppearActivitiView];
        
        [lhUtilObject showAlertWithMessage:@"我们已收到您的建议！非常感谢~" withSuperView:self.view withHeih:DeviceMaxHeight/2];

        [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
        
    } fail:^(id error) {
        [lhHubLoading disAppearActivitiView];
        [lhMainRequest checkRequestFail:error];
    }];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backBtnEvent
{
    if (![@"" isEqualToString:feedTextView.text]) {
        UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没发送，返回该信息将不会保存！" delegate:self cancelButtonTitle:@"返回上一级" otherButtonTitles:@"继续编辑", nil];
        alertV.tag = 2;
        [alertV show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2 && buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initFrameView
{
    CGFloat heih = 64+20*widthRate;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, heih, 300*widthRate, 20*widthRate)];
    titleLabel.text = @"请输入您的宝贵意见:";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = lhcontentTitleColorStr;
    [self.view addSubview:titleLabel];
    
    heih += 25*widthRate;
    
    feedTextView = [[UITextView alloc]initWithFrame:CGRectMake(10*widthRate, heih, DeviceMaxWidth-20*widthRate, 80*widthRate)];
    feedTextView.delegate = self;
    feedTextView.font = [UIFont systemFontOfSize:14];
    feedTextView.textColor = lhcontentTitleColorStr;
    [self.view addSubview:feedTextView];
    
    placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate+2, heih, DeviceMaxWidth-20*widthRate, 30*widthRate)];
    placeHolder.text = @"请输入";
    placeHolder.font = [UIFont systemFontOfSize:14];
    placeHolder.textColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
    [self.view addSubview:placeHolder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHolder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([@"" isEqualToString:textView.text]) {
        placeHolder.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [feedTextView resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [feedTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
