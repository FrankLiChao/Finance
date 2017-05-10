//
//  lhSetPWDViewController.m
//  GasStation
//
//  Created by bosheng on 16/5/12.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import "lhSetPWDViewController.h"
#import "lhLoginViewModel.h"
#import "LHJsonModel.h"
#import "MyMD5.h"

#define kAlphaNum @"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789"

@interface lhSetPWDViewController ()<UITextFieldDelegate>
{
    UIView *mainView;
    UITextField *pdField;

    UITextField *confirmPdField;
}

@end

@implementation lhSetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"设置登录密码" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nb];

    [self initFrameView];
}

-(void)initFrameView
{
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    mainView.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:mainView];
    
    CGFloat hight = 0;
    if (iPhone5 || iPhone6 || iPhone6plus) {
        hight += 46*widthRate;
    }
    else{
        hight += 35*widthRate;
    }
    
    pdField = [[UITextField alloc]initWithFrame:CGRectMake(32.5*widthRate, hight, DeviceMaxWidth-65*widthRate, 52*widthRate)];
    pdField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    pdField.textColor = [UIColor grayColor];
    pdField.placeholder = @"请输入密码 (6位以上)";
    pdField.delegate = self;
    pdField.secureTextEntry = YES;
    pdField.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:pdField];
    [pdField becomeFirstResponder];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(32.5*widthRate, hight+45*widthRate, DeviceMaxWidth-65*widthRate, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [mainView addSubview:lineView];
    
    hight += 52*widthRate;
    
    confirmPdField = [[UITextField alloc]initWithFrame:CGRectMake(32.5*widthRate, hight, DeviceMaxWidth-65*widthRate, 52*widthRate)];
    confirmPdField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    confirmPdField.textColor = [UIColor grayColor];
    confirmPdField.placeholder = @"请确认密码";
    confirmPdField.delegate = self;
    confirmPdField.secureTextEntry = YES;
    confirmPdField.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:confirmPdField];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(32.5*widthRate, hight+45*widthRate, DeviceMaxWidth-65*widthRate, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [mainView addSubview:lineView1];
    
    hight += 92*widthRate;
    
    UIButton * completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.layer.cornerRadius = 4;
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.allowsEdgeAntialiasing = YES;
    completeBtn.frame = CGRectMake(32.5*widthRate, hight, DeviceMaxWidth-65*widthRate, 40*widthRate);
    completeBtn.backgroundColor = lhmainColor;
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:completeBtn];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-64-25*widthRate, 60*widthRate, 18*widthRate)];
    logo.image = imageWithName(@"refreshLogo");
    [mainView addSubview:logo];
}

-(void)completeBtnEvent
{
    [self validationPassword];
}

-(void)validationPassword
{

    if ([pdField.text isEqualToString:@""]) {
        [lhUtilObject showAlertWithMessage:@"请输入密码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if (pdField.text.length < 6) {
        [lhUtilObject showAlertWithMessage:@"请输入六位及六位以上的密码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([confirmPdField.text isEqualToString:@""]) {
        [lhUtilObject showAlertWithMessage:@"请确认密码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        [confirmPdField becomeFirstResponder];
        return;
    }
    if (![pdField.text isEqualToString:confirmPdField.text]) {
        [lhUtilObject showAlertWithMessage:@"两次密码不一致，请重新输入~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        [confirmPdField becomeFirstResponder];
        return;
    }
    
    [lhHubLoading addActivityView1OnlyActivityView:self.view];
    [lhLoginViewModel setLoginPassword:self.phone withPassword:pdField.text success:^(lhUserModel *user) {
        [lhHubLoading disAppearActivitiView];
        
        [lhUtilObject showAlertWithMessage:@"密码设置成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
    
        [lhUtilObject shareUtil].isOnLine = YES;
        
//        //本地化登陆用户
//        NSMutableDictionary * userDic = [NSMutableDictionary dictionaryWithDictionary:[LHJsonModel dictionaryWithModel:user]];
//        [userDic setObject:[MyMD5 md5:pdField.text] forKey:@"password"];
//        [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:saveLoginInfoFile];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        //登陆成功后延长自动登陆时间,30天
//        double tim = (double)[[NSDate date]timeIntervalSince1970]+3600*24*30;
//        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //本地化登陆用户
        NSMutableDictionary * userDic = [NSMutableDictionary dictionaryWithDictionary:[LHJsonModel dictionaryWithModel:user]];
        [userDic setObject:[MyMD5 md5:pdField.text] forKey:@"password"];
        //    [lhUtilObject shareUtil].userInfor = userDic;
        [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:saveLoginInfoFile];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //登陆成功后延长自动登陆时间,30天
        double tim = (double)[[NSDate date]timeIntervalSince1970]+3600*24*30;
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:tim] forKey:autoLoginTimeFile];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        [self performSelector:@selector(dismissEvent) withObject:nil afterDelay:1.5];
    }];
    
    
}

-(void)dismissEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == pdField) {
        if (pdField.text.length>20) {
            [lhUtilObject showAlertWithMessage:@"密码最大长度为20位~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            return NO;
        }
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"键盘消失");
    [pdField resignFirstResponder];
    [confirmPdField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
