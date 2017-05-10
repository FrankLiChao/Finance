//
//  lhMainRequest.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhMainRequest : NSObject

/**检测网路状态**/
+ (void)checkNetworkStatus:(UIViewController *)mVC;

/**
 *JSON方式获取数据
 *urlString:获取数据的url地址
 *parameters:提交的参数内容
 *method:请求方式
 */
+ (void)HTTPPOSTNormalRequestForURL:(NSString *)urlString parameters:(NSDictionary *)parameter method:(NSString *)method success:(void (^)(id responseObject))success fail:(void (^)(id error))fail;

/**
 *上传图片
 *urlString:上传图片的url地址
 *parameters:提交的参数内容
 *imgArray:UIImage组成的array
 */
+ (void)uploadPhotos:(NSString *)urlString parameters:(NSDictionary *)parameters imageD:(NSArray *)imgArray success:(void (^)(id responseObject))success;

/**
 *下载文件
 *urlStr:现在文件地址
 */
+ (void)downloadFile:(NSString *)urlStr success:(void (^)(id responseObject))success;


/**
 *请求失败判断并处理
 *errorStr:返回的错误字符串
 */
+ (void)checkRequestFail:(NSString *)errorStr;

@end
