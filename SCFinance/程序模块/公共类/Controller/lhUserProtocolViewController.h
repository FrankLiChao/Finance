//
//  lhUserProtocolViewController.h
//  GasStation
//
//  Created by liuhuan on 15/11/9.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface lhUserProtocolViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,assign)NSString * titleStr;//标题
@property (nonatomic,strong)NSString * urlStr;//url链接

@property (nonatomic,strong)NSString * htmlStr;//html字符串


@property (nonatomic,assign)NSInteger type;//type=5,表示程序启动点击开场图进入，此时点击返回需初始化界面

@end
