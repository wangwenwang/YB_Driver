//
//  OrderDetailService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "OrderDetailService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "OrderDetailModel.h"

@interface OrderDetailService () {
    AppDelegate *_app;
}

@end

@implementation OrderDetailService

- (instancetype)init {
    if(self = [super init]) {
        _app = [[UIApplication sharedApplication] delegate];
        _order = [[OrderModel alloc] init];
    }
    return self;
}


/**
* 获取全部订单数据集合
*
* orderIDX: 订单的 idx
*
* httpresponseProtocol: 网络请求协议
*/
- (void)getOrderData:(NSString *)idx {
    NSDictionary *parameters = nil;
    if(_app.user) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      idx, @"strTmsOrderId",
                      @"", @"strLicense",
                      @"ios", @"UUID",
                      nil];
    }
    
    __weak typeof(self)wkSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:API_GET_ORDER_TMSINFO parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            NSArray *arrResult = responseObject[@"result"];
            OrderModel *or = [[OrderModel alloc] init];
            if(arrResult.count > 0) {
                NSDictionary *dictResult = arrResult[0];
                if(dictResult.count > 0) {
                    NSDictionary *dict = dictResult[@"order"];
                    [or setDict:dict];
                }
                NSMutableArray *ordersDictArrM = arrResult[0][@"order"][@"OrderDetails"];
                NSMutableArray *ordersArrM = [[NSMutableArray alloc] init];
                for (int i = 0; i < ordersDictArrM.count; i++) {
                    OrderDetailModel *detail = [[OrderDetailModel alloc] init];
                    [detail setDict:ordersDictArrM[i]];
                    [ordersArrM addObject:detail];
                }
                or.OrderDetails = ordersArrM;
                wkSelf.order = or;
                NSLog(@"");
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

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
