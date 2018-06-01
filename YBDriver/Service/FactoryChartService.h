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
 * 获取报表数据
 *
 * time: 当天的时间 格式：yyyy-MM-dd
 *
 */
- (void)getFactoryChart:(NSString *)time;

@end
