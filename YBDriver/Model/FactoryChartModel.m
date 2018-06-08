//
//  FactoryChartModel.m
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/1.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import "FactoryChartModel.h"

@implementation FactoryChartModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _ship_from_name = @"";
        _QtyTotal = 0;
        _Ndeliver = 0;
        _Adeliver = 0;
        _Arrive = 0;
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _ship_from_name = dict[@"ship_from_name"] ? dict[@"ship_from_name"] : _ship_from_name;
    _QtyTotal = [dict[@"QtyTotal"] intValue];
    _Ndeliver = [dict[@"Ndeliver"] intValue];
    _Adeliver = [dict[@"Adeliver"] intValue];
    _Arrive = [dict[@"Arrive"] intValue];
}

@end
