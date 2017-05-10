//
//  lhUtilObject.m
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhUtilObject.h"
#import "UIImageView+WebCache.h"
#import "MyMD5.h"
#import "lhLoginViewController.h"
#import "lhTabBar.h"
#import "lhSymbolCustumButton.h"
#import <CoreLocation/CoreLocation.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <LocalAuthentication/LocalAuthentication.h>

//#define paths [NSString stringWithFormat:@"%@/SCFinance",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

//#define pathsLunBo [NSString stringWithFormat:@"%@/SCFinance/LunBo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define pathsOther [NSString stringWithFormat:@"%@/SCFinanceOther",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define fxBgViewTag 339
#define fxLowViewTag 340

static lhUtilObject * onlyUtil;//单例
static UILabel * tempLabel;//alert提示label

//分享图片和描述
static NSString * fxConStr;
static id fxImg;
static NSString * fxUrlStr;

UIViewController *tempFxVc;   //缓存分享页面传过来的Vc
UIWebView * phoneCallWebView;//拨打电话View

@implementation lhUtilObject

+ (instancetype)shareUtil
{
    if (onlyUtil) {
        return onlyUtil;
    }
    onlyUtil = [[lhUtilObject alloc]init];
    return onlyUtil;
}


#pragma mark - 请求失败提示
+ (void)wangluoAlertShow
{
//    if (IOS8) {
//        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"连接异常" message:@"请检查网络或稍后重试！" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            
//        }];
//        [alertC addAction:cancelAction];
//        
//        [tempVC presentViewController:alertC animated:YES completion:^{
//            
//        }];
//    }
//    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
//    }
    
}

+ (void)requestFailAlertShow:(NSNotification *)noti
{
    NSString * str = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"msg"]];
    
    if (str && [str rangeOfString:@"null"].length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 检测，存储图片
//获取图片名字
- (NSString *)imageStr:(NSString *)iStr
{
    NSRange ra = [iStr rangeOfString:@"-" options:NSLiteralSearch];
    
    if (ra.length > 0) {
        iStr = [iStr substringFromIndex:ra.location+1];
    }
    
    return iStr;
}

+ (float)cacheLength
{
    return [self folderSizeAtPath:pathsOther];
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float )folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1000.0*1000.0);
}

+ (void)checkImageWithImageView:(UIImageView *)tempImg withImage:(NSString *)tempImgName withImageUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage
{
    tempImgName = [tempImgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([tempImgName rangeOfString:@"null"].length || [@"" isEqualToString:tempImgName]) {
        tempImg.image = placeholderImage;
        return;
    }
    
    if ([[lhUtilObject shareUtil]isImageWithName:tempImgName]) {//图片存在
        //        NSLog(@"存在");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [[lhUtilObject shareUtil] readImageWithNameOther:tempImgName];
            dispatch_async(dispatch_get_main_queue(), ^{
                tempImg.image = img;
            });
        });
    }
    else{
        [tempImg setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[lhUtilObject shareUtil]saveImagesOther:image withName:tempImgName];
                });
            }
        }];
    }
}

#pragma mark - 可清空图片，存储.读取.删除图片
- (void)removeAllImage
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathsOther]) {
        
        [fileManager removeItemAtPath:pathsOther error:nil];
    }
}

//判断图片是否存在
- (BOOL)isImageWithName:(NSString *)name
{
    if(!name || [@"" isEqualToString:name]){
        return NO;
    }
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    
    if (![fileManager fileExistsAtPath:pathStr]) {
        return NO;
    }
    
    return YES;
}

- (void)saveImagesOther:(UIImage *)tempImg withName:(NSString *)name
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathsOther]) {
        ////NSLog(@"该文件不存在");
        [fileManager createDirectoryAtPath:pathsOther withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
    }
    
    NSData * imgData;
    imgData = UIImageJPEGRepresentation(tempImg, 0.8);
    
    if(!name || [@"" isEqualToString:name]){
        return;
    }
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
    
}

- (UIImage *)readImageWithNameOther:(NSString *)name
{
    if(!name || [@"" isEqualToString:name]){
        return [[UIImage alloc]init];
    }
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
    UIImage * tempImg = [UIImage imageWithData:readData scale:1];
    
    return tempImg;
}

+ (void)checkImageNoPlaceImage:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView
{
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[lhUtilObject shareUtil]isImageWithName:name]) {//图片存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [[lhUtilObject shareUtil] readImageWithNameOther:name];
            dispatch_async(dispatch_get_main_queue(), ^{
                tempImgView.image = img;
            });
        });
    }
    else{
        [tempImgView setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[lhUtilObject shareUtil]saveImagesOther:image withName:name];
                });
            }
        }];
    }
}

