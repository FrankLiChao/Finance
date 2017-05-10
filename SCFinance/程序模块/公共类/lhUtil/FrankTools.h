//
//  FrankTools.h
//  SCFinance
//
//  Created by lichao on 16/5/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrankTools : NSObject

+ (instancetype)sharedInstance;

+ (void)showAlertWithText:(NSString *)text withView:(UIView *)pView;

/*
 *  打电话
 */
+ (void)callPhone:(NSString *)phone;

/**
 * 设置字体的行间距
 */
+(NSMutableAttributedString *)setLineSpaceing:(NSInteger)size WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置字体的大小
 */
+(NSMutableAttributedString *)setFontSize:(UIFont *)fontSize WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置字体的大小和颜色
 */
+(NSMutableAttributedString *)setFontColorSize:(UIFont *)fontSize WithColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置控件文本部分字体颜色
 */
+(NSMutableAttributedString *)setFontColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置字体的行间距同时修改自定范围字体颜色
 */
+(NSMutableAttributedString *)setLineSpaceingWithString:(NSString *)string WithSize:(NSInteger)size WithColor:(UIColor *)color WithRange:(NSRange)range;

//对时间的处理
+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr;

/*
 * 对Long类型的时间（时间戳）进行格式化
 */
+(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr;

/*
 * 两个时间相差多少秒
 */
+(NSInteger)getSecondsWithBeginDate:(NSString*)currentTime  AndEndDate:(NSString*)deadlineTime;

+(NSNumber *)stringToNSNumber:(NSString *)string;

+ (CGFloat)sizeForString:(NSString *)text withSizeOfFont:(UIFont *)font;

/**
 * 根据宽度、行距、字体计算高度
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)string withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(CGFloat)size;

/*
 *用*号替换手机号码中间4位
 */
+(NSString *)replacePhoneNumber:(NSString *)phoneNumber;
/*
 *用*号替换手机号码中间4位
 */
+(BOOL) isValidateMobile:(NSString *)mobile;

/*
 * 去掉字符串末尾的0
 */
+ (NSString *)floatStringZero:(NSString *)oldStr;

/*
 * 根据两个时间段的差值进行定时器显示处理
 */
+ (void)dealWithTime:(NSInteger)timeNumber withShowView:(UILabel *)showView;

@end
