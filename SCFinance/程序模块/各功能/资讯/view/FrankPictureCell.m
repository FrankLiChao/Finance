//
//  FrankPictureCell.m
//  SCFinance
//
//  Created by lichao on 16/5/24.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankPictureCell.h"
#import "FrankAutoLayout.h"
#import "FrankDetailsView.h"

@implementation FrankPictureCell
{
    UIScrollView *bannerScrollView;
    UIViewController *tempVc;
    NSArray *lunboArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self setup];
        [self initView];
    }
    return  self;
}

-(void)initView
{
    self.cycleScrollView = [[SDCycleScrollView alloc] init];
    [self.contentView addSubview:self.cycleScrollView];
    
    //设置约束
    CGFloat margin = 0;
    self.cycleScrollView.sd_layout
    .topSpaceToView(self.contentView,margin)
    .leftSpaceToView(self.contentView,margin)
    .rightSpaceToView(self.contentView,margin)
    .heightIs(210);
}

-(void)setBaseModel:(FrankBaseModel *)baseModel
{
    lunboArray = baseModel.lunboArray;
    NSMutableArray *titleA = [NSMutableArray new];
    NSMutableArray *banerA = [NSMutableArray new];
    for (int i=0; i<baseModel.lunboArray.count; i++) {
        NSString *titileStr = [NSString stringWithFormat:@"%@",[baseModel.lunboArray[i] objectForKey:@"title"]];
        NSString *image = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,[baseModel.lunboArray[i] objectForKey:@"image"]];
        [titleA addObject:titileStr];
        [banerA addObject:image];
    }
    
    tempVc = baseModel.tempVc;
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 分页控件位置
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;// 分页控件风格
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.titlesGroup = titleA;
    self.cycleScrollView.imageURLStringsGroup = banerA;
    self.cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:placeHolderImg];

}

//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"点击图片 %ld",index);
    FrankDetailsView *detailView = [FrankDetailsView new];
    detailView.articleId = [NSString stringWithFormat:@"%@",[lunboArray[index] objectForKey:@"id"]];
    detailView.titleStr = [NSString stringWithFormat:@"%@",[lunboArray[index] objectForKey:@"title"]];
    detailView.myWebUrl = [NSString stringWithFormat:@"%@",PATH(@"client_findArticle")];
    detailView.imageStr = [NSString stringWithFormat:@"%@",[lunboArray[index] objectForKey:@"image"]];
    detailView.isCollected = [[lunboArray[index] objectForKey:@"isCollected"] integerValue];
    detailView.type = 5;
    [[lhTabBar shareTabBar].navigationController pushViewController:detailView animated:YES];
}

@end
