//
//  FrankDetailsView.h
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface FrankDetailsView : UIViewController<NJKWebViewProgressDelegate>

@property (nonatomic,strong)NSString *articleId;    //新闻ID
@property (nonatomic,strong)NSString *myWebUrl;//详情url
@property (nonatomic,strong)NSString *titleStr;//title
@property (nonatomic,assign)NSInteger isCollected;  //表示是否收藏，1表示收藏，-1表示未收藏
@property (nonatomic,strong)NSString * imageStr;//图片链接

@property (nonatomic,assign)NSInteger type; //type=5表示资讯详情页面

@end
