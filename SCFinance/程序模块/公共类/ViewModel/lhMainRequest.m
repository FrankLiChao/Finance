//
//  lhMainRequest.m
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhMainRequest.h"
#import "AFNetworkReachabilityManager.h"
#import "lhFirstModel.h"
#import "LHJsonModel.h"
#import "lhTabBar.h"

#define TIME_OUT_INTERVAL 20

@interface lhMainRequest()
{

    NSString * nowName;
}

//@property (nonatomic,strong)NSMutableDictionary * mutableDic;

@end

@implementation lhMainRequest

+ (void)checkNetworkStatus:(UIViewController *)mVC
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"网络状态：%ld,未连接网络时，在keyWind上加一个提示", (long)status);
        if (status == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView * noConnectAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, 44)];
                noConnectAlert.tag = noConnectNetViewTag;
                noConnectAlert.backgroundColor = lhredColorStr;
                [mVC.view addSubview:noConnectAlert];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIView * noConnectAlert = [mVC.view viewWithTag:noConnectNetViewTag];
                [noConnectAlert removeFromSuperview];
                noConnectAlert = nil;
            });
        }
    }];
    
}

#pragma mark - 请求
+ (void)HTTPPOSTNormalRequestForURL:(NSString *)urlString parameters:(NSDictionary *)parameter method:(NSString *)method success:(void (^)(id))success fail:(void (^)(id error))fail
{
    [lhUtilObject shareUtil].noShowKaiChang = YES;

    //拼接URL
//    urlString = [[lhUtilObject shareUtil].webUrl stringByAppendingFormat:@"%@",urlString];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    urlString = [NSString stringWithFormat:@"%@",urlString];
    
//    NSLog(@"请求链接  ---- %@",urlString);

    if ([@"GET" isEqualToString:method]) {
        return;
    }
    else{
        [parameters setObject:OurRequestSignStr forKey:@"sig"];
        [parameters setObject:[lhUtilObject signStrOur:parameters] forKey:@"auth"];
        [parameters removeObjectForKey:@"sig"];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT_INTERVAL];
    NSString *HTTPBodyString = [self HTTPBodyWithParameters:parameters];
    NSLog(@"qingqiuti  %@====== %@",parameters,urlString);
    [URLRequest setHTTPBody:[HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [URLRequest setHTTPMethod:method];
    
    NSURLSession * session = [NSURLSession sharedSession];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [lhUtilObject shareUtil].noShowKaiChang = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        });
        if (!error) {
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            FLLog(@"dataDic = %@",dataDic);
            if (dataDic) {//请求数据正常
                //判断并去掉最外层数据
                lhFirstModel * fModel = [LHJsonModel modelWithDict:dataDic className:@"lhFirstModel"];
                if (fModel.status == 1) {
                    id responseData = [dataDic objectForKey:@"data"];
                    if (!responseData) {
                        responseData = dataDic;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(responseData);
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [lhHubLoading disAppearActivitiView];
                        if(fail){
                            fail(fModel.msg);
                        }
                        else{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:fModel.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                    });
                }
            }
            else{//请求数据为空，服务器返回异常
                dispatch_async(dispatch_get_main_queue(), ^{
                    [lhHubLoading disAppearActivitiView];
                    
                    if (fail) {
                        fail(@"-111");
                    }
                    else{
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                });
            }
        }
        else{//未连接网络或其他原因，请求报错
            dispatch_async(dispatch_get_main_queue(), ^{
                [lhHubLoading disAppearActivitiView];
                if (fail) {
                    fail(@"-111");
                }
                else{
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请求失败" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            });
        }
        
    }];
    [task resume];
    
}

//上传多张图片
+ (void)uploadPhotos:(NSString *)urlString parameters:(NSDictionary *)parameter imageD:(NSArray *)imgArray success:(void (^)(id))success
{
    [lhUtilObject shareUtil].noShowKaiChang = YES;

//    NSString * url = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,urlString];
    NSString * url = [NSString stringWithFormat:@"%@",urlString];
    //    NSLog(@"上传 %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT_INTERVAL];
    //    UIImage * imageToPost = imageWithName(@"beauty.jpg");
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    for (NSString *param in parameters) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    for (int i=0;i<imgArray.count;i++){
        UIImage * img = [imgArray objectAtIndex:i];
        NSData * imageData = UIImageJPEGRepresentation(img, 0.5);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"\r\n",@"image",[NSString stringWithFormat:@"image%d.png",i+1]];
        
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream\r\n\r\n"]];
        
        [body appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    NSURLSession * session = [NSURLSession sharedSession];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSessionUploadTask * task = [session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [lhUtilObject shareUtil].noShowKaiChang = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        });
        
        if (!error) {
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            FLLog(@"imageData = %@",dataDic);
            if (dataDic) {//请求数据正常
                //判断并去掉最外层数据
                lhFirstModel * fModel = [LHJsonModel modelWithDict:dataDic className:@"lhFirstModel"];
                if (fModel.status == 1) {
                    NSDictionary * dataDict = [dataDic objectForKey:@"data"];
                    if (!dataDict) {
                        dataDict = dataDic;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(dataDict);
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [lhHubLoading disAppearActivitiView];
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:fModel.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
                
            }
            else{//请求数据为空，服务器返回异常
                dispatch_async(dispatch_get_main_queue(), ^{
                    [lhHubLoading disAppearActivitiView];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }
        else{//未连接网络或其他原因，请求报错
            dispatch_async(dispatch_get_main_queue(), ^{
                [lhHubLoading disAppearActivitiView];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    }];
    [task resume];
}

//下载文件
+ (void)downloadFile:(NSString *)urlStr success:(void (^)(id responseObject))success
{
    [lhUtilObject shareUtil].noShowKaiChang = YES;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    NSURL * downloadStr = [NSURL URLWithString:urlStr];

    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:downloadStr completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        [lhUtilObject shareUtil].noShowKaiChang = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        if (!error) {
            if (location) {//请求数据正常
                if (success) {
                    success(location);
                }
            }
            else{//请求数据为空，服务器返回异常
                dispatch_async(dispatch_get_main_queue(), ^{
                    [lhHubLoading disAppearActivitiView];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }
        else{//未连接网络或其他原因，请求报错
            dispatch_async(dispatch_get_main_queue(), ^{
                [lhHubLoading disAppearActivitiView];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    }];
    [task resume];
}

//获取Documents文件夹的路径
+ (NSString *)getDocumentsPath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = documents[0];
    
    return documentsPath;
}

//生成请求body
+ (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
//        if ([value isKindOfClass:[NSString class]]) {
            NSString * tempStr = [[NSString stringWithFormat:@"%@=%@",key,value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
            [parametersArray addObject:tempStr];
//        }
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

//判断错误字符串并处理
+ (void)checkRequestFail:(NSString *)errorStr
{
    if([@"-111" isEqualToString:errorStr]){
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

@end