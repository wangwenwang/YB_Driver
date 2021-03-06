//
//  PayedOrderService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PayedOrderServiceDelegate <NSObject>

@optional
- (void)successWithPayed;

@optional
- (void)failureWithPayed:(NSString *)msg;

@end

@interface PayedOrderService : NSObject

/// 已交付订单集合
@property (strong, nonatomic)NSMutableArray *orders;

/// 分页加载，正在加载的页数
@property (assign, nonatomic)int tempPage;

/// 分页加载，已加载完的页数
@property (assign, nonatomic)int page;

/// 车牌号码
@property (copy, nonatomic) NSString *TMS_PLATE_NUMBER;

@property (weak, nonatomic)id <PayedOrderServiceDelegate> delegate;


/**
 获取已交付订单数据集合

 @param strPageCount 每页数量
 */
- (void)getPayedOrderData:(NSInteger)strPageCount;

@end
