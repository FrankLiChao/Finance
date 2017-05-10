//
//  lhCursorLabel.h
//  SCFinance
//
//  Created by bosheng on 16/6/28.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//带闪烁光标的label

@interface lhCursorLabel : UILabel

@property (nonatomic,strong)UILabel * cursor;

/**
 *光标闪烁
 */
- (void)cursorBlink;

@end
