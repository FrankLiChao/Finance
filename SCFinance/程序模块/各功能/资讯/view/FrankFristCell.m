//
//  FrankFristCell.m
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankFristCell.h"
#import "FrankAutoLayout.h"
#import "FrankTools.h"

@implementation FrankFristCell
{
    UILabel *titleLab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void)setup{ //95
    // 设置约束
    
    CGFloat margin = 10;
    CGFloat higin = 16;
    
    self.imgIcon.sd_layout
    .leftSpaceToView(self.contentView,margin)
    .topSpaceToView(self.contentView,higin)
    .widthIs(100)
    .heightIs(60);
    
    self.readMessage.sd_layout
    .bottomEqualToView(self.imgIcon)
    .leftSpaceToView(self.imgIcon,20)
    .heightIs(15);
    [self.readMessage setSingleLineAutoResizeWithMaxWidth:100];
    
    self.collectMessage.sd_layout
    .leftSpaceToView(self.readMessage,10)
    .topEqualToView(self.readMessage)
    .heightIs(15);
    [self.collectMessage setSingleLineAutoResizeWithMaxWidth:100];
    
    self.dataMessage.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topEqualToView(self.readMessage)
    .heightIs(15);
    [self.dataMessage setSingleLineAutoResizeWithMaxWidth:100];
    
    self.titleMessage.sd_layout
    .leftSpaceToView(self.imgIcon ,20)
    .rightSpaceToView(self.contentView,margin)
    .bottomSpaceToView(self.readMessage,0)
    .topSpaceToView(self.contentView,higin);
    
    self.titleMessage.isAttributedContent = YES;
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = self.titleMessage.frame;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = lhcontentTitleColorStr;
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.titleMessage addSubview:titleLab];
    
    self.lineView.sd_layout
    .topSpaceToView(self.contentView,95-0.5)
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,10)
    .heightIs(0.5);
    
//    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}


-(void)setBaseModel:(FrankBaseModel *)baseModel{
    NSInteger size = 2;
    if ([baseModel.adsTitle isEqualToString:@""] || baseModel.adsTitle == nil) {
        baseModel.adsTitle = @"";
    }
    titleLab.attributedText = [FrankTools setLineSpaceing:size WithString:baseModel.adsTitle WithRange:NSMakeRange(0, baseModel.adsTitle.length)];
    CGRect rect = titleLab.frame;
    rect.size.width = DeviceMaxWidth-140;
    rect.size.height = [FrankTools getSpaceLabelHeight:baseModel.adsTitle withFont:[UIFont systemFontOfSize:15] withWidth:rect.size.width withLineSpacing:size];
    if (rect.size.height > 45) {
        rect.size.height = 45;
    }
    titleLab.frame = rect;
    
    self.readMessage.text = [NSString stringWithFormat:@"%@人阅读",baseModel.readCount];
    self.collectMessage.text = [NSString stringWithFormat:@"%@人收藏",baseModel.collectCount];
    self.dataMessage.text = baseModel.adsTime;

    [lhUtilObject checkImageWithImageView:self.imgIcon withImage:baseModel.imgsrc withImageUrl:PATHImg(baseModel.imgsrc) withPlaceHolderImage:imageWithName(placeHolderImg)];
}

@end
