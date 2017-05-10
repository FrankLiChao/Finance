//
//  lhLoginView.h
//  SCFinance
//
//  Created by bosheng on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhLoginView : UIView

@property (nonatomic,strong)UITextField * tellField;//电话号码输入框
@property (nonatomic,strong)UITextField * passField;//密码输入框
@property (nonatomic,strong)UITextField * validateField;//验证码输入框
@property (nonatomic,strong)UIButton * vaButtonS;//发送验证码按钮

@property (nonatomic,strong)UIButton * loginBtn;//登录或注册按钮

@property (nonatomic,strong)UIButton * protocolBtn;//用户协议
@property (nonatomic,strong)UIButton * fogetBtn;//忘记密码

@property (nonatomic,strong)UIButton * registBtn;//尚未注册，点击注册按钮

/**
 *login页面初始化
 *frame:frame
 *type:类型，3注册，2重置密码，其他，登录
 */
- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

@end
