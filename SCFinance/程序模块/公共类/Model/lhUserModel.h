//
//  lhUserModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhUserModel : NSObject

@property (nonatomic,strong)NSString * cartSize;//购物车数量
@property (nonatomic,strong)NSString * name;//昵称
@property (nonatomic,strong)NSString * userId;//用户id
@property (nonatomic,strong)NSString * phone;//电话
@property (nonatomic,strong)NSString * photo;//头像
@property (nonatomic,strong)NSString * createTime;//注册时间
@property (nonatomic,strong)NSString * certificationStatus;//认证状态
@property (nonatomic,strong)NSString * password;//密码
@property (nonatomic,strong)NSString * updateTime;//最近登录时间
@property (nonatomic,strong)NSString * tokenSwitch;//接收通知开关

@property (nonatomic,strong)NSString * messageNum;//消息条数
@property (nonatomic,strong)NSString * messageTitle;//消息副标题

+ (instancetype)shareUserModel;//单例

@end
