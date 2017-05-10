//
//  lhMergeNameViewController.m
//  SCFinance
//
//  Created by bosheng on 16/6/12.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMergeNameViewController.h"
#define maxTextCount 11

@interface lhMergeNameViewController ()<rightBtnDelegate,UITextFieldDelegate>
{
    UITextField * nTextField;
}

@property (nonatomic,strong)NSString * oldNameStr;

@end

@implementation lhMergeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lhNavigationBar * nBar =  [[lhNavigationBar alloc]initWithVC:self title:@"修改昵称" isBackBtn:YES rightBtn:@"保存"];
    nBar.delegate = self;
    [self.view addSubview:nBar];
    
    [self firmInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 保存
- (void)rightBtnEvent
{
    if ([@"" isEqualToString:nTextField.text]){
        
        [lhUtilObject showAlertWithMessage:@"请输入昵称~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    if(nTextField.text.length > maxTextCount){
        [lhUtilObject showAlertWithMessage:@"昵称长度超出限制~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    if (![nTextField.text isEqualToString:self.oldNameStr]) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"mergeNameEvent" object:nil userInfo:@{@"content":nTextField.text}];
        
        NSDictionary *dic = @{@"userId":[lhUserModel shareUserModel].userId,
                              @"name":[NSString stringWithFormat:@"%@",nTextField.text]};
        
        [lhHubLoading addActivityView1OnlyActivityView:self.view];
        [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"clientInfo_changeName") parameters:dic method:@"POST" success:^(id responseObject) {
            [lhHubLoading disAppearActivitiView];
            
            [lhUserModel shareUserModel].name = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"name"]];
            [lhUtilObject showAlertWithMessage:@"修改成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            
            [self performSelector:@selector(backTo) withObject:nil afterDelay:1.5];
            
        } fail:nil];
        
    }
    else{
        [lhUtilObject showAlertWithMessage:@"昵称未做改变~" withSuperView:self.view withHeih:DeviceMaxHeight/2];

    }

}

- (void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nTextField resignFirstResponder];
}

#pragma mark - 界面初始化
- (void)firmInit
{
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+20*widthRate, DeviceMaxWidth, 40*widthRate)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [whiteView addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [whiteView addSubview:lineView1];
    
    nTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40*widthRate)];
    nTextField.clearButtonMode = UITextFieldViewModeAlways;
    nTextField.placeholder = @"请输入您的用户名";
    nTextField.keyboardType = UIKeyboardTypeDefault;
    nTextField.textColor = lhcontentTitleColorStr;
    nTextField.font = [UIFont systemFontOfSize:15];
    nTextField.returnKeyType = UIReturnKeyDone;
    nTextField.delegate = self;
    [whiteView addSubview:nTextField];
    
    NSString * birStr = [lhUserModel shareUserModel].name;
    if (birStr && birStr.length > 0 && ![birStr rangeOfString:@"null"].length) {
        nTextField.text = birStr;
        
        self.oldNameStr = nTextField.text;
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([@"" isEqualToString:string]) {
        return YES;
    }
    
    unichar ch = [string characterAtIndex:0];
    if (ch == ' ') {
        return NO;
    }
    
    NSString * ss = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (ss.length > maxTextCount) {
        return NO;
    }
    
    return YES;
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
