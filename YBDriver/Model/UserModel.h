//
//  UserModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/// 用户名
@property (nonatomic, copy)NSString *USER_NAME;

/// 用户类型，后台返回
@property (nonatomic, copy)NSString *USER_TYPE;

/// 用户
@property (nonatomic, copy)NSString *USER_CODE;

/// 用户唯一标识符，后台返回
@property (nonatomic, copy)NSString *IDX;

@end
