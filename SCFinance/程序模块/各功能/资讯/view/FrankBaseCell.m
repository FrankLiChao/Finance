//
//  FrankBaseCell.m
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankBaseCell.h"

@implementation FrankBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

// 获取数据类型对应的cell
+(NSString *)cellIdentifierForRow:(FrankBaseModel *)baseModel{
    
    if (baseModel.hasHeadImg){
        return @"FrankPictureCell";
    }else if (baseModel.imgType){
        return @"FrankHaveImageCell";
    }else{
        return @"FrankFristCell";
    }
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgIcon = [UIImageView new];
        self.imgIcon.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imgIcon];
        
        self.titleMessage = [UILabel new];
        self.titleMessage.font = [UIFont systemFontOfSize:15];
        self.titleMessage.textColor = lhcontentTitleColorStr;
        self.titleMessage.numberOfLines = 0;
        self.titleMessage.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleMessage];
        
        self.readMessage = [UILabel new];
        self.readMessage.textColor = lhcontentTitleColorStr2;
        self.readMessage.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.readMessage];
        
        self.collectMessage = [UILabel new];
        self.collectMessage.textColor = lhcontentTitleColorStr2;
        self.collectMessage.font = [UIFont systemFontOfSize:11];
        self.collectMessage.numberOfLines = 0;
        [self.contentView addSubview:self.collectMessage];
        
        self.dataMessage = [UILabel new];
        self.dataMessage.textColor = lhcontentTitleColorStr2;
        self.dataMessage.font = [UIFont systemFontOfSize:11];
        self.dataMessage.textAlignment = NSTextAlignmentRight;
        self.dataMessage.numberOfLines = 0;
        [self.contentView addSubview:self.dataMessage];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = tableDefSepLineColor;
        [self.contentView addSubview:self.lineView];
        
        self.imgPicOne = [UIImageView new];
//        self.imgPicOne.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imgPicOne];
        
    }
    return self;
}


@end
