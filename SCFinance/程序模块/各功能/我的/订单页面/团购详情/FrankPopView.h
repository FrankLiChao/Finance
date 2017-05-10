//
//  FrankPopView.h
//  SCFinance
//
//  Created by lichao on 16/6/14.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankPopView : UIView

@property (nonatomic,strong)NSArray *nameArray;

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

@end
