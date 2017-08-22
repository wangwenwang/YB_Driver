//
//  CheckPayedOrderPathService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckPayedOrderPathServiceDelegate <NSObject>

@optional
- (void)successWithPayed;

@optional
- (void)failureWithPayed:(NSString *)msg;

@end

@interface CheckPayedOrderPathService : NSObject

/// 已交付订单集合
@property (strong, nonatomic)NSMutableArray *orders;

/// 分页加载，正在加载的页数
@property (assign, nonatomic)int tempPage;

/// 分页加载，已加载完的页数
@property (assign, nonatomic)int page;

@property (weak, nonatomic)id <CheckPayedOrderPathServiceDelegate> delegate;

/**
 * 获取已交付订单数据集合
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)getPayedOrderData:(NSString *)start andEndTime:(NSString *)end;

@end
