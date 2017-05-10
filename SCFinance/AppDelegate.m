//
//  AppDelegate.m
//  SCFinance
//
//  Created by bosheng on 16/5/16.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import "lhStartViewController.h"
#import "lhMainViewModel.h"
#import "IQKeyboardManager.h"
#import "FrankTools.h"

#import "lhFirstMainView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


-(void)registerSharePlatform
{
    //微信注册
    [ShareSDK connectWeChatWithAppId:WeiXinAppID wechatCls:[WXApi class]];
    
    //QQ注册
    [ShareSDK connectQQWithQZoneAppKey:@"1105054096"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQZoneWithAppKey:@"1105054096"
                           appSecret:@"Rl40PEBsa0rC2jf6"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:changeTestAndProFile]];
    str = @"1";
//    if ([str integerValue] == 0) {
//    NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:changeTestAndProFile]];
//    if ([str integerValue] == 0) {
//    192.168.88.252:81
//    182.92.204.180:83
        [lhUtilObject shareUtil].webUrl = @"http://192.168.88.252:81/action/";
        [lhUtilObject shareUtil].webImgUrl = @"http://192.168.88.252:81";
//    }
//    else{
//        [lhUtilObject shareUtil].webUrl = @"http://api.gou-you.com:81/action/";
//        [lhUtilObject shareUtil].webImgUrl = @"http://api.gou-you.com:81";
//    }
    
    [lhUtilObject shareUtil].realToken = TheOneDeviceToken;//token赋初值
//    [lhUtilObject shareUtil].isEnableCheck = YES;
    
    //ShareSDK的注册
    [ShareSDK registerApp:@"9cd8dfc0b944"];
    //分享对应平台注册
    [self registerSharePlatform];
    
    //初始化键盘处理控制器
    [self initIQKeyBoard];
    
    lhStartViewController * sVC = [lhStartViewController shareStartVC];
    sVC.view.backgroundColor = [UIColor whiteColor];
    sVC.window = self.window;
    
    UINavigationController * nsVC = [[UINavigationController alloc]initWithRootViewController:sVC];
    nsVC.navigationBar.hidden = YES;
    self.window.rootViewController = nsVC;

    [self.window makeKeyAndVisible];
    
    //注册通知，alert,sound,badge
    if (IOS8)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    return YES;
}

#pragma mark - 远程通知
//消息推送
//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =
    [[[[deviceToken description]
       stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token=%@",token);
    if (!token || [token isEqualToString:@""])
    {
        
    }
    else
    {
        [lhUtilObject shareUtil].realToken = [NSString stringWithFormat:@"%@",token];
        
        NSString * localStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile]];
        if (![[lhUtilObject shareUtil].realToken isEqualToString:localStr]) {
            [lhMainViewModel updateToken];
        }
    }
}

//注册消息推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString * error_str = [NSString stringWithFormat:@"%@",error];
    NSLog(@"%@",error_str);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber += 1;
    
//    NSLog(@"aa==%@",userInfo);
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    
}

-(void)initIQKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    manager.enable = YES; // 控制整个功能是否启用。
    manager.enableAutoToolbar = NO;
}

//检查是否已加入handleOpenURL的处理方法
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;
    [lhUtilObject shareUtil].isFirstRunApp = NO;
    
//    lhFirstMainView * mView = [lhFirstMainView gOnlyMainView];
//    if (mView) {
//        mView.skipButton.alpha = 0;
//        mView.skipButton.userInteractionEnabled = NO;
//        mView.desImgView.alpha = 0;
//        mView.desImgView.userInteractionEnabled = NO;
//        
//        [NSObject cancelPreviousPerformRequestsWithTarget:mView selector:@selector(skipButtonEvent) object:nil];//取消延时操作
//    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    UINavigationController * rootVC = (UINavigationController *)self.window.rootViewController;
    [[lhFirstMainView shareMainView] checkAndShow:NO superView:rootVC];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
