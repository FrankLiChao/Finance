//
//  FrankSelectFaPiaoView.h
//  GasStation
//
//  Created by lichao on 15/9/18.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectCarIdAndFaPiaoTitleDelegate.h"

@interface FrankSelectFaPiaoView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTableView;
}

@property (nonatomic,assign)id<selectCarIdAndFaPiaoTitleDelegate> delegate;   //自定义协议对象
@property (nonatomic,strong)NSMutableArray * dataArray;         //存储发票抬头的信息
//@property (nonatomic,strong)NSString * titleS;                  //默认发票抬头

@end
