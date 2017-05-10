//
//  lhAlertView.h
//  GasStation
//
//  Created by liuhuan on 16/1/12.
//  Copyright © 2016年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class lhAlertView;

@protocol firmBtnClickProtocol <NSObject>

- (void)firmBtnClick:(lhAlertView *)alertView;

@optional
- (void)cancelBtnClick:(lhAlertView *)alertView;

@end

@interface lhAlertView : UIView

@property (nonatomic,strong)NSDictionary * zfDic;//传递支付信息

@property (nonatomic,weak)id<firmBtnClickProtocol> delegate;

- (instancetype)initWithFrame:(CGRect)frame noticeStr:(NSString *)nStr attributedS1:(NSAttributedString *)att1 attributedS2:(NSAttributedString *)att2 attributedS3:(NSAttributedString *)att3 attributedS4:(NSAttributedString *)att4 noticeStr2:(NSString *)noticeStr;

- (instancetype)initWithFrame2:(CGRect)frame noticeStr:(NSString *)nStr attributedS1:(NSAttributedString *)att1;

/**
 *收不到验证码提示
 */
- (instancetype)initWithFrame3:(CGRect)frame noticeStr:(NSString *)nStr;

/**
 * 验证卡信息
 */
- (instancetype)initWithFrame1:(CGRect)frame noticeStr:(NSString *)nStr insImage:(UIImage *)iImage content:(NSString *)content;

@end
