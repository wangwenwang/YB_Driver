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
 * 物流管理信息数据
 *
 * startDate: 开始时间 格式：yyyy-MM-dd
 *
 * startDate: 结束时间 格式：yyyy-MM-dd
 */
- (void)getManangeInformationData:(NSString *)startDate andEedDate:(NSString *)endDate;

@end
