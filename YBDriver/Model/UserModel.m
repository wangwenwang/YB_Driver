//
//  UserModel.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init {
    if(self = [super init]) {
        _USER_NAME = @"";
        _USER_TYPE = @"";
        _USER_CODE = @"";
        _IDX = @"";
    }
    return self;
}

@end
