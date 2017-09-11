//
//  UITableView+NoDataPrompt.h
//  CMDriver
//
//  Created by 凯东源 on 17/2/20.
//  Copyright © 2017年 城马联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoDataPrompt)

/// 添加TableView 无订单
- (void)noOrder:(NSString *)title;

/// 添加TableView 无车辆
- (void)noTruck:(NSString *)title;

/// 添加TableView 无司机
- (void)noDriver:(NSString *)title;

/// 添加TableView 无货源
- (void)noSupply:(NSString *)title;

/// 移除TableView 无数据提示
- (void)removeNoDataPrompt;

@end
