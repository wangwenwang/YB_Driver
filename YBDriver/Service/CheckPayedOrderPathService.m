//
//  CheckPayedOrderPathService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "CheckPayedOrderPathService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "OrderModel.h"

@interface CheckPayedOrderPathService () {
    AppDelegate *_app;
}

@end

@implementation CheckPayedOrderPathService

- (instancetype)init {
    if(self = [super init]) {
        _app = [[UIApplication sharedApplication] delegate];//单例初始化方式
        _orders = [[NSMutableArray alloc] init];
        _tempPage = 1;
        _page = 1;
    }
    return self;
}

- (void)getPayedOrderData:(NSString *)start andEndTime:(NSString *)end {
    NSDictionary *parameters = nil;
    if(_app.user) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      _app.user.IDX, @"strUserIdx",
                      @"Y", @"strIsPay",
                      @(_tempPage), @"strPage",
                      @"20", @"strPageCount",
                      start, @"startDate",
                      end, @"endDate",
                      @"", @"strLicense",
                      @"ios", @"UUID",
                      nil];
    }
    
    __weak typeof(self)wkSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:API_GET_DRIVER_ORDER_DATE parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        
        if(wkSelf.tempPage == 1) {
            [wkSelf.orders removeAllObjects];
        }
        
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            NSArray *arrResult = responseObject[@"result"];
            for (int i = 0; i < arrResult.count; i++) {
                NSDictionary *dictResult = arrResult[i];
                OrderModel *orderM = [[OrderModel alloc] init];
                [orderM setDict:dictResult];
                [wkSelf.orders addObject:orderM];
            }
            wkSelf.page = wkSelf.tempPage;
            if([_delegate respondsToSelector:@selector(successWithPayed)]) {
                [_delegate successWithPayed];
            }
        }else {
            NSString *msg = responseObject[@"msg"];
            if([_delegate respondsToSelector:@selector(failureWithPayed:)]) {
                [_delegate failureWithPayed:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        NSLog(@"获取已交付订单失败");
        if([_delegate respondsToSelector:@selector(failureWithPayed:)]) {
            [_delegate failureWithPayed:nil];
        }
    }];
}

@end
