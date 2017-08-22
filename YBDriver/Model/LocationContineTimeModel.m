//
//  LocationContineTimeModel.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "LocationContineTimeModel.h"

@implementation LocationContineTimeModel

- (instancetype)init {
    if(self = [super init]) {
        _ID = @"";
        _USERIDX = @"";
        _CORDINATEX = @0;
        _CORDINATEY = @0;
        _ADDRESS = @"";
        _TIME = @"";
    }
    return self;
}

@end
