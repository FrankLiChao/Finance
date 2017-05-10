//
//  UIColor+lhColor.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (lhColor)


/**
 *根据6为16进制字符串转成颜色
 *inColorString:6位16进制字符串
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end