+ (void)checkImageWithName:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView
{
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[lhUtilObject shareUtil]isImageWithName:name]) {//图片存在
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [[lhUtilObject shareUtil] readImageWithNameOther:name];
            dispatch_async(dispatch_get_main_queue(), ^{
                tempImgView.image = img;
            });
        });
    }
    else{
        [tempImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:imageWithName(placeHolderImg) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[lhUtilObject shareUtil]saveImagesOther:image withName:name];
                });
                
            }
        }];
    }
}

#pragma mark - 不可清空图片存储及处理
//- (void)saveImages:(UIImage *)tempImg withName:(NSString *)name
//{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:paths]) {
//        ////NSLog(@"该文件不存在");
//        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
//    }
//    
//    NSData * imgData;
//    imgData = UIImageJPEGRepresentation(tempImg, 0.5);
//    
//    NSString * pathStr = [NSString stringWithFormat:@"%@/%@.png",paths,name];
//    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
//    
//}
//
//- (UIImage *)readImageWithName:(NSString *)name
//{
//    
//    NSString * pathStr = [NSString stringWithFormat:@"%@/%@.png",paths,name];
//    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
//    UIImage * tempImg = [UIImage imageWithData:readData scale:2.0];
//    
//    return tempImg;
//}
//
//- (void)removeImageFile:(NSString *)name
//{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    NSString * pathStr = [NSString stringWithFormat:@"%@/%@.png",paths,name];
//    if ([fileManager fileExistsAtPath:pathStr]) {
//        [fileManager removeItemAtPath:pathStr error:nil];
//    }
//}
//
////轮播
////存储轮播图片
//- (void)saveLunBoImg:(UIImage *)img withI:(int)i
//{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:paths]) {
//        
//        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
//    }
//    
//    if (![fileManager fileExistsAtPath:pathsLunBo]) {
//        [fileManager createDirectoryAtPath:pathsLunBo withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
//    }
//    
//    NSData * imgData = UIImageJPEGRepresentation(img, 0.5);
//    NSString * pathStr = [NSString stringWithFormat:@"%@/%d.png",pathsLunBo,i];
//    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
//    
//}
//
//- (UIImage *)readImageWithNameLunBo:(NSString *)name
//{
//    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsLunBo,name];
//    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
//    UIImage * tempImg = [UIImage imageWithData:readData scale:2.0];
//    
//    return tempImg;
//}
//
//- (void)removeLunBo
//{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:pathsLunBo]) {
//        [fileManager removeItemAtPath:pathsLunBo error:nil];
//    }
//}

+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize titleSize = [text sizeWithAttributes:attribute];
    
    return titleSize;
}


+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)mSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    CGSize detailsLabelSize = [text boundingRectWithSize:mSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return detailsLabelSize;
}

+ (void)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font rect:(CGRect)rect forWidth:(CGFloat)forWidth fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    UIFont * tempFont = font;
    tempFont = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSFontAttributeName: tempFont, NSParagraphStyleAttributeName: paragraphStyle,NSBaselineOffsetAttributeName:[NSNumber numberWithFloat:1.0]};
    [text drawInRect:rect withAttributes:attributes];
}

+ (void)drawInRectWhenIOS7:(NSString *)text rect:(CGRect)rect font:(UIFont *)font
{
    
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    
}

//请求数据签名
+ (NSString *)signStrOur:(NSDictionary *)dic
{
    NSMutableArray * keyArray = [NSMutableArray arrayWithArray:[dic allKeys]];
    [keyArray sortUsingSelector:@selector(compare:)];
    NSMutableString * keyStr = [NSMutableString string];
    for (int i=0;i<keyArray.count;i++){
        NSString * s = [keyArray objectAtIndex:i];
        [keyStr appendFormat:@"%@=%@",s,[dic objectForKey:s]];
        
        if (i < keyArray.count-1) {
            [keyStr appendString:@"&"];
        }
        
    }
    return [MyMD5 md5:keyStr];
}

#pragma mark - 移除为空展示
+ (void)removeNullLabelWithSuperView:(UIView *)superView
{
    UIView * nullView = (UIView *)[superView viewWithTag:nullLabelTag];
    if (nullView) {
        [nullView removeFromSuperview];
    }
}

