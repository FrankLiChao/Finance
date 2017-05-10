//
//  lhCursorLabel.m
//  SCFinance
//
//  Created by bosheng on 16/6/28.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhCursorLabel.h"

@interface lhCursorLabel()

@end

@implementation lhCursorLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _cursor = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, 5, CGRectGetHeight(frame))];
        _cursor.textAlignment = NSTextAlignmentCenter;
        _cursor.text = @"|";
        _cursor.font = [UIFont systemFontOfSize:20];
        _cursor.textColor = [UIColor colorWithRed:8.0/255 green:126.0/255 blue:254.0/255 alpha:1];
        [self addSubview:_cursor];
        
        [self cursorBlink];
    }
    
    
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self adjustDistance];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    
    [self adjustDistance];
}

- (void)adjustDistance
{
    self.numberOfLines = 1;
    CGSize size = [lhUtilObject sizeWithFontWhenIOS7:self.text font:self.font];
    if (size.width > CGRectGetWidth(self.frame)) {
        _cursor.hidden = YES;
        return;
    }

    CGRect rect = _cursor.frame;
    switch (self.textAlignment) {
        case NSTextAlignmentLeft:{
            rect.origin.x = size.width-2;
            
            break;
        }
        case NSTextAlignmentRight:{
            rect.origin.x = CGRectGetWidth(self.frame)-2;
            
            break;
        }
        case NSTextAlignmentCenter:{
            rect.origin.x = (CGRectGetWidth(self.frame)+size.width)/2-2;
            
            break;
        }
        default:
            break;
    }
    _cursor.frame = rect;
    
}

#pragma mark - 光标闪烁
- (void)cursorBlink
{
    if(_cursor && _cursor.hidden == NO){
        _cursor.alpha = 1;
        [UIView animateWithDuration:0.6 animations:^{
            _cursor.alpha = 0;
        }completion:^(BOOL finished) {
            [self performSelector:@selector(cursorBlink) withObject:self afterDelay:0.6];
        }];
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
