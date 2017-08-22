//
//  ChangePasswordService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/5.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChangePasswordServiceDelatate <NSObject>

@optional
- (void)success;

@optional
- (void)failure;

@end

@interface ChangePasswordService : NSObject

- (void)changePassword:(NSString *)oldpwd andNewPassword:(NSString *)newpwd;

@property (weak, nonatomic)id <ChangePasswordServiceDelatate> delegate;

@end
