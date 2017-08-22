//
//  ManangeInformationService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ManangeInformationServiceDelegate <NSObject>

@optional
- (void)success;

@optional
- (void)failure:(NSString *)msg;

@end

@interface ManangeInformationService : NSObject

@property (strong, nonatomic) NSMutableArray *arrM;

@property (weak, nonatomic)id <ManangeInformationServiceDelegate> delegate;

/**
 * 提交订单
 *
 * time: 当天的时间 格式：yyyy-MM-dd
 *
 */
- (void)getManangeInformationData:(NSString *)time;

@end
