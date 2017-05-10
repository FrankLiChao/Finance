//
//  lhCircleView.m
//  LHNormalTest
//
//  Created by bosheng on 16/7/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhCircleView.h"
#import "NSTimer+LHBlockSupport.h"

static const CGFloat progressStrokeWidth = 10;

@interface lhCircleView ()
{
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;//用来填充的图层
    UIBezierPath *backGroundBezierPath;//背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;//用来填充的贝赛尔曲线
    
    UIColor *progressColor;//进度条颜色
    UIColor *progressTrackColor;//进度条轨道颜色
    
    NSTimer * timer;//定时器用作动画
    CGPoint center;//中心点
}

@end

@implementation lhCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        progressColor = [UIColor redColor];
        progressTrackColor = [UIColor grayColor];
        
        //创建背景图层
        backGroundLayer = [CAShapeLayer layer];
        backGroundLayer.fillColor = nil;
        backGroundLayer.frame = self.bounds;
        
        //创建填充图层
        frontFillLayer = [CAShapeLayer layer];
        frontFillLayer.fillColor = nil;
        frontFillLayer.frame = self.bounds;
        
        frontFillLayer.strokeColor = progressColor.CGColor;
        backGroundLayer.strokeColor = progressTrackColor.CGColor;
        
        center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        
        backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds)-progressStrokeWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        backGroundLayer.path = backGroundBezierPath.CGPath;
        
        frontFillLayer.lineWidth = progressStrokeWidth;
        backGroundLayer.lineWidth = progressStrokeWidth;
        
        [self.layer addSublayer:backGroundLayer];
        [self.layer addSublayer:frontFillLayer];
        
        _numlabel = [[UILabel alloc]initWithFrame:CGRectMake(progressStrokeWidth, (CGRectGetHeight(self.frame)-30)/2-5, CGRectGetWidth(self.frame)-progressStrokeWidth, 30)];
        _numlabel.textColor = progressColor;
        _numlabel.textAlignment = NSTextAlignmentCenter;
        _numlabel.font = [UIFont systemFontOfSize:20];
        _numlabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_numlabel];
        
        UILabel * detaillabel = [[UILabel alloc]initWithFrame:CGRectMake(progressStrokeWidth, CGRectGetHeight(self.frame)/2+8, CGRectGetWidth(self.frame)-progressStrokeWidth, 15)];
        detaillabel.textColor = progressColor;
        detaillabel.textAlignment = NSTextAlignmentCenter;
        detaillabel.font = [UIFont systemFontOfSize:13];
        detaillabel.text = @"查看详情";
        [self addSubview:detaillabel];
        
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.frame = self.bounds;
        _detailBtn.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
        _detailBtn.layer.masksToBounds = YES;
        [self addSubview:_detailBtn];
    }
    
    return self;
}


- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }

    __weak typeof(self) wSelf = self;
    __block CGFloat progress = 0.0;
    timer = [NSTimer lh_scheduledTimerWithTimeInterval:0.001 block:^{
        
        if (progress >= _progressValue || progress >= 1.0f) {
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            
            frontFillLayer.cornerRadius = 5.0f;
            frontFillLayer.masksToBounds = YES;
            
            return;
        }
        else{
            frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(wSelf.bounds)-progressStrokeWidth)/2.f startAngle:-M_PI_2 endAngle:(2*M_PI)*progress-M_PI_2 clockwise:YES];
            frontFillLayer.path = frontFillBezierPath.CGPath;
            frontFillLayer.lineCap = @"round";
        }
        progress += 0.01*(_progressValue);
        
    } repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
