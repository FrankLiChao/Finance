//
//  lhUtilObject.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLocationManager.h"

typedef void (^LocationCityBlock)(NSString * city);//获取定位城市Block

@interface lhUtilObject : NSObject

@property (nonatomic,assign)BOOL noShowKaiChang;//是否显示开场图片
@property (nonatomic,assign)BOOL isFirstRunApp;//第一次运行APP
@property (nonatomic,strong)NSDictionary * mainAdsDic;//开场广告数据
@property (nonatomic,assign)BOOL isOnLine;//已登录，在线
@property (nonatomic,strong)NSString * realToken;//当前token
//@property (nonatomic,strong)NSDictionary *userInfor;//登录信息
@property (nonatomic,strong)NSTimer * teamBuyTimer;//团购列表倒计时
@property (nonatomic,strong)NSArray * allCityArray;//所有城市列表
@property (nonatomic,strong)NSDictionary * nowCityDic;//当前城市数据
@property (nonatomic,strong)NSDictionary * versionDic;//版本数据
@property (nonatomic,strong)NSArray * remainOilArray;//余油信息
@property (nonatomic,assign)BOOL isRefreshShopCar;//是否刷新购物车

@property (nonatomic,strong)NSString * webUrl;//所有城市列表
@property (nonatomic,strong)NSString * webImgUrl;//所有城市列表

+ (instancetype)shareUtil;//单例

#pragma mark - 网络请求提示
+ (void)wangluoAlertShow;
+ (void)requestFailAlertShow:(NSNotification *)noti;

#pragma mark - 缓存图片
+ (float)cacheLength;
//获取图片名字
- (void)saveImagesOther:(UIImage *)tempImg withName:(NSString *)name;
- (UIImage *)readImageWithNameOther:(NSString *)name;
- (NSString *)imageStr:(NSString *)iStr;
+ (void)checkImageWithImageView:(UIImageView *)tempImg withImage:(NSString *)tempImgName withImageUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage;
+ (void)checkImageWithName:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView;
+ (void)checkImageNoPlaceImage:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView;

- (void)removeAllImage;
- (BOOL)isImageWithName:(NSString *)name;
//- (void)saveImages:(UIImage *)tempImg withName:(NSString *)name;
//- (UIImage *)readImageWithName:(NSString *)name;
//- (void)removeImageFile:(NSString *)name;
//
//- (void)saveLunBoImg:(UIImage *)img withI:(int)i;
//- (UIImage *)readImageWithNameLunBo:(NSString *)name;
//- (void)removeLunBo;

#pragma mark-方法替换
/**
 *sizeWithFont替换
 */
+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font;

/**
 *sizeWithFont: constrainedToSize: lineBreakMode: 替换
 */
+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)mSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *drawAtPoint:
 forWidth:
 withFont:
 fontSize:
 lineBreakMode:
 baselineAdjustment:替换
 */
+ (void)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font rect:(CGRect)rect forWidth:(CGFloat)forWidth fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;

/**
 *drawInRect:(CGRect)rect withFont:替换
 */
+ (void)drawInRectWhenIOS7:(NSString *)text rect:(CGRect)rect font:(UIFont *)font;

/**
 *请求加密
 *dic:请求键值对
 */
+ (NSString *)signStrOur:(NSDictionary *)dic;

/**
 * 显示一个提示
 *message:提示消息
 *superView:添加父类
 *heih:y坐标
 */
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih;

/**
 *添加为空展示
 *superView：添加到的view
 *str:为空描述
 */
+ (void)addANullLabelWithSuperView:(UIView *)superView withText:(NSString *)str;

/**
 * 移除为空展示
 *superView:添加到的view
 */
+ (void)removeNullLabelWithSuperView:(UIView *)superView;

/**
 * 检测是否登录
 */
+ (BOOL)loginIsOrNot;

/**
 * 判断是否开启了定位
 */
+ (BOOL)isOpenLocarion;
+ (BOOL)isOpenLocarionNoNotice;
#pragma mark - 获取当前城市
- (void)locationCity:(LocationCityBlock)locationCity error:(LocationErrorBlock)errorB;

/**
 *分享
 */
+ (void)fxViewAppear:(id)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withVc:(UIViewController *)fxVc;
- (void)fxBtnEventOther:(UIButton *)button_ image:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr;

/**
 *拨打电话
 */
+ (void)detailPhone:(NSString *)phone;

@end
