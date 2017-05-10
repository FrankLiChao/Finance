//
//  lhUserModel.m
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhUserModel.h"

static lhUserModel * shareModel;

@implementation lhUserModel


- (instancetype)init
{
    if (shareModel) {
        return shareModel;
    }
    shareModel = [super init];
    return shareModel;
}

+ (instancetype)shareUserModel
{
    if (shareModel) {
        return shareModel;
    }
    shareModel = [[lhUserModel alloc]init];
    return shareModel;
}

//- (void)setValue:(id)value forKey:(NSString *)key
//{
//    if ([@"id" isEqualToString:key]) {
//        [self setValue:value forKey:@"tempId"];
//    }
//}
//

//- (id)valueForUndefinedKey:(NSString *)key
//{
//    return self;
//}

@end
