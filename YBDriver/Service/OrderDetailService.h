//
//  OrderDetailService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@protocol OrderDetailServiceDelegate <NSObject>

@optional
- (void)success;

@optional
- (void)failure:(NSString *)msg;

@end

@interface OrderDetailService : NSObject

@property (weak, nonatomic)id <OrderDetailServiceDelegate> delegate;

/// 订单详情信息
@property (strong, nonatomic) OrderModel *order;

/**
 * 获取全部订单数据集合
 *
 * orderIDX: 订单的 idx
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)getOrderData:(NSString *)idx;

@end
