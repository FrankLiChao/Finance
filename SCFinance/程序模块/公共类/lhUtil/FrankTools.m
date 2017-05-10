//
//  FrankTools.m
//  SCFinance
//
//  Created by lichao on 16/5/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankTools.h"
#import "FrankAutolayout.h"

static FrankTools *shareTool;

@interface FrankTools(){
    UIWebView *myWebView;
}

@end

@implementation FrankTools

/**
 *  创建单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{     //该方法只执行一次，且能保证线程安全
        shareTool = [[FrankTools alloc] init];
    });
    return shareTool;
}

+ (void)showAlertWithText:(NSString *)text withView:(UIView *)pView;
{
    UIView *alert = [UIView new];
    
    alert.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [UILabel new];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    [alert addSubview:label];
    
    label.sd_layout
    .leftSpaceToView(alert, 20)
    .rightSpaceToView(alert, 20)
    .topSpaceToView(alert, 20)
    .autoHeightRatio(0);
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    alert.sd_layout
    .centerXEqualToView(alert.superview)
    .centerYEqualToView(alert.superview)
    .widthIs(220);
    [alert setupAutoHeightWithBottomView:label bottomMargin:20];
    
    alert.sd_cornerRadius = @(5);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openUserEnable:pView];
        [alert removeFromSuperview];
    });
    [self closeUserEnable:pView];
}

+ (void)openUserEnable:(UIView *)vie
{
    for (UIView * v in vie.subviews) {
        v.userInteractionEnabled = YES;
    }
}

+ (void)closeUserEnable:(UIView *)viw
{
    for (UIView * v in viw.subviews) {
        v.userInteractionEnabled = NO;
    }
}

#pragma mark - 打电话
+ (void)callPhone:(NSString *)phone
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
    FLLog(@"打电话 = %@",[NSString stringWithFormat:@"tel:%@",phone]);
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark - 设置字体的行间距
+(NSMutableAttributedString *)setLineSpaceing:(NSInteger)size WithString:(NSString *)string WithRange:(NSRange)range
{
    if ([string isEqualToString:@""]) {
        return nil;
    }
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:size];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:range];
    return as;
}

/**
 * 设置范围内字体的大小
 */
+(NSMutableAttributedString *)setFontSize:(UIFont *)fontSize WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSFontAttributeName value:fontSize range:range];
    return as;
}

/**
 * 设置范围内字体的大小和颜色
 */
+(NSMutableAttributedString *)setFontColorSize:(UIFont *)fontSize WithColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSFontAttributeName value:fontSize range:range];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    return as;
}

#pragma mark - 设置控件文本部分字体颜色
+(NSMutableAttributedString *)setFontColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    return as;
}

#pragma mark - 设置字体的行间距同时修改自定范围字体颜色
+(NSMutableAttributedString *)setLineSpaceingWithString:(NSString *)string WithSize:(NSInteger)size WithColor:(UIColor *)color WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    //设置字体颜色
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    //调整字体间距
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:size];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, string.length)];
    return as;
}

#pragma mark - 对时间进行处理
+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatestr];
    NSString *strDate = [dateFormatter stringFromDate:dateFromString];
    return strDate;
}


/*
 *  @"YYYY-MM-dd HH:mm:ss"
 */
+(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr
{
    NSDate * date = nil;
    time = [NSString stringWithFormat:@"%@",time];
    if (time.length == 10) { //10位
        date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }else //13位
    {
        date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
    }
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:formatestr];
    return [df stringFromDate:date];
}

//返回两个时段相差的秒数
+(NSInteger)getSecondsWithBeginDate:(NSString*)currentTime  AndEndDate:(NSString*)deadlineTime{
    NSTimeInterval deadline = [deadlineTime longLongValue]/1000;
    NSTimeInterval current = [currentTime longLongValue]/1000;
    return deadline-current;
}

+(NSNumber *)stringToNSNumber:(NSString *)string
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [numberFormatter numberFromString:string];
}

+ (CGFloat)sizeForString:(NSString *)text withSizeOfFont:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [text sizeWithAttributes:dict];
    return size.width;
}

//根据文字和字体，计算文字的特定高度SpecificWidth内的显示高度
+(CGFloat)getSpaceLabelHeight:(NSString*)string withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(CGFloat)size
{
    if ([string isEqualToString:@""]) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = size;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize sizeHeight = [string boundingRectWithSize:CGSizeMake(width, DeviceMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return sizeHeight.height;
}

#pragma mark - 手机号码处理
+(NSString *)replacePhoneNumber:(NSString *)phoneNumber
{
    return [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

#pragma mark - 手机号验证
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    if (mobile && mobile.length == 11 && [mobile characterAtIndex:0] == '1') {
        return YES;
    }
    return NO;
}

//去掉浮点数字符串末尾的0
+ (NSString *)floatStringZero:(NSString *)oldStr
{
    NSString *nowStr = [oldStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    const char * str = [nowStr UTF8String];
    
    int zeroLength = 0;
    for (int i = (int)nowStr.length-1; i > 0; i--) {
        if (str[i] == '0') {
            zeroLength++;
        }
        else if (str[i] == '.'){
            zeroLength++;
            break;
        }
        else{
            break;
        }
    }
    
    return [oldStr substringToIndex:oldStr.length-zeroLength];
}

#pragma mark - 定时器倒计时
+ (void)dealWithTime:(NSInteger)timeNumber withShowView:(UILabel *)showView
{
    NSInteger day = timeNumber/(24*3600);
    NSInteger hour = (timeNumber%(24*3600))/3600;
    NSInteger minutes = (timeNumber%3600)/60;
    NSInteger seconds = timeNumber%60;
    
    NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString * hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    if (hour < 10 && hour > 0) {
        hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    NSString * minutesStr = [NSString stringWithFormat:@"%ld",(long)minutes];
    if (minutes < 10 && minutes > 0) {
        minutesStr = [NSString stringWithFormat:@"0%@",minutesStr];
    }
    NSString * secondsStr = [NSString stringWithFormat:@"%ld",(long)seconds];
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%@",secondsStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeNumber>0) {
            if (day <= 0) {
                showView.text = [NSString stringWithFormat:@"还剩 %@小时%@分%@秒",hourStr,minutesStr,secondsStr];
            }
            else{
                showView.text = [NSString stringWithFormat:@"还剩%@天 %@:%@:%@",dayStr,hourStr,minutesStr,secondsStr];
            }
        }else
        {
            showView.text = [NSString stringWithFormat:@"已截止"];
        }
    });
}
@end
