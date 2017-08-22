//
//  CheckPathService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "CheckPathService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "LocationModel.h"

@interface CheckPathService () {
    
}

@end

@implementation CheckPathService

- (instancetype)init {
    if(self = [super init]) {
        _orderLocations = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 * 获取订单线路位置点集合
 *
 * orderIdx: 订单的 idx
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)getOrderLocaltions:(NSString *)idx {
    NSDictionary *parameters = nil;
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      idx, @"strOrderId",
                      @"", @"strLicense",
                      @"ios", @"UUID",
                      nil];
    
    
    __weak typeof(self)wkSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:API_GET_ORDER_LOCATIONS parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            NSArray *arrResult = responseObject[@"result"];
            for (int i = 0; i < arrResult.count; i++) {
                LocationModel *location = [[LocationModel alloc] init];
                [location setDict:arrResult[i]];
                location.CORDINATEY = [arrResult[i][@"CORDINATEY"] doubleValue];
                location.CORDINATEX = [arrResult[i][@"CORDINATEX"] doubleValue];
                [wkSelf.orderLocations addObject:location];
                NSLog(@"%@", location);
            }
            if([_delegate respondsToSelector:@selector(success)]) {
                [_delegate success];
            }
        }else {
            NSString *msg = responseObject[@"msg"];
            if([_delegate respondsToSelector:@selector(failure:)]) {
                [_delegate failure:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        if([_delegate respondsToSelector:@selector(failure:)]) {
            [_delegate failure:nil];
        }
    }];
}

@end
