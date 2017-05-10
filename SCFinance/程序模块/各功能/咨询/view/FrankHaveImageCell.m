//
//  FrankHaveImageCell.m
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankHaveImageCell.h"
#import "FrankAutoLayout.h"
#import "lhUtilObject.h"

@implementation FrankHaveImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void)setup //242
{
    CGFloat margin = 10;
    CGFloat higin = 13;
    
    self.titleMessage.sd_layout
    .leftSpaceToView(self.contentView ,margin)
    .topSpaceToView(self.contentView,higin)
    .rightSpaceToView(self.contentView,margin)
    .heightIs(20);
    
    self.imgPicOne.sd_layout
    .leftSpaceToView(self.contentView,margin)
    .topSpaceToView(self.titleMessage,higin)
    .widthIs(DeviceMaxWidth-20)
    .heightIs(150);
    
    self.readMessage.sd_layout
    .topSpaceToView(self.imgPicOne,higin)
    .leftSpaceToView(self.contentView,10)
    .heightIs(20);
    [self.readMessage setSingleLineAutoResizeWithMaxWidth:100];
    
    self.collectMessage.sd_layout
    .leftSpaceToView(self.readMessage,20)
    .topEqualToView(self.readMessage)
    .heightIs(20);
    [self.collectMessage setSingleLineAutoResizeWithMaxWidth:100];
    
    self.dataMessage.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topEqualToView(self.readMessage)
    .heightIs(20);
    [self.dataMessage setSingleLineAutoResizeWithMaxWidth:100];
    
    self.lineView.sd_layout
    .topSpaceToView(self.contentView,242-0.5)
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,10)
    .heightIs(0.5);
}

-(void)setBaseModel:(FrankBaseModel *)baseModel
{
    self.titleMessage.text = baseModel.adsTitle;
    self.readMessage.text = [NSString stringWithFormat:@"%@人阅读",baseModel.readCount];
    self.collectMessage.text = [NSString stringWithFormat:@"%@人收藏",baseModel.collectCount];
    self.dataMessage.text = baseModel.adsTime;

    [lhUtilObject checkImageWithImageView:self.imgPicOne withImage:baseModel.imgsrc withImageUrl:PATHImg(baseModel.imgsrc) withPlaceHolderImage:imageWithName(placeHolderImg)];

}

@end
