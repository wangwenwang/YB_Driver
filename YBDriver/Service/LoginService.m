//
//  LoginService.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "LoginService.h"
#import <AFNetworking.h>
#import "Tools.h"
#import "LocationContineTimeModel.h"
#import "AppDelegate.h"
#import "NSObject+JSONCategories.h"

@interface LoginService () {
    AppDelegate *_app;
}

@end

@implementation LoginService

- (instancetype)init {
    if(self = [super init]) {
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];//单例初始化方式
    }
    return self;
}


- (void)login:(NSString *)userName andPsw:(NSString *)psw {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"strUserName" : userName,
                                 @"strPassword" : psw,
                                 @"strLicense" : @"",
                                 @"UUID" : @"ios"
                                 };
    
//    parameters = @{
//                   @"strLicense" : @"",
//                   @"chartDate" : @"",
//                   @"strUserId" : @"13"
//                   };
    
//    parameters = @{
//                       @"strLicense" : @"",
//                       @"user" : @"13800138000",
//                       @"pwd" : @"123456"
//                       };
    // 2018-05-30
    NSLog(@"参数：%@", parameters);
    
    // API_LOGIN
    // @"http://218.17.181.244:8081/api/GetCestbonFleetCount"
    // @"http://218.17.181.244:8081/api/GetFleetReport"
//     @"http://218.17.181.244:8081/api/YibRegister"
    [manager POST:API_LOGIN parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int _type = [responseObject[@"type"] intValue];
        NSString *_msg = responseObject[@"msg"];
        if(_type == 1) {
            if([_delegate respondsToSelector:@selector(success)]) {
                NSArray *arrResult = responseObject[@"result"];
                NSDictionary *dictResult = arrResult[0];
                _app.user.USER_NAME = dictResult[@"USER_NAME"];
                _app.user.USER_TYPE = dictResult[@"USER_TYPE"];
                _app.user.IDX = dictResult[@"IDX"];
                _app.user.USER_CODE = userName;
                [_delegate success];
            }
        }else {
            if([_delegate respondsToSelector:@selector(failure:)]) {
                [_delegate failure:_msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        if([_delegate respondsToSelector:@selector(failure:)]) {
            [_delegate failure:@"请求失败"];
        }
    }];
}

@end
