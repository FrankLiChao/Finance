//
//  lhMainViewModel.h
//  SCFinance
//
//  Created by bosheng on 16/5/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lhMainModel.h"
@class lhGoodsTableViewCell;

@interface lhMainViewModel : NSObject

/**
 *单例
 */
+ (instancetype)shareMainViewModel;

/**
 *获取主页数据
 *success:获取数据成功Block，返回
 */
+ (void)getMainDataAreaId:(NSString *)areaId success:(void (^)(id response))success fail:(void (^)(id error))fail;

/**
 *加入到购物车
 *productId:添加到购物车的商品id
 *numStr:添加数量
 *success:获取数据成功Block，返回
 */
+ (void)addProductToShopCar:(NSString *)productId numStr:(NSString *)numStr success:(void (^)(id response))success;

/**
 *根据筛选条件请求团购或直购数据
 *filterDict:筛选条件
 *type:购买类型，type=5表示团购，type=6表示直购
 *pageSize:每页显示条数
 *pageNo:页数
 *success:请求成功block，返回值为lhUserModel对象
 */
+ (void)requestData:(NSDictionary *)filterDict areaId:(NSString *)areaId type:(NSInteger)type pageSize:(NSInteger)pageSize pageNo:(NSInteger)pageNo success:(void (^)(id data))success fail:(void (^)(id error))fail;

/**
 *获取筛选条件
 *areaDic:区域信息
 */
+ (void)requestFilterData:(NSDictionary *)areaDic type:(NSInteger)type success:(void (^)(id data))success fail:(void (^)(id error))fail;

/**
 *获取默认轮播图片
 */
+ (NSArray *)lunboImageArray;

/**
 *获取启动数据
 */
+ (void)requestStartDataSuccess:(void (^)())success;

/**
 *立即购买
 *buyDic:购买数据
 */
+ (void)rightNowBuy:(NSDictionary *)buyDic num:(NSString *)numStr success:(void (^)(id response))success;

/**
 *更新token
 */
+ (void)updateToken;

/**
 *更新cell控件大小及部分控件间距
 *gCell:需要调整的cell
 *section:当前section，=0表示团购；=1表示直购
 *rate:进度条比例
 */
+ (void)updateCell:(lhGoodsTableViewCell *)gCell section:(NSInteger)section withRate:(CGFloat)rate;

/**
 *更新表格的高度
 *tempTableView：表格
 *oilArray：直购和团购数据
 *maxScrollView：UIScrollView
 */
+ (void)updateTableFrame:(UITableView *)tempTableView oilArray:(NSArray *)oilArray scollView:(UIScrollView *)maxScrollView;

/**
 *倒计时处理及赋值
 *tpLabel:label,label的tag值即为倒计时时间（秒）
 */
+ (void)dealSYWithLabel:(UILabel *)tpLabel;

@end
