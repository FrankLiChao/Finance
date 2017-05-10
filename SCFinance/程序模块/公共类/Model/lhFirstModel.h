//
//  lhFirstModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/20.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求结果第一层model
@interface lhFirstModel : NSObject

@property (nonatomic,assign)NSInteger status;//状态码
@property (nonatomic,strong)NSString * msg;//消息

@end
