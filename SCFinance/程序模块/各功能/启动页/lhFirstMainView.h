//
//  lhMainView.h
//  GasStation
//
//  Created by bosheng on 16/3/14.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhFirstMainView : UIView

@property (nonatomic,strong)UIImageView * desImgView;//描述图片
@property (nonatomic,strong)UIButton * skipButton;//跳过

/**
 *单例
 */
+ (instancetype)shareMainView;

/**
 *得到onlyMainView
 */
+ (instancetype)gOnlyMainView;

/**
 * 移除自己
 */
+ (void)removeSelfFromSuperView;

/**
 *弹一个提示框，诱导用户评论
 */
- (void)showComentAlert;

/**
 *检测并显示进场广告
 */
- (void)checkAndShow:(BOOL)isLaunchRun superView:(UINavigationController *)superView;

/**
 *跳过
 */
- (void)skipButtonEvent;

@end
