//
//  ManangeInformationModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManangeInformationModel : NSObject

/// 物流商名称
@property (copy, nonatomic) NSString *tms_fllet_name;

/// 发货总数
@property (assign, nonatomic) int QtyTotal;

/// 未交付货数
@property (assign, nonatomic) int Ndeliver;

/// 已交付货数
@property (assign, nonatomic) int Adeliver;

/// 已到达货数
@property (assign, nonatomic) int Arrive;

- (void)setDict:(NSDictionary *)dict;

@end
