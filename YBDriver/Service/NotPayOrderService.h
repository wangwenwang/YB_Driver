//
//  NotPayOrderService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotPayOrderServiceDelegate <NSObject>

@optional
- (void)successWithNotPay;

@optional
- (void)failureWithNotPay:(NSString *)msg;

@end

@interface NotPayOrderService : NSObject

/// 未交付订单集合
@property (strong, nonatomic) NSMutableArray *orders;

/// 分页加载，正在加载的页数
@property (assign, nonatomic) int tempPage;

/// 分页加载，已加载完的页数
@property (assign, nonatomic) int page;

/// 是否下拉刷新
@property (assign, nonatomic) BOOL isDropDown;

/**
 * 获取未交付订单数据集合
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)getNotPayOrderData;

@property (weak, nonatomic) id <NotPayOrderServiceDelegate> delegate;

@end
