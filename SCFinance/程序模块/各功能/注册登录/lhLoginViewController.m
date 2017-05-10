//
//  lhLoginViewController.m
//  SCFinance
//
//  Created by bosheng on 16/5/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhLoginViewController.h"
#import "lhUserProtocolViewController.h"
#import "lhAlertView.h"
#import "lhSetPWDViewController.h"
#import "MyMD5.h"
#import "lhLoginViewModel.h"
#import "MMLocationManager.h"
#import "lhLoginView.h"
#import "LHJsonModel.h"

static const NSInteger maxTime = 60;
#define unclickBtnColor [UIColor colorFromHexRGB:@"b6e3ff"]

@interface lhLoginViewController ()<UITextFieldDelegate,firmBtnClickProtocol>
{
    lhLoginView * lView;//登录或注册界面
    
    NSTimer * coTimer;//定时器
    NSInteger countTimeS;//计时数字
    
    NSInteger validateCount;//发送验证码次数
    NSString * validateStr;//验证码字符串
    
    NSString * telStr;//存储发送短信的手机号码
    NSInteger isSetPassword;//判断是否已设置密码
    
    UIView * lineView;//电话输入框线
    UIView * lineView1;//验证码输入框线
    UIView * lineView2;//密码输入框线
}

@end

@implementation lhLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    lView = [[lhLoginView alloc]initWithFrame:self.view.bounds withType:self.type];
    lView.tellField.delegate = self;
    lView.passField.delegate = self;
    lView.validateField.delegate = self;
    if (lView.vaButtonS) {
        [lView.vaButtonS addTarget:self action:@selector(vaButtonEvent) forControlEvents:UIControlEventTouchUpInside];//发送验证码按钮
    }
    [lView.loginBtn addTarget:self action:@selector(loginButtonEvent) forControlEvents:UIControlEventTouchUpInside];//登录按钮
    [lView.fogetBtn addTarget:self action:@selector(noValidateEvent) forControlEvents:UIControlEventTouchUpInside];//忘记密码或收不到验证码按钮
    if (lView.protocolBtn) {
        [lView.protocolBtn addTarget:self action:@selector(protocolBtnEvent) forControlEvents:UIControlEventTouchUpInside];//跳转到协议
    }
    if (lView.registBtn) {
        [lView.registBtn addTarget:self action:@selector(registBtnEvent) forControlEvents:UIControlEventTouchUpInside];//点击注册或点击登录
    }
    [self.view addSubview:lView];
    
    countTimeS = maxTime-1;
    
    NSString * str = nil;
    if(self.type == 3){
        str = @"注册";
    }
    else if(self.type == 2){
        str = @"找回密码";
    }
    if (self.type) {
        lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:str isBackBtn:NO rightBtn:nil];
        [self.view addSubview:nb];
    }
    //返回按钮
    UIButton * backBg = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 20+20*widthRate, 44)];
    backBg.tag = backBtnTag;
    [backBg setImage:imageWithName(@"back") forState:UIControlStateNormal];
    [self.view addSubview:backBg];
    [backBg addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 用户协议
- (void)protocolBtnEvent
{
    NSString * aStr = @"http://www.gou-you.com/agreement.html";
    lhUserProtocolViewController * upVC = [[lhUserProtocolViewController alloc]init];
    upVC.titleStr = @"用户协议";
    upVC.urlStr = aStr;
    [self.navigationController pushViewController:upVC animated:YES];
    
}

#pragma mark - 注册或登录
- (void)registBtnEvent
{
    if(self.type == 3){//注册
        //点击登录
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{//登录
        //点击注册
        lhLoginViewController * lVC = [[lhLoginViewController alloc]init];
        lVC.type = 3;
        [self.navigationController pushViewController:lVC animated:YES];
    }
    
}

#pragma mark - 忘记密码或收不到验证码
- (void)noValidateEvent
{
    [self tapGEvent];
    if (!self.type) {//登录
        //忘记密码
        lhLoginViewController * lVC = [[lhLoginViewController alloc]init];
        lVC.type = 2;
        [self.navigationController pushViewController:lVC animated:YES];
    }
    else{//注册或找回密码
        //收不到验证码
        [self noValidateNotice];
    }
}

//收不到验证码提示
- (void)noValidateNotice
{
    if([lhLoginViewModel isValidateSendVoice:lView validateCount:validateCount]){
        NSString * str = [NSString stringWithFormat:@"将为您语音播报验证码，号码为%@%@，请您接听！",@"\n",lView.tellField.text];
        lhAlertView * aView = [[lhAlertView alloc]initWithFrame3:self.view.bounds noticeStr:str];
        aView.delegate = self;
        [self.view addSubview:aView];
    }
}

- (void)firmBtnClick:(lhAlertView *)alertView
{
    //发送语音验证码
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    __weak typeof(self) wSelf = self;
    [lhLoginViewModel getVoiceValidate:lView.tellField.text withType:self.type success:^(lhVoiceMessageModel *user) {
        [lhHubLoading disAppearActivitiView];
        
        validateStr = user.vercode;
        telStr = lView.tellField.text;
        
        [lhUtilObject showAlertWithMessage:@"语音验证码正在来的路上~" withSuperView:wSelf.view withHeih:DeviceMaxHeight/2];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([@"" isEqualToString:string]) {
        return YES;
    }
    
    if (textField == lView.tellField) {
        if (textField.text.length >= 11) {
            return NO;
        }
    }
    else if(self.type && textField == lView.validateField){
        if (textField.text.length >= 6) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (!self.type) {//登录
        if (iPhone5 || iPhone6 || iPhone6plus) {}
        else{//iphone4
            [UIView animateWithDuration:0.15 animations:^{
                CGRect rect = lView.frame;
                rect.origin.y = -50;
                lView.frame = rect;
            }];
        }
    }
    

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!self.type) {
        if (iPhone5 || iPhone6 || iPhone6plus) {}
        else{
            [UIView animateWithDuration:0.15 animations:^{
                CGRect rect = lView.frame;
                rect.origin.y = 0;
                lView.frame = rect;
            }];
            
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 发送验证码
- (void)vaButtonEvent
{
    if (lView.vaButtonS.selected) {
        return;
    }
    __weak typeof(self) wSelf = self;
    if ([lhLoginViewModel isValidateSendMessage:lView]) {
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        [lhLoginViewModel getMessageValidate:lView.tellField.text withType:self.type success:^(lhVoiceMessageModel *user) {
            [lhHubLoading disAppearActivitiView];
            
            validateStr = user.vercode;
            telStr = lView.tellField.text;
            
            [lhUtilObject showAlertWithMessage:@"发送成功,请注意查收~" withSuperView:wSelf.view withHeih:DeviceMaxHeight/2];
            validateCount++;
            
            lView.vaButtonS.selected = YES;
            lView.vaButtonS.userInteractionEnabled = NO;
            
            [lView.tellField resignFirstResponder];
            [lView.validateField becomeFirstResponder];
            
        }];
    }
}

//计时
- (void)countTimeEvent
{
    if (lView.vaButtonS.selected == NO){
        return;
    }

    if (countTimeS <= 0) {
        lView.vaButtonS.selected = NO;
        lView.vaButtonS.userInteractionEnabled = YES;
        [lView.vaButtonS setTitle:@"重新发送" forState:UIControlStateNormal];
        [lView.vaButtonS setTitle:@"已发送(60)" forState:UIControlStateSelected];
        countTimeS = maxTime-1;
    }
    else{
        lView.vaButtonS.userInteractionEnabled = NO;
        NSString * str = [NSString stringWithFormat:@"已发送(%ld)",(long)countTimeS];
        [lView.vaButtonS setTitle:str forState:UIControlStateSelected];

        countTimeS--;
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self tapGEvent];
}

- (void)tapGEvent
{
    //NSLog(@"键盘消失");
    [lView.tellField resignFirstResponder];
    if (lView.passField) {
        [lView.passField resignFirstResponder];
    }
    if (lView.validateField) {
        [lView.validateField resignFirstResponder];
    }
    
    
//    [self.view endEditing:YES];
}

#pragma mark - 点击
- (void)loginButtonEvent
{
    [self tapGEvent];
//    [self.view endEditing:YES];
    
    __weak typeof(self) wSelf = self;
    if ([lhLoginViewModel isValidateLogin:lView validateCount:validateCount type:self.type withValidateStr:validateStr withOldTellStr:telStr]) {
        if(self.type == 2){//重置登录密码
            lhSetPWDViewController * spVC = [[lhSetPWDViewController alloc]init];
            spVC.phone = telStr;
            [self.navigationController pushViewController:spVC animated:YES];
        }
        else{
            if (self.type == 3) {//注册
                [lhHubLoading addActivityView1OnlyActivityView:self.view];
                [lhLoginViewModel registerWithPhone:lView.tellField.text password:lView.passField.text success:^(lhUserModel *user) {
//                    NSLog(@"注册结果 %@",user);
                    [lhHubLoading disAppearActivitiView];
                    
                    wSelf.view.userInteractionEnabled = NO;
                    [lhUtilObject showAlertWithMessage:@"注册成功~" withSuperView:wSelf.view withHeih:DeviceMaxHeight/2];
                    [wSelf performSelector:@selector(rnButtonEvent) withObject:nil afterDelay:1.5];
                    
                    [wSelf loginSuccess:user];
                }];
            }
            else{//登录

                [lhHubLoading addActivityView1OnlyActivityView:self.view];
                [lhLoginViewModel loginWithPhone:lView.tellField.text password:lView.passField.text success:^(lhUserModel *user) {
//                    NSLog(@"登录结果 %@",user);
                    [lhHubLoading disAppearActivitiView];
                    
                    wSelf.view.userInteractionEnabled = NO;
                    [lhUtilObject showAlertWithMessage:@"登录成功~" withSuperView:wSelf.view withHeih:DeviceMaxHeight/2];
                    [wSelf performSelector:@selector(rnButtonEvent) withObject:nil afterDelay:1.5];
                    [wSelf loginSuccess:user];
                }fail:nil];
            }
        }
    }
    
}

- (void)loginSuccess:(lhUserModel *)user
{
    [lhUtilObject shareUtil].isOnLine = YES;
    
    //本地化登陆用户
    NSMutableDictionary * userDic = [NSMutableDictionary dictionaryWithDictionary:[LHJsonModel dictionaryWithModel:user]];
    [userDic setObject:[MyMD5 md5:lView.passField.text] forKey:@"password"];
//    [lhUtilObject shareUtil].userInfor = userDic;
    [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:saveLoginInfoFile];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //登陆成功后延长自动登陆时间,30天
    double tim = (double)[[NSDate date]timeIntervalSince1970]+3600*24*30;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)rnButtonEvent
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)backTo
{
    self.view.userInteractionEnabled = YES;
    if (self.type == 2 || self.type == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
                
        }];
    }
}

- (void)tapGestureEvent:(UITapGestureRecognizer *)tapG
{
    [UIView animateWithDuration:0.5 animations:^{
        tapG.view.transform = CGAffineTransformMakeScale(2, 2);
        tapG.view.alpha = 0;
    }completion:^(BOOL finished) {
        [tapG.view removeFromSuperview];
    }];
    
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (coTimer) {
        [coTimer invalidate];
        coTimer = nil;
    }
    if (self.type) {
        coTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeEvent) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (coTimer) {
        [coTimer invalidate];
        coTimer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