//添加为空展示
+ (void)addANullLabelWithSuperView:(UIView *)superView withText:(NSString *)str
{
    UIView * nullView = (UIView *)[superView viewWithTag:nullLabelTag];
    if(nullView) {
        [nullView removeFromSuperview];
        nullView = nil;
    }
    if (!nullView) {
        nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 102*widthRate, CGRectGetWidth(superView.frame), 160*widthRate)];
        nullView.tag = nullLabelTag;
        [superView addSubview:nullView];
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(superView.frame)-90*widthRate)/2, 0, 90*widthRate, 90*widthRate)];
        imgView.image = [str rangeOfString:@"您的购物车"].length?imageWithName(@"shopCarNoDataImage"): imageWithName(@"noDataImage");
        [nullView addSubview:imgView];
        
        BOOL isTwoLine = NO;
        if ([str rangeOfString:@"\n"].length) {
            isTwoLine = YES;
        }
        UILabel * nulLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 105*widthRate, CGRectGetWidth(superView.frame), isTwoLine?50*widthRate:25*widthRate)];
        nulLabel.font = [UIFont systemFontOfSize:15];
        nulLabel.textAlignment = NSTextAlignmentCenter;
        nulLabel.textColor = [UIColor colorFromHexRGB:@"979797"];
        nulLabel.text = str;
        [nullView addSubview:nulLabel];
        
        if (isTwoLine) {
            NSMutableAttributedString * as = [[NSMutableAttributedString alloc]initWithString:str];
            NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
            [ps setLineSpacing:6];
            [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
            nulLabel.attributedText = as;
            nulLabel.numberOfLines = 2;
            nulLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}

#pragma mark - 提示
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih
{
    if (!tempLabel) {
        tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 40)];
        tempLabel.layer.cornerRadius = 5;
        tempLabel.layer.allowsEdgeAntialiasing = YES;
        tempLabel.layer.masksToBounds = YES;
        tempLabel.backgroundColor = [UIColor blackColor];
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.font = [UIFont systemFontOfSize:13];
        tempLabel.text = message;
        tempLabel.textAlignment = NSTextAlignmentCenter;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    else{
        tempLabel.alpha = 1;
        tempLabel.hidden = NO;
        tempLabel.text = message;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    
    [superView addSubview:tempLabel];
    
    [onlyUtil performSelector:@selector(tempLabelDis) withObject:nil afterDelay:2.0];
    
}

- (void)tempLabelDis
{
    if (tempLabel) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tempLabel.alpha = 0;
        }completion:^(BOOL finished) {
            [tempLabel removeFromSuperview];
            tempLabel = nil;
        }];
    }
}

#pragma mark - 检测是否登录
+ (BOOL)loginIsOrNot
{
    if ([lhUtilObject shareUtil].isOnLine) {
        return YES;
    }
    else{
        //跳转到登录界面
        lhLoginViewController * lVC = [[lhLoginViewController alloc]init];
        UINavigationController * nlVC = [[UINavigationController alloc]initWithRootViewController:lVC];
        [[lhTabBar shareTabBar] presentViewController:nlVC animated:YES completion:^{
            
        }];
    }
    
    return NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        [lhUtilObject shareUtil].noShowKaiChang = YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else{
        if (IOS8){
            [lhUtilObject shareUtil].noShowKaiChang = YES;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        exit(0);
    }
    
}

#pragma mark - 判断是否开启定位
+ (BOOL)isOpenLocarion
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {//未开启定位
        if (IOS8){
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，现在开启！" delegate:onlyUtil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            tempA.tag = 2;
            [tempA show];
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在设置－>隐私－>定位服务开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)isOpenLocarionNoNotice
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {//未开启定位
        
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - 获取当前城市
- (void)locationCity:(LocationCityBlock)locationCity error:(LocationErrorBlock)errorB
{
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {//未开启定位
//        
//        if (IOS8){
//            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，现在开启！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [tempA show];
//        }
//        else{
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在设置－>隐私－>定位服务开启定位服务！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        
//        return;
//    }
    [[MMLocationManager shareLocation]getCity:^(NSString *addressString) {
        locationCity(addressString);
    }error:^(NSError *error) {
        errorB(error);
    }];
}

#pragma mark - 分享
+ (void)fxViewAppear:(id)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withVc:(UIViewController *)fxVc
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    tempFxVc = fxVc;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:onlyUtil action:@selector(fxViewDisAppear)];
    UIView * grayV = [[UIView alloc]initWithFrame:fxVc.view.frame];
    grayV.tag = fxBgViewTag;
    grayV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [grayV addGestureRecognizer:tapG];
    [fxVc.view addSubview:grayV];
    
    UIView * fxView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate)];
    fxView.tag = fxLowViewTag;
    fxView.backgroundColor = [UIColor whiteColor];
    [fxVc.view addSubview:fxView];
    
    NSArray * a = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    for (int i = 0; i < 4; i++) {
        lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame2:CGRectMake(DeviceMaxWidth/4*i, 0, DeviceMaxWidth/4, 100*widthRate)];
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        
        [fxBtn addTarget:onlyUtil action:@selector(fxBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [fxView addSubview:fxBtn];
    }
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 35*widthRate);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.backgroundColor = lhviewColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:lhcontentTitleColorStr1 forState:UIControlStateNormal];
    [cancelBtn addTarget:onlyUtil action:@selector(fxViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
    [fxView addSubview:cancelBtn];
    
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 1;
        fxView.frame = CGRectMake(0, DeviceMaxHeight-135*widthRate, DeviceMaxWidth, 135*widthRate);
    }];
    
}

