//
//  ChangePasswordService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/5.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "ChangePasswordService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

@implementation ChangePasswordService

- (void)changePassword:(NSString *)oldpwd andNewPassword:(NSString *)newpwd {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSString *userName = app.user.USER_CODE;
    NSLog(@"%@", userName);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userName, @"strUserName",
                                oldpwd, @"strPassword",
                                newpwd, @"strNewPassword",
                                @"", @"strLicense",
                                @"ios", @"UUID",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:API_CHANGE_PASSWORD parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            if([_delegate respondsToSelector:@selector(success)]) {
                [_delegate success];
            }
        }else {
            if([_delegate respondsToSelector:@selector(failure)]) {
                [_delegate failure];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        NSLog(@"修改密码失败！");
        if([_delegate respondsToSelector:@selector(failure)]) {
            [_delegate failure];
        }
    }];
}

@end
