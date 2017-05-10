//
//  lhLoginView.m
//  SCFinance
//
//  Created by bosheng on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhLoginView.h"

static NSString * placeholderColor = @"c0dbeb";

@implementation lhLoginView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if(!type){//登录
            UIImageView * bgImgView = [[UIImageView alloc]initWithFrame:frame];//登录背景图片
            bgImgView.image = imageWithName(@"loginBackgroundImage");
            [self addSubview:bgImgView];
            
            //再覆盖一个透明层
            UIView * alphaView = [[UIView alloc]initWithFrame:frame];
            alphaView.backgroundColor = lhmainColorBlack;
            alphaView.alpha = 0.7;
            [self addSubview:alphaView];
        }
        
        [self firmInit:type];
    }
    
    return self;
}

- (void)firmInit:(NSInteger)type
{
    CGFloat heih = 64;
    
    if (!type) {
        if (iPhone5 || iPhone6 || iPhone6plus) {
            heih += 40*widthRate;
        }
        else{
            heih += 30*widthRate;
        }
        //icon显示
        UIImageView * iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceMaxWidth-70*widthRate)/2, heih, 70*widthRate, 70*widthRate)];
        iconImgView.image = imageWithName(@"iconImage");
        [self addSubview:iconImgView];
        
        heih += 121*widthRate;
    }
    else{
        if (iPhone5 || iPhone6 || iPhone6plus) {
            heih += 46*widthRate;
        }
        else{
            heih += 35*widthRate;
        }
    }
    
    NSString * placeStr = @"请输入您的手机号";//placeholder
    NSMutableAttributedString * placeHolder = [[NSMutableAttributedString alloc]initWithString:placeStr];
    [placeHolder addAttribute:NSForegroundColorAttributeName value:(!type?[UIColor colorFromHexRGB:placeholderColor]:lhcontentTitleColorStr2) range:NSMakeRange(0, placeStr.length)];
    _tellField = [[UITextField alloc]initWithFrame:CGRectMake(!type?35*widthRate:32.5*widthRate, heih, DeviceMaxWidth-(!type?70*widthRate:65*widthRate), 40*widthRate)];
    _tellField.keyboardType = UIKeyboardTypeNumberPad;
    _tellField.textColor = !type?[UIColor whiteColor]:lhcontentTitleColorStr;
    if (!type) {
        _tellField.attributedPlaceholder = placeHolder;
        _tellField.tintColor = [UIColor whiteColor];
    }
    else{
        _tellField.placeholder = placeStr;
    }
    _tellField.font = [UIFont systemFontOfSize:14];
    [self addSubview:_tellField];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(35*widthRate, heih+39*widthRate, DeviceMaxWidth-70*widthRate, !type?1:0.5)];
    lineView.backgroundColor = !type?[UIColor colorFromHexRGB:placeholderColor]:tableDefSepLineColor;
    [self addSubview:lineView];
    
    heih += 49*widthRate;
    
    if (!type) {
        NSString * placeStrP = @"请输入密码";//placeholder
        NSMutableAttributedString * placeHolderP = [[NSMutableAttributedString alloc]initWithString:placeStrP];
        [placeHolderP addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:placeholderColor] range:NSMakeRange(0, placeStrP.length)];
        _passField = [[UITextField alloc]initWithFrame:CGRectMake(35*widthRate, heih, DeviceMaxWidth-70*widthRate, 40*widthRate)];
        _passField.secureTextEntry = YES;
        _passField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passField.textColor = [UIColor whiteColor];
        _passField.attributedPlaceholder = placeHolderP;
        _passField.tintColor = [UIColor whiteColor];
        _passField.font = [UIFont systemFontOfSize:14];
        [self addSubview:_passField];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35*widthRate, heih+39*widthRate, DeviceMaxWidth-70*widthRate, !type?1:0.5)];
        lineView1.backgroundColor = [UIColor colorFromHexRGB:placeholderColor];
        [self addSubview:lineView1];
        
        heih += 39*widthRate;
    }
    
    if (type == 3 || type == 2) {//注册或找回密码需要输入验证码
        _validateField = [[UITextField alloc]initWithFrame:CGRectMake(32.5*widthRate, heih, 180*widthRate, 52*widthRate)];
        _validateField.keyboardType = UIKeyboardTypeNumberPad;
        _validateField.textColor = lhcontentTitleColorStr;
        _validateField.placeholder = @"请输入验证码";
        _validateField.font = [UIFont systemFontOfSize:14];
        [self addSubview:_validateField];

        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(32.5*widthRate, heih+45*widthRate, DeviceMaxWidth-65*widthRate, 0.5)];
        lineView2.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineView2];
        
        UIView * lineViewV = [[UIView alloc]initWithFrame:CGRectMake(DeviceMaxWidth-157.5*widthRate-0.5, heih+16*widthRate, 0.5, 20*widthRate)];
        lineViewV.backgroundColor = lhlineColor;
        [self addSubview:lineViewV];
        
        _vaButtonS = [UIButton buttonWithType:UIButtonTypeCustom];
        _vaButtonS.frame = CGRectMake(DeviceMaxWidth-157.5*widthRate, heih+11*widthRate, 125*widthRate, 30*widthRate);
        [_vaButtonS setTitleColor:lhlineColor forState:UIControlStateNormal];
        [_vaButtonS setTitleColor:lhcontentTitleColorStr2 forState:UIControlStateSelected];
        [_vaButtonS setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_vaButtonS setTitle:@"已发送(60)" forState:UIControlStateSelected];
        _vaButtonS.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_vaButtonS];
        
        heih += 52*widthRate;
        
        if (type == 3) {//注册加上密码输入
            
            _passField = [[UITextField alloc]initWithFrame:CGRectMake(32.5*widthRate, heih, DeviceMaxWidth-65*widthRate, 52*widthRate)];
            _passField.secureTextEntry = YES;
            _passField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _passField.textColor = lhcontentTitleColorStr;
            _passField.placeholder = @"请设置登录密码";
            _passField.font = [UIFont systemFontOfSize:14];
            [self addSubview:_passField];
            
            UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(32.5*widthRate, heih+45*widthRate, DeviceMaxWidth-65*widthRate, !type?1:0.5)];
            lineView1.backgroundColor = tableDefSepLineColor;
            [self addSubview:lineView1];
            
            UIButton * secureBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-57.5*widthRate, heih+11*widthRate, 27.5*widthRate, 30*widthRate)];
            [secureBtn setImage:imageWithName(@"secureButtonImage_N") forState:UIControlStateNormal];
            [secureBtn setImage:imageWithName(@"secureButtonImage_S") forState:UIControlStateSelected];
            [secureBtn addTarget:self action:@selector(secureBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:secureBtn];
            
            heih += 52*widthRate;
        }
    }
    
    if (!type) {
        heih += 51*widthRate;
    }
    else{
        heih += 40*widthRate;
    }

    NSString * firmBtnStr = @"登录";
    if (type == 3) {
        firmBtnStr = @"注册";
    }
    else if(type == 2){
        firmBtnStr = @"下一步";
    }
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.allowsEdgeAntialiasing = YES;
    _loginBtn.frame = CGRectMake(!type?35*widthRate:32.5*widthRate, heih, DeviceMaxWidth-(!type?70*widthRate:65*widthRate), 40*widthRate);
    _loginBtn.backgroundColor = lhmainColor;
    [_loginBtn setTitle:firmBtnStr forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_loginBtn setTitleColor:[UIColor colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
    [self addSubview:_loginBtn];
    
    heih += !type?55*widthRate:48*widthRate;
    
    _fogetBtn = [[UIButton alloc] initWithFrame:CGRectMake(35*widthRate, heih, DeviceMaxWidth-70*widthRate, 30)];
    [_fogetBtn setTitleColor:[UIColor colorFromHexRGB:placeholderColor] forState:UIControlStateNormal];
    _fogetBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
    if (!type) {
        [_fogetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    }
    else{
        [_fogetBtn setTitle:@"收不到验证码？" forState:UIControlStateNormal];
        
        [_fogetBtn setTitleColor:lhmainColor forState:UIControlStateNormal];
        _fogetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _fogetBtn.frame = CGRectMake(DeviceMaxWidth-132.5*widthRate, heih, 100*widthRate, 30);
    }
    [self addSubview:_fogetBtn];
    
    if (type == 3 || !type) {//注册和登录
        if (type == 3) {//注册
            NSString * tStr = @"注册即表示您同意《优品购油宝用户协议》";
            NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:tStr];
            [as addAttribute:NSForegroundColorAttributeName value:lhcontentTitleColorStr2 range:NSMakeRange(0, tStr.length)];
            [as addAttribute:NSForegroundColorAttributeName value:lhmainColor range:NSMakeRange(8, tStr.length-8)];
            
            _protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(32.5*widthRate, heih, 210*widthRate, 30)];
            _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            _protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_protocolBtn setAttributedTitle:as forState:UIControlStateNormal];
            _protocolBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_protocolBtn];
        }
        
        NSString * tStr = (type==3?@"已经有账号？现在去登录":@"还没有账号？现在去免费注册");
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:tStr];
        [as addAttribute:NSForegroundColorAttributeName value:(!type?[UIColor colorFromHexRGB:placeholderColor]:lhcontentTitleColorStr2) range:NSMakeRange(0, tStr.length)];
        [as addAttribute:NSForegroundColorAttributeName value:(!type?[UIColor colorFromHexRGB:@"ffffff"]:lhmainColor) range:NSMakeRange(9, tStr.length-9)];
        
        _registBtn = [[UIButton alloc]initWithFrame:CGRectMake(50*widthRate, DeviceMaxHeight-52*widthRate, DeviceMaxWidth-100*widthRate, 30*widthRate)];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registBtn setAttributedTitle:as forState:UIControlStateNormal];
        [self addSubview:_registBtn];
        
    }
    
    if (type == 2) {
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-25*widthRate, 60*widthRate, 18*widthRate)];
        logo.image = imageWithName(@"refreshLogo");
        [self addSubview:logo];
    }
}

//密文开关按钮事件
- (void)secureBtn:(UIButton *)button_
{
    button_.selected = !button_.selected;
    
    NSString * tempStr = _passField.text;
    _passField.text = @"";
    _passField.secureTextEntry = !_passField.secureTextEntry;
    _passField.text = tempStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