- (void)fxBtnEventOther:(UIButton *)button_ image:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    
    [self fxBtnEvent:button_];
}

- (void)fxBtnEvent:(UIButton *)button_
{
    [onlyUtil fxViewDisAppear];
    
    ShareType type;
    switch (button_.tag) {
        case 0:{
            //微信好友
            type = ShareTypeWeixiSession;
            break;
        }
        case 1:{
            //微信朋友圈
            type = ShareTypeWeixiTimeline;
            break;
        }
        case 2:{
            //QQ好友
            type = ShareTypeQQ;
            
            break;
        }
        case 3:{
            //新浪微博
            //QQ空间
            type = ShareTypeQQSpace;
            break;
        }
        default:
            break;
    }
    
    [lhUtilObject sendMessageToWeiXinSession:type];
    
}

#pragma mark - 分享
+ (void)sendMessageToWeiXinSession:(NSInteger)shareType
{
    
    ShareType type = (ShareType)shareType;
    if(type == ShareTypeQQ || type == ShareTypeQQSpace){
        if (![QQApiInterface isQQInstalled]) {
            [lhUtilObject showAlertWithMessage:@"请先安装QQ客户端~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    else if(type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline){
        if (![WXApi isWXAppInstalled]) {
            [lhUtilObject showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
        if(![WXApi isWXAppSupportApi]){
            [lhUtilObject showAlertWithMessage:@"微信版本不支持分享~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    
    NSString * titleStr = @"优品购油宝资讯";
    if ([fxImg class] == [UIImage class]) {
        titleStr = @"团好油，购实惠";
    }
    else{
        if (type==ShareTypeWeixiTimeline) {
            fxConStr = [NSString stringWithFormat:@"优品购油宝资讯——%@",fxConStr];
        }
    }
    
//    NSString * urlStr = [NSString stringWithFormat:@"%@/images/icon.png",[lhUtilObject shareUtil].webImgUrl];[ShareSDK imageWithUrl:urlStr]
    id<ISSContent> publishContent = [ShareSDK content:fxConStr defaultContent:nil image:[fxImg class]==[UIImage class]?[ShareSDK pngImageWithImage:fxImg]:[ShareSDK imageWithUrl:fxImg] title:type==ShareTypeWeixiTimeline?fxConStr:titleStr url:fxUrlStr description:fxConStr mediaType:type==ShareTypeSinaWeibo?SSPublishContentMediaTypeText: SSPublishContentMediaTypeNews];
    [lhUtilObject shareUtil].noShowKaiChang = YES;
    
    [lhHubLoading addActivityView:tempFxVc.view];
    
    //2.分享
    [ShareSDK shareContent:publishContent type:type authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        [lhHubLoading disAppearActivitiView];
        
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            ////NSLog(@"分享成功");
            
            [lhUtilObject showAlertWithMessage:@"分享成功~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
        }
        else if (state == SSResponseStateFail) {//如果分享失败
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            
            if ([error errorCode] == -22003) {
                [lhUtilObject showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            }
            else if([error errorCode] == -22005){
                [lhUtilObject showAlertWithMessage:@"取消分享~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            }
            else{
                [lhUtilObject showAlertWithMessage:@"分享失败~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            }
            
        }
        else if (state == SSResponseStateCancel) {
            [lhUtilObject showAlertWithMessage:@"取消分享~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
        }
        
    }];
    
}

- (void)fxViewDisAppear
{
    UIView * grayV = [tempFxVc.view viewWithTag:fxBgViewTag];
    UIView * fxView = [tempFxVc.view viewWithTag:fxLowViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 0;
        fxView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate);
    }completion:^(BOOL finished) {
        [grayV removeFromSuperview];
        [fxView removeFromSuperview];
    }];
}

#pragma mark - 拨打电话
+ (void)detailPhone:(NSString *)phone
{
    //NSLog(@"拨打电话");
    [self dialPhoneNumber:phone];
}

+ (void)dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

@end
