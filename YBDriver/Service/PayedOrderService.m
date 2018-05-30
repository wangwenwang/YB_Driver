//
//  PayedOrderService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "PayedOrderService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "OrderModel.h"

@interface PayedOrderService () {
    AppDelegate *_app;
}

@end

@implementation PayedOrderService

- (instancetype)init {
    if(self = [super init]) {
        _app = [[UIApplication sharedApplication] delegate];
        
        /// 已交付订单集合
        _orders = [[NSMutableArray alloc] init];
        
        /// 分页加载，正在加载的页数
        _tempPage = 1;
        
        /// 分页加载，已加载完的页数
        _page = 1;
        
        /// 车牌号码
        _TMS_PLATE_NUMBER = @"";
    }
    return self;
}


- (void)getPayedOrderData:(NSInteger)strPageCount {
    NSDictionary *parameters = nil;
    if(_app.user) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      _app.user.IDX, @"strUserIdx",
                      @"Y", @"strIsPay",
                      @(_tempPage), @"strPage",
                      @(strPageCount), @"strPageCount",
                      @"", @"strLicense",
                      @"ios", @"UUID",
                      _TMS_PLATE_NUMBER, @"strPlateNumber",
                      nil];
    }
    
    __weak typeof(self)wkSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:API_GET_DRIVER_ORDER_LIST parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
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
            [_delegate failureWithPayed:@"请求失败"];
        }
    }];
}

@end
