//
//  OrderModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"
#import "StateTackModel.h"

/// 订单信息
@interface OrderModel : NSObject

/// 订单装运时间
@property(copy, nonatomic)NSString *TMS_DATE_LOAD;
/// 订单出库时间
@property(copy, nonatomic)NSString *TMS_DATE_ISSUE;
/// 订单装运编号
@property(copy, nonatomic)NSString *TMS_SHIPMENT_NO;
///
@property(copy, nonatomic)NSString *TMS_FLEET_NAME;
///
@property(copy, nonatomic)NSString *ORD_IDX;

/// 订单 id
@property(copy, nonatomic)NSString *IDX;
/// 订单编号
@property(copy, nonatomic)NSString *ORD_NO;
/// 客户名称
@property(copy, nonatomic)NSString *ORD_TO_NAME;
/// 客户类型
@property(copy, nonatomic)NSString *PARTY_TYPE;
/// 收货人
@property(copy, nonatomic)NSString *ORD_TO_CNAME;
/// 目的地址
@property(copy, nonatomic)NSString *ORD_TO_ADDRESS;
/// 省份
@property(copy, nonatomic)NSString *STATE;
/// 城市
@property(copy, nonatomic)NSString *CITY;
/// 地区
@property(copy, nonatomic)NSString *COUNTY;

/// 订单总数量
@property(copy, nonatomic)NSString *ORD_QTY;
/// 订单总重量
@property(copy, nonatomic)NSString *ORD_WEIGHT;
/// 订单总体积
@property(copy, nonatomic)NSString *ORD_VOLUME;
///
@property(copy, nonatomic)NSString *ORD_ISSUE_QTY;
///
@property(copy, nonatomic)NSString *ORD_ISSUE_WEIGHT;
///
@property(copy, nonatomic)NSString *ORD_ISSUE_VOLUME;

/// 订单流程
@property(copy, nonatomic)NSString *ORD_WORKFLOW;
///
@property(copy, nonatomic)NSString *OMS_SPLIT_TYPE;
///
@property(copy, nonatomic)NSString *OMS_PARENT_NO;
/// 订单状态
@property(copy, nonatomic)NSString *ORD_STATE;
/// 创建时间
@property(copy, nonatomic)NSString *ORD_DATE_ADD;
/// 下单用户
@property(copy, nonatomic)NSString *ADD_CODE;

///
@property(copy, nonatomic)NSString *ORD_REQUEST_ISSUE;
///
@property(copy, nonatomic)NSString *ORD_FROM_NAME;
/// 起始点坐标
@property(copy, nonatomic)NSString *FROM_COORDINATE;
/// 到达点坐标
@property(copy, nonatomic)NSString *TO_COORDINATE;
///
@property(copy, nonatomic)NSString *ORD_REMARK_CLIENT;
/// 司机姓名
@property(copy, nonatomic)NSString *TMS_DRIVER_NAME;

/// 车牌号
@property(copy, nonatomic)NSString *TMS_PLATE_NUMBER;
/// 司机电话
@property(copy, nonatomic)NSString *TMS_DRIVER_TEL;
///
@property(copy, nonatomic)NSString *PAYMENT_TYPE;
///
@property(assign, nonatomic)NSNumber *ORG_PRICE;
///
@property(assign, nonatomic)NSNumber *ACT_PRICE;
///
@property(assign, nonatomic)NSNumber *MJ_PRICE;

///
@property(copy, nonatomic)NSString *ORD_REMARK_CONSIGNEE;
///
@property(copy, nonatomic)NSString *MJ_REMARK;
/// 司机交付标志， yb司机交付状态
@property(copy, nonatomic)NSString *DRIVER_PAY;
///
@property(strong, nonatomic)NSMutableArray *OrderDetails;
///
@property(strong, nonatomic)NSMutableArray *StateTacks;

/// 运输方式
@property(copy, nonatomic)NSString *TMS_TYPE_TRANSPORT;

- (void)setDict:(NSDictionary *)dict;

@end
