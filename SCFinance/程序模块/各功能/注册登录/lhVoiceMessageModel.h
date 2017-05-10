//
//  lhVoiceMessageModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/20.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//验证码model
@interface lhVoiceMessageModel : NSObject

@property (nonatomic,strong)NSString * phone;//电话号码
@property (nonatomic,strong)NSString * vercode;//验证码

@property (nonatomic,strong)NSString * userId;//用户ID,找回密码发送验证码时返回

@end
