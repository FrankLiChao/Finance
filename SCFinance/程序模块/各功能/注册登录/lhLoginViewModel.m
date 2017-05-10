//
//  lhLoginViewModel.m
//  SCFinance
//
//  Created by bosheng on 16/5/20.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhLoginViewModel.h"
#import "LHJsonModel.h"
#import "MyMD5.h"
#import "lhLoginView.h"

@implementation lhLoginViewModel

//注册
+ (void)registerWithPhone:(NSString *)phoneStr password:(NSString *)pwd success:(void (^)(lhUserModel *))success
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_register"];
    NSDictionary * parameters = @{@"phone":phoneStr,
                                  @"password":[MyMD5 md5:pwd],
                                  @"token":[lhUtilObject shareUtil].realToken,
                                  @"clientType":@"1"};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        NSDictionary *dict = responseObject;
//        FLLog(@"注册结果=%@",dict);
        lhUserModel *model = [LHJsonModel modelWithDict:dict className:@"lhUserModel"];
        if (success) {
            success(model);
        }
    }fail:nil];
}

//登录
+ (void)loginWithPhone:(NSString *)phoneStr password:(NSString *)pwd success:(void (^)(lhUserModel *))success  fail:(void (^)(id error))fail
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_login"];
    NSDictionary * parameters = @{@"phone":phoneStr,
                                  @"password":pwd.length>25?pwd:[MyMD5 md5:pwd],
                                  @"token":[lhUtilObject shareUtil].realToken,
                                  @"clientType":@"1"};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        
        NSString * cartSizeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cartSize"]];
        [[lhTabBar shareTabBar] sizeToFitWithText:cartSizeStr];
        
        lhUserModel *model = [LHJsonModel modelWithDict:dict className:@"lhUserModel"];
        if (success) {
            success(model);
        }
    }fail:fail];
}

//获取短信验证码
+ (void)getMessageValidate:(NSString *)phoneStr withType:(NSInteger)type success:(void (^)(lhVoiceMessageModel * user))success
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,type==3?@"gen_registVerCode":@"gen_verCode"];
    NSDictionary * parameters = @{@"phone":phoneStr};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        lhVoiceMessageModel *model = [LHJsonModel modelWithDict:dict className:@"lhVoiceMessageModel"];
        if (success) {
            success(model);
        }
    }fail:nil];
}

//获取语音验证码
+ (void)getVoiceValidate:(NSString *)phoneStr withType:(NSInteger)type success:(void (^)(lhVoiceMessageModel * user))success
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,type==3? @"gen_registPhoneVerCode":@"gen_phoneCode"];
    NSDictionary * parameters = @{@"phone":phoneStr};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        lhVoiceMessageModel *model = [LHJsonModel modelWithDict:dict className:@"lhVoiceMessageModel"];
        if (success) {
            success(model);
        }
    }fail:nil];
}

//重置登录密码
+ (void)setLoginPassword:(NSString *)phone withPassword:(NSString *)password success:(void (^)(lhUserModel *))success
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,@"client_findPassword"];
    NSDictionary * parameters = @{@"phone":phone,
                                  @"newPassword":[MyMD5 md5:password],
                                  @"clientType":@"1"};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:parameters] method:@"POST" success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        lhUserModel *model = [LHJsonModel modelWithDict:dict className:@"lhUserModel"];
        if (success) {
            success(model);
        }
    }fail:nil];
}

#pragma mark - 手机号验证
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateMobile:(NSString *)mobile
{
    if (mobile && mobile.length == 11 && [mobile characterAtIndex:0] == '1') {
        return YES;
    }
    
    return NO;
}

#pragma mark - 发送语音验证码验证
+ (BOOL)isValidateSendVoice:(lhLoginView *)lView validateCount:(NSInteger)validateCount
{
    
    if(validateCount == 0){
        [lhUtilObject showAlertWithMessage:@"请先发送短信验证码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    
    if (lView.vaButtonS.selected) {
        [lhUtilObject showAlertWithMessage:@"正在发送验证码，请稍后~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    
    if ([@"" isEqualToString:lView.tellField.text]) {
        [lhUtilObject showAlertWithMessage:@"请输入11位手机号码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    else if(![lhLoginViewModel isValidateMobile:lView.tellField.text]){//验证失败
        [lhUtilObject showAlertWithMessage:@"手机号格式不正确~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 登录验证
+ (BOOL)isValidateLogin:(lhLoginView *)lView validateCount:(NSInteger)validateCount type:(NSInteger)type withValidateStr:(NSString *)validateStr withOldTellStr:(NSString *)tellStr
{
    if([@"" isEqualToString:lView.tellField.text]) {
        [lhUtilObject showAlertWithMessage:@"请输入11位手机号码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    
    if(![lhLoginViewModel isValidateMobile:lView.tellField.text]){
        [lhUtilObject showAlertWithMessage:@"手机号格式不正确~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    
    if (!type) {//登录，不用判断是否发送验证码
    }
    else{
        if (validateCount == 0) {
            [lhUtilObject showAlertWithMessage:@"请先获取验证码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
            
            return NO;
        }
    }
    
    if (lView.passField) {
        if ([@"" isEqualToString:lView.passField.text]) {
            [lhUtilObject showAlertWithMessage:@"请输入密码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
            
            return NO;
        }
        if(type == 3 && (lView.passField.text.length < 6 || lView.passField.text.length > 20)){
            [lhUtilObject showAlertWithMessage:@"密码长度应为6-20位~" withSuperView:lView withHeih:DeviceMaxHeight/2];
            
            return NO;
        }
    }
    
    if (lView.validateField && [@"" isEqualToString:lView.validateField.text]) {
        [lhUtilObject showAlertWithMessage:@"请输入验证码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }

    if (!type) {//登录，不用判断验证码是否正确
    }
    else{
        if(![validateStr isEqualToString:lView.validateField.text]){
            [lhUtilObject showAlertWithMessage:@"验证码不正确~" withSuperView:lView withHeih:DeviceMaxHeight/2];
            
            return NO;
        }
    }
    
    if (!type) {//登录，不用判断验证码
    }
    else{
        if (![tellStr isEqualToString:lView.tellField.text]) {
            
            [lhUtilObject showAlertWithMessage:@"接受验证码号码和当前号码不一致~" withSuperView:lView withHeih:DeviceMaxHeight/2];
            
            return NO;
        }
    }

    return YES;
}

#pragma mark - 发送验证码验证
+ (BOOL)isValidateSendMessage:(lhLoginView *)lView
{
    if ([@"" isEqualToString:lView.tellField.text]) {
        [lhUtilObject showAlertWithMessage:@"请输入11位手机号码~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        return NO;
    }
    else if(![lhLoginViewModel isValidateMobile:lView.tellField.text]){//验证失败
        [lhUtilObject showAlertWithMessage:@"手机号格式不正确~" withSuperView:lView withHeih:DeviceMaxHeight/2];
        
        return NO;
    }
    
    return YES;
}

@end
