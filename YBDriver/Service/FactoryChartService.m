//
//  FactoryChartService.m
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/1.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import "FactoryChartService.h"
#import "FactoryChartModel.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

@interface FactoryChartService () {
    
    AppDelegate *_app;
}
@end

@implementation FactoryChartService

- (instancetype)init {
    if(self = [super init]) {
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)getFactoryChart:(NSString *)time {
    NSDictionary *parameters = nil;
    if(_app.user) {
        parameters = @{
                       @"strUserId":_app.user.IDX,
                       @"chartDate":time,
                       @"strLicense":@""
                       };
    }
    NSLog(@"%@", parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:API_FACTORY_CHART parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            NSArray *arrResult = responseObject[@"result"];

            NSMutableArray *muArrM = [[NSMutableArray alloc] init];
            for (int i = 0; i < arrResult.count; i++) {
                NSDictionary *dict = arrResult[i];
                FactoryChartModel *m = [[FactoryChartModel alloc] init];
                [m setDict:dict];
                [muArrM addObject:m];
            }

            if([_delegate respondsToSelector:@selector(successOfFactoryChart:)]) {
                [_delegate successOfFactoryChart:[muArrM copy]];
            }
        }else {
            NSString *msg = responseObject[@"msg"];
            if([_delegate respondsToSelector:@selector(failureOfFactoryChart:)]) {
                [_delegate failureOfFactoryChart:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        if([_delegate respondsToSelector:@selector(failureOfFactoryChart:)]) {
            [_delegate failureOfFactoryChart:nil];
        }
    }];
}

@end
