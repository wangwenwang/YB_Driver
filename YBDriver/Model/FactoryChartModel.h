//
//  FactoryChartModel.h
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/1.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryChartModel : NSObject

/// 工厂名称
@property (copy, nonatomic) NSString *ORD_FROM_NAME;

/// 发货总数
@property (assign, nonatomic) long long QtyTotal;

/// 未交付货数
@property (assign, nonatomic) long long Ndeliver;

/// 已交付货数
@property (assign, nonatomic) long long Adeliver;

/// 已到达货数
@property (assign, nonatomic) long long Arrive;

- (void)setDict:(NSDictionary *)dict;

@end
