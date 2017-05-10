//
//  FrankPopView.m
//  SCFinance
//
//  Created by lichao on 16/6/14.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankPopView.h"
#import "FrankAutoLayout.h"
#import "FrankTools.h"

@implementation FrankPopView
{
    UILabel *bmTitleLable;
    UILabel *sdTitleLable;
    UILabel *payTitleLable;
    UILabel *thTitleLable;
    NSArray *contentA;  //内容
    NSArray *pictureA;  //图标
}

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        bgView.tag = 1008611;
        [self addSubview:bgView];
        
        CGFloat hight = 0;
        if (iPhone6 || iPhone6plus) {
            hight = 140;
        }else if (iPhone5)
        {
            hight = 100;
        }else{
            hight = 70;
        }
        
        UIView *alterView = [[UIView alloc] initWithFrame:CGRectMake(30*widthRate, hight, DeviceMaxWidth-60*widthRate, DeviceMaxHeight-285)];
        alterView.backgroundColor = [UIColor whiteColor];
        alterView.layer.cornerRadius = 5;
        alterView.tag = 1008612;
        [bgView addSubview:alterView];
        
        if (type == 0) {
            contentA = @[@"确定您所需油品及数量并支付订金。",@"报名截止日，在供应商挂牌价基础上进行优惠，确定最终成交单价，成交价一定远低于您独自购买。",@"尾款 = 成交单价 * 购买数量 + 服务费 - 订金。",@"平台将提货权发放给各买家，买家自主到供应商油库提货。"];
            pictureA = @[@"baomingImage",@"suodingpriceImage",@"payweikuanImage",@"zizhutihuoImage"];
        }else{
            contentA = @[@"请您确定所需油品及数量。",@"请您通过网银转账，全额支付购油货款。",@"平台给您开具供应商认可的提油单，并开具发票。",@"您可自主打印提油单，随时凭单到指定的油库提油。"];
            pictureA = @[@"tijiaodingdanImage",@"zhifuhuokuanImage",@"chudanchupiaoImage",@"zizhutihuoImage"];
        }
        
        UIImageView *bmImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 30*widthRate, 20*widthRate, 20*widthRate)];
        [bmImage setImage:imageWithName(pictureA[0])];
        [alterView addSubview:bmImage];
        
        bmTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40*widthRate, 30*widthRate, 200*widthRate, 20*widthRate)];
        bmTitleLable.font = [UIFont boldSystemFontOfSize:15];
        bmTitleLable.textColor = lhcontentTitleColorStr;
        [alterView addSubview:bmTitleLable];
        
        UILabel *bmLable = [UILabel new];
        bmLable.text = contentA[0];
        bmLable.font = [UIFont systemFontOfSize:13];
        bmLable.textColor = lhcontentTitleColorStr;
        [alterView addSubview:bmLable];
        
        bmLable.sd_layout
        .leftEqualToView(bmTitleLable)
        .topSpaceToView(bmTitleLable,10*widthRate)
        .rightSpaceToView(alterView,15*widthRate)
        .autoHeightRatio(0);
        
        UIImageView *sdPriceimage = [UIImageView new];
        [sdPriceimage setImage:imageWithName(pictureA[1])];
        [alterView addSubview:sdPriceimage];
        
        sdPriceimage.sd_layout
        .leftEqualToView(bmImage)
        .topSpaceToView(bmLable,15*widthRate)
        .widthIs(20*widthRate)
        .heightIs(20*widthRate);
        
        sdTitleLable = [UILabel new];
        sdTitleLable.text = _nameArray[1];
        sdTitleLable.font = [UIFont boldSystemFontOfSize:15];
        sdTitleLable.textColor = lhcontentTitleColorStr;
        [alterView addSubview:sdTitleLable];
        
        sdTitleLable.sd_layout
        .leftEqualToView(bmTitleLable)
        .topEqualToView(sdPriceimage)
        .widthIs(200*widthRate)
        .heightIs(20*widthRate);
        
        
        NSString *sdStr = contentA[1];
        UILabel *sdLable = [UILabel new];
        sdLable.font = [UIFont systemFontOfSize:13];
        sdLable.textColor = lhcontentTitleColorStr;
        sdLable.isAttributedContent = YES;
        sdLable.attributedText = [FrankTools setLineSpaceing:4 WithString:sdStr WithRange:NSMakeRange(0, sdStr.length)];
        [alterView addSubview:sdLable];
        
        sdLable.sd_layout
        .leftEqualToView(sdTitleLable)
        .topSpaceToView(sdTitleLable,10*widthRate)
        .rightSpaceToView(alterView,15*widthRate)
        .autoHeightRatio(0);
        
        UIImageView *payImage = [UIImageView new];
        [payImage setImage:imageWithName(pictureA[2])];
        [alterView addSubview:payImage];
        
        payImage.sd_layout
        .leftEqualToView(bmImage)
        .topSpaceToView(sdLable,15*widthRate)
        .widthIs(20*widthRate)
        .heightIs(20*widthRate);
        
        payTitleLable = [UILabel new];
        payTitleLable.font = [UIFont boldSystemFontOfSize:15];
        payTitleLable.textColor = lhcontentTitleColorStr;
        [alterView addSubview:payTitleLable];
                                  
        payTitleLable.sd_layout
        .leftEqualToView(bmTitleLable)
        .topEqualToView(payImage)
        .widthIs(200*widthRate)
        .heightIs(20*widthRate);
        
        NSString *wkStr = contentA[2];
        UILabel *payLable = [UILabel new];
        payLable.font = [UIFont systemFontOfSize:13];
        payLable.textColor = lhcontentTitleColorStr;
        payLable.isAttributedContent = YES;
        payLable.attributedText = [FrankTools setLineSpaceing:4 WithString:wkStr WithRange:NSMakeRange(0, wkStr.length)];
        [alterView addSubview:payLable];
        
        payLable.sd_layout
        .leftEqualToView(bmLable)
        .topSpaceToView(payTitleLable,10*widthRate)
        .widthRatioToView(bmLable,1)
        .autoHeightRatio(0);
        
        UIImageView *thImage = [UIImageView new];
        [thImage setImage:imageWithName(pictureA[3])];
        [alterView addSubview:thImage];
        
        thImage.sd_layout
        .leftEqualToView(bmImage)
        .topSpaceToView(payLable,15*widthRate)
        .widthIs(20*widthRate)
        .heightIs(20*widthRate);
        
        thTitleLable = [UILabel new];
        thTitleLable.font = [UIFont boldSystemFontOfSize:15];
        thTitleLable.textColor = lhcontentTitleColorStr;
        [alterView addSubview:thTitleLable];
        
        thTitleLable.sd_layout
        .leftEqualToView(bmTitleLable)
        .topEqualToView(thImage)
        .widthIs(200*widthRate)
        .heightIs(20*widthRate);
        
        NSString *thStr = contentA[3];
        UILabel *thLable = [UILabel new];
        thLable.font = [UIFont systemFontOfSize:13];
        thLable.textColor = lhcontentTitleColorStr;
        thLable.isAttributedContent = YES;
        thLable.attributedText = [FrankTools setLineSpaceing:4 WithString:thStr WithRange:NSMakeRange(0, thStr.length)];
        [alterView addSubview:thLable];
        
        thLable.sd_layout
        .leftEqualToView(bmLable)
        .topSpaceToView(thTitleLable,10*widthRate)
        .widthRatioToView(bmLable,1)
        .autoHeightRatio(0);
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = tableDefSepLineColor;
        [alterView addSubview:lineV];
        
        lineV.sd_layout
        .leftSpaceToView(alterView,0)
        .topSpaceToView(thLable,15*widthRate)
        .rightSpaceToView(alterView,0)
        .heightIs(0.5);
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [cancelButton setTitleColor:lhredColorStr forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(clickCancelButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [alterView addSubview:cancelButton];
        
        cancelButton.sd_layout
        .leftSpaceToView(alterView,0)
        .topSpaceToView(lineV,0)
        .rightSpaceToView(alterView,0)
        .heightIs(50*widthRate);
        
        [alterView setupAutoHeightWithBottomView:cancelButton bottomMargin:0];
        
        //动画效果
        bgView.alpha = 0;
        alterView.alpha = 0;
        alterView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            bgView.alpha = 1;
            alterView.transform = CGAffineTransformMakeScale(1, 1);
            alterView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    return self;
}

-(void)clickCancelButtonEvent
{
    
    __block UIView * bgView = [self viewWithTag:1008611];
    __block UIView * alertView = [self viewWithTag:1008612];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.2 animations:^{
        bgView.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        alertView.alpha = 0;
    }completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [alertView removeFromSuperview];
        [ws removeFromSuperview];
        bgView = nil;
        alertView = nil;
    }];
}

-(void)setNameArray:(NSArray *)nameArray
{
    bmTitleLable.text = nameArray[0];
    sdTitleLable.text = nameArray[1];
    payTitleLable.text = nameArray[2];
    thTitleLable.text = nameArray[3];
}

@end
