//
//  Header.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#ifndef Header_h
#define Header_h

#pragma mark - 正式
//#define webUrl @"http://api.gou-you.com:81/action/"
//#define webImgUrl @"http://api.gou-you.com:81"

#define changeTestAndProFile @"changeTestAndProFile"

#pragma mark - 测试
//#define webUrl @"http://192.168.88.252:81/action/"
//#define webImgUrl @"http://192.168.88.252:81"
//#pragma mark - 正式
//#define [lhUtilObject shareUtil].webUrl @"http://api.gou-you.com:81/action/"
//#define [lhUtilObject shareUtil].webImgUrl @"http://api.gou-you.com:81"
//
//#pragma mark - 测试
//#define [lhUtilObject shareUtil].webUrl @"http://192.168.88.252:81/action/"
//#define [lhUtilObject shareUtil].webImgUrl @"http://192.168.88.252:81"

//接口路径全拼
#define PATH(_path) [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webUrl,_path]
#define PATHImg(_path) [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,_path]

#define ourServicePhone @"400-005-8905"

#define OurRequestSignStr @"a393b3b7f968175d9de63c18a4716e4d" //请求后台固定签名串

#define TheOneDeviceToken @"apple_NO"/*<未打开通知的token*/

//#define DefaultCoordnate CLLocationCoordinate2DMake(30.6573361400,104.0657531337) //地图默认定位点

//tag值1000以下用于已知数目控件设置tag值，1000以上用于设置未知数目控件的tag值
#define activityTag 199
#define activityImgTag 198
#define nullLabelTag 299
#define noConnectNetViewTag 899 //未连接网络提示
#define backBtnTag 991
#define navigationBarTitleTag 990
#define shopDetailFooterTag 28763

#define placeHolderImg @"defaultBgClear" //图片加载失败默认图片
#define defaultHeadUser @"defaultUserHeadImageGray" //登录成功用户默认头像

#pragma mark - 图片初始化
//初始化图片
#define imageWithName(name) [UIImage imageNamed:name]

//方便调试，可以打印对应的调试方法和行号
#ifdef DEBUG
#   define FLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);

#else
#   define FLLog(...)
#endif

//显示提示消息
#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];

//IOS判断
#define IOS6 ([[UIDevice currentDevice].systemVersion intValue] > 5 ? YES : NO)
#define IOS7 ([[UIDevice currentDevice].systemVersion intValue] >= 7 ? YES : NO)
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)
#define IOS9 ([[UIDevice currentDevice].systemVersion intValue] >= 9 ? YES : NO)

//设备判断
#define iPhone4 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone5 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone6 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//字体
//SanFrancisco
#define nowFontName nil

#define lhdisableButtonColorStr [UIColor colorFromHexRGB:@"fccd88"]//不可点击按钮标题颜色
#define lhcontentTitleColorStr [UIColor colorFromHexRGB:@"081c26"] //正文颜色最深
#define lhcontentTitleColorStr2 [UIColor colorFromHexRGB:@"979797"] //正文颜色浅色
#define lhcontentTitleColorStr1 [UIColor colorFromHexRGB:@"656e70"] //正文颜色较深
#define tableDefSepLineColor [UIColor colorFromHexRGB:@"e2e1e1"]//表格线条颜色
#define lhlineColor [UIColor colorFromHexRGB:@"ff9e05"] //按钮橙色
#define lhmainColor [UIColor colorFromHexRGB:@"1da1f2"] //APP主色蓝色
#define lhmainColorBlack [UIColor colorFromHexRGB:@"272727"] //APP导航栏黑色
#define lhviewColor [UIColor colorFromHexRGB:@"edeeef"] //背景色 浅灰色
#define lhredColorStr [UIColor colorFromHexRGB:@"f96268"] //红色

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/375

#define runCount @"SCFinanceRunCountFile"//是否第一次运行
#define mainAdsInfoFile @"mainAdsInfoFile"//开场广告存储
#define lastCityInfoFile @"lastCityInfoFile"//存储上一次选中的城市信息
#define mainViewlunboPicFile @"mainViewlunboPicFile"//主页轮播图片
#define saveLocalTokenFile @"saveLocalTokenFile"//token本地存储
#define saveLoginInfoFile @"saveLoginInfoFile"//登录信息本地存储
#define autoLoginTimeFile @"autoLoginTimeFile"//自动登录时间本地存储
#define saveCommentLocalVersion @"saveCommentLocalVersionFile"//存储本地评论版本号
#define saveInformationToFile @"saveInformationToFile" //本地化资讯数据，数据类型是字典
#define saveTitleInformationToFile @"saveTitleInformationToFile" //本地化资讯标题数据，数据类型是数组
#define saveLunboInformationToFile @"saveLunboInformationToFile" //本地化资讯轮播数据，数据类型是字典
#define saveAllMessageFile @"saveAllMessageCountFile" //本地总消息条数


//微信注册的APPID ()
#define WeiXinAppID @"wx5df2873d6a1dc20d"

#endif /* Header_h */
