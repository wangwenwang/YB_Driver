//
//  RegisterService.m
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/4.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import "RegisterService.h"
#import <AFNetworking.h>

@implementation RegisterService

- (void)registerLM:(NSString *)userName andPsw:(NSString *)psw {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"user" : userName,
                                 @"pwd" : psw,
                                 @"strLicense" : @""
                                 };
    NSLog(@"参数：%@", parameters);
    
    [manager POST:API_Register parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        
        int _type = [responseObject[@"type"] intValue];
        NSString *msg = responseObject[@"msg"];
        if(_type == 1) {
            
            if([_delegate respondsToSelector:@selector(successOfRegister:)]) {
                
                [_delegate successOfRegister:msg];
            }
        }else {
            
            if([_delegate respondsToSelector:@selector(failureOfRegister:)]) {
                
                [_delegate failureOfRegister:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        
        if([_delegate respondsToSelector:@selector(failureOfRegister:)]) {
            
            [_delegate failureOfRegister:@"请求失败"];
        }
    }];
}

@end
