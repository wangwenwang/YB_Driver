//
//  ManangeInformationModel.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "ManangeInformationModel.h"

@implementation ManangeInformationModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tms_fllet_name = @"";
        _QtyTotal = 0;
        _Ndeliver = 0;
        _Adeliver = 0;
        _Arrive = 0;
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _tms_fllet_name = dict[@"tms_fllet_name"];
    _QtyTotal = [dict[@"QtyTotal"] intValue];
    _Ndeliver = [dict[@"Ndeliver"] intValue];
    _Adeliver = [dict[@"Adeliver"] intValue];
    _Arrive = [dict[@"Arrive"] intValue];
}

@end
