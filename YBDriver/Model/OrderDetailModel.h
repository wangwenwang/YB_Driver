//
//  OrderDetailModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject
/// 物料编码
@property(copy, nonatomic)NSString *PRODUCT_NO;
/// 物料名称
@property(copy, nonatomic)NSString *PRODUCT_NAME;
@property(assign, nonatomic)NSNumber *ORDER_QTY;
@property(copy, nonatomic)NSString *ORDER_UOM;
@property(copy, nonatomic)NSString *ORDER_WEIGHT;

@property(copy, nonatomic)NSString *ORDER_VOLUME;
/// 发货数量
@property(copy, nonatomic)NSString *ISSUE_QTY;
@property(copy, nonatomic)NSString *ISSUE_WEIGHT;
@property(copy, nonatomic)NSString *ISSUE_VOLUME;
@property(copy, nonatomic)NSString *PRODUCT_PRICE;

@property(copy, nonatomic)NSString *ACT_PRICE;
@property(copy, nonatomic)NSString *MJ_PRICE;
@property(copy, nonatomic)NSString *MJ_REMARK;
@property(assign, nonatomic)NSNumber *ORG_PRICE;
@property(copy, nonatomic)NSString *PRODUCT_URL;


@property(copy, nonatomic)NSString *PRODUCT_TYPE;
/// 订单编号
@property(copy, nonatomic)NSString *ORD_J_NO;
/// 发货仓库编号
@property(copy, nonatomic)NSString *ORD_FROM_NAME;
/// 计划发运日期
@property(copy, nonatomic)NSString *ORD_REQUEST_ISSUE;
/// 收货客户
@property(copy, nonatomic)NSString *ORD_REMARK_CLIENT;
/// 销售区域
@property(copy, nonatomic)NSString *ORD_TO_REGION;
/// 订单数量
@property(copy, nonatomic)NSString *ORD_QTY;

- (void)setDict:(NSDictionary *)dict;

@end
