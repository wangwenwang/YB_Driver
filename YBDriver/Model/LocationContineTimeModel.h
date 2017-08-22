//
//  LocationContineTimeModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 位置点信息包含时间
@interface LocationContineTimeModel : NSObject

/// 递增序列，用于给后台插入数据库排序用
@property (copy, nonatomic) NSString *ID;

/// 保存位置用户的 id
@property (copy, nonatomic) NSString *USERIDX;

/// 位置纬度
@property (strong, nonatomic) NSNumber *CORDINATEX;

/// 位置经度
@property (strong, nonatomic) NSNumber *CORDINATEY;

/// 位置的地址
@property (copy, nonatomic) NSString *ADDRESS;

/// 位置创建的时间
@property (copy, nonatomic) NSString *TIME;

@end
