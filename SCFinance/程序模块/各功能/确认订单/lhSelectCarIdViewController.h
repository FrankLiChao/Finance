//
//  lhSelectCarIdViewController.h
//  GasStation
//
//  Created by liuhuan on 15/9/17.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectCarIdAndFaPiaoTitleDelegate.h"

@interface lhSelectCarIdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
}

@property(nonatomic,strong)NSMutableArray *carNumList;//车牌号list
@property(nonatomic,weak)id<selectCarIdAndFaPiaoTitleDelegate> delegate;
//@property (nonatomic,strong)NSString * titleS;//已选择车牌

@end
