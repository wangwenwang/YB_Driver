//
//  RegisterService.h
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/4.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegisterServiceDelegate <NSObject>

@optional
- (void)successOfRegister:(NSString *)msg;

@optional
- (void)failureOfRegister:(NSString *)msg;

@end

@interface RegisterService : NSObject


@property (weak, nonatomic)id <RegisterServiceDelegate> delegate;


/**
 注册

 @param userName 用户名
 @param psw 密码
 */
- (void)registerLM:(NSString *)userName andPsw:(NSString *)psw;

@end
