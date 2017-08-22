//
//  LoginService.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginServiceDelegate <NSObject>

@optional
- (void)success;

@optional
- (void)failure;

@end

@interface LoginService : NSObject


@property (weak, nonatomic)id <LoginServiceDelegate> delegate;

/**
 * 登陆
 *
 * userName: 用户名
 *
 * password: 用户登陆密码
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)login:(NSString *)userName andPsw:(NSString *)psw;

@end
