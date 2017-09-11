//
//  NotPayOrderService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "NotPayOrderService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "OrderModel.h"

@interface NotPayOrderService () {
    AppDelegate *_app;
}

@end

@implementation NotPayOrderService

- (instancetype)init {
    if(self = [super init]) {
        _orders = [[NSMutableArray alloc] init];
        _tempPage = 1;
        _page = 1;
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _isDropDown = NO;
        
    }
    return self;
}


- (void)getNotPayOrderData:(NSUInteger)strPageCount {
    NSDictionary *parameters = nil;
    if(_app.user) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      _app.user.IDX, @"strUserIdx",
                      @"N", @"strIsPay",
                      @(_tempPage), @"strPage",
                      @(strPageCount), @"strPageCount",
                      @"", @"strLicense",
                      @"ios", @"UUID",
                      nil];
    }
    __weak typeof(self)wkSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:API_GET_DRIVER_ORDER_LIST parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int _type = [responseObject[@"type"] intValue];
        if(_type == 1) {
            if(wkSelf.tempPage == 1) {
                [wkSelf.orders removeAllObjects];
            }
            NSArray *arrResult = responseObject[@"result"];
            for (int i = 0; i < arrResult.count; i++) {
                NSDictionary *dictResult = arrResult[i];
                OrderModel *orderM = [[OrderModel alloc] init];
                [orderM setDict:dictResult];
                [wkSelf.orders addObject:orderM];
            }
            wkSelf.page = wkSelf.tempPage;
            if([_delegate respondsToSelector:@selector(successWithNotPay)]) {
                [_delegate successWithNotPay];
            }
        }else {
            if(_isDropDown) {
                [wkSelf.orders removeAllObjects];
            }
            NSString *msg = responseObject[@"msg"];
            if([_delegate respondsToSelector:@selector(failureWithNotPay:)]) {
                [_delegate failureWithNotPay:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取未交付订单失败！");
        NSLog(@"请求失败---%@", error);
        if([_delegate respondsToSelector:@selector(failureWithNotPay:)]) {
            [_delegate failureWithNotPay:@"请求失败"];
        }
    }];
    
}

@end
