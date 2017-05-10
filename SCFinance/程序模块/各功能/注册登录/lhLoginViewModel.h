//
//  lhLoginViewModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/20.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lhVoiceMessageModel.h"
@class lhLoginView;

@interface lhLoginViewModel : NSObject


/**
 *登录
 *phoneStr:电话号码
 *success:请求成功block，返回值为lhUserModel对象
 */
+ (void)loginWithPhone:(NSString *)phoneStr password:(NSString *)pwd success:(void (^)(lhUserModel * user))success fail:(void (^)(id error))fail;

/**
 *注册
 *phoneStr:电话号码
 *success:请求成功block，返回值为lhUserModel对象
 */
+ (void)registerWithPhone:(NSString *)phoneStr password:(NSString *)pwd success:(void (^)(lhUserModel * user))success;

/**
 *注册和重置密码发送短信验证码
 *phoneStr:电话号码
 *type:界面类型，3注册，2重置密码，其他，登录
 *success:请求成功block，返回值为lhVoiceMessageModel对象
 */
+ (void)getMessageValidate:(NSString *)phoneStr withType:(NSInteger)type success:(void (^)(lhVoiceMessageModel * user))success;

/**
 *注册和重置密码发送语音验证码
 *phoneStr:电话号码
 *type:界面类型，3注册，2重置密码，其他，登录
 *success:请求成功block，返回值为lhVoiceMessageModel对象
 */
+ (void)getVoiceValidate:(NSString *)phoneStr withType:(NSInteger)type success:(void (^)(lhVoiceMessageModel * user))success;

/**
 *重置登录密码
 *userId:用户唯一标示
 *password:修改之后的密码
 *success:请求成功block，返回值为lhUserModel对象
 */
+ (void)setLoginPassword:(NSString *)userId withPassword:(NSString *)password success:(void (^)(lhUserModel * user))success;

/**
 *手机号码验证
 *mobile:手机号
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**
 *收不到验证码，发送语音验证码本地验证
 *lView:界面
 *validateCount:发送验证码次数
 */
+ (BOOL)isValidateSendVoice:(lhLoginView *)lView validateCount:(NSInteger)validateCount;

/**
 *登录、注册、下一步按钮本地验证
 *lView:界面
 *validateCount:发送验证码次数
 *type:界面类型，3注册，2重置密码，其他，登录
 *validateStr:当前验证码
 *tellStr:发送验证码之前的电话号码
 */
+ (BOOL)isValidateLogin:(lhLoginView *)lView validateCount:(NSInteger)validateCount type:(NSInteger)type withValidateStr:(NSString *)validateStr withOldTellStr:(NSString *)tellStr;

/**
 *发送验证码
 *lView:界面
 */
+ (BOOL)isValidateSendMessage:(lhLoginView *)lView;

@end
