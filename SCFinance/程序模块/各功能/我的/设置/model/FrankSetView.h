//
//  FrankSetView.h
//  Drive
//
//  Created by lichao on 15/10/27.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankSetView : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIImageView * yjtImgView;
@property(nonatomic,strong)UISwitch * mSwitch;

@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UIView * lowLine;

@end
