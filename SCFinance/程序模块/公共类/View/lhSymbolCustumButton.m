//
//  lhSymbolCustumButton.m
//  Drive
//
//  Created by liuhuan on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSymbolCustumButton.h"

@implementation lhSymbolCustumButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        self.tLabel.font = [UIFont systemFontOfSize:12];
        self.tLabel.textColor = lhcontentTitleColorStr;
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tLabel];
    }
    return self;
}

- (instancetype)initWithFrame1:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5*widthRate, 9*widthRate, 12*widthRate, 12*widthRate)];
        [self addSubview:self.tImgView];
        
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(22*widthRate, 0, frame.size.width-22*widthRate, 30*widthRate)];
        self.tLabel.font = [UIFont systemFontOfSize:14];
        self.tLabel.textColor = lhcontentTitleColorStr;
        [self addSubview:self.tLabel];
    }
    return self;
}

- (instancetype)initWithFrame2:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame = CGRectMake((CGRectGetWidth(frame)-40*widthRate)/2, 15*widthRate, 40*widthRate, 40*widthRate);
        self.imgBtn.userInteractionEnabled = NO;
        [self addSubview:self.imgBtn];
        
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 56*widthRate, CGRectGetWidth(frame), 30*widthRate)];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font = [UIFont systemFontOfSize:13];
        self.tLabel.textColor = lhcontentTitleColorStr1;
        [self addSubview:self.tLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
