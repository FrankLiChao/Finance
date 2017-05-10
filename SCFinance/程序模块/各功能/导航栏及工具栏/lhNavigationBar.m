//
//  lhNavigationBar.m
//  LHTestProduct
//
//  Created by bosheng on 16/1/14.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhNavigationBar.h"

@implementation lhNavigationBar

- (instancetype)initWithVC:(UIViewController *)tempV title:(NSString *)titleStr isBackBtn:(BOOL)yesOrNo rightBtn:(NSString *)tStr
{
    self = [super initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 64)];
    if (self) {
        tempVC = tempV;
        tempV.view.backgroundColor = lhviewColor;
        self.backgroundColor = lhmainColorBlack;
        [self firmInitTitle:titleStr isBackBtn:yesOrNo rightBtn:tStr];
    }
    return self;
}

- (void)firmInitTitle:(NSString *)titleStr isBackBtn:(BOOL)yesOrNo rightBtn:(NSString *)tStr
{
    if (yesOrNo) {
        
        UIButton * backBg = [UIButton buttonWithType:UIButtonTypeCustom];
        backBg.frame = CGRectMake(0, 20, 20+20*widthRate, 44);
        backBg.tag = backBtnTag;
//        [backBg setBackgroundImage:imageWithName(@"back") forState:UIControlStateNormal];
        [backBg setImage:imageWithName(@"back") forState:UIControlStateNormal];
        [self addSubview:backBg];
        [backBg addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (titleStr && ![@"" isEqualToString:titleStr]) {
        UILabel * tLabel = [[UILabel alloc]init];
        tLabel.frame = CGRectMake(55, 20, DeviceMaxWidth-110, 44);
        tLabel.text = titleStr;
        tLabel.font = [UIFont boldSystemFontOfSize:16];
        tLabel.textColor = [UIColor whiteColor];
        tLabel.tag = navigationBarTitleTag;
        tLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tLabel];
    }
    
    if (tStr && ![@"" isEqualToString:tStr]) {
        UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setTitle:tStr forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        saveButton.tag = 13579;
        saveButton.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
        [saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
    }
    
}

- (void)mergeTitle:(NSString *)titleStr
{
    UILabel * tLabel = (UILabel *)[tempVC.view viewWithTag:navigationBarTitleTag];
    if (tLabel) {
       tLabel.text = titleStr;
    }
}

- (void)mergeRightButton:(NSString *)titleStr
{
    UIButton * rButton = (UIButton *)[tempVC.view viewWithTag:13579];
    if (rButton ) {
        [rButton setTitle:titleStr forState:UIControlStateNormal];
    }
    if (titleStr == nil || [titleStr isEqualToString:@""]) {
        [rButton removeTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [rButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark - 返回按钮
- (void)backButtonEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnEvent)]) {
        [self.delegate backBtnEvent];
    }else
    {
        [tempVC.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveButtonEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightBtnEvent)]) {
        [self.delegate rightBtnEvent];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
