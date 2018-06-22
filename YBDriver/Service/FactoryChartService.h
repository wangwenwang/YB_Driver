//
//  FactoryChartService.h
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/1.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FactoryChartServiceDelegate <NSObject>

@optional
- (void)successOfFactoryChart:(NSArray *)factorys;

@optional
- (void)failureOfFactoryChart:(NSString *)msg;

@end

@interface FactoryChartService : NSObject

@property (weak, nonatomic)id <FactoryChartServiceDelegate> delegate;

/**
 * 工厂管理信息数据
 *
 * startDate: 开始时间 格式：yyyy-MM-dd
 *
 * startDate: 结束时间 格式：yyyy-MM-dd
 */
- (void)getFactoryChart:(NSString *)startDate andEedDate:(NSString *)endDate;

@end
