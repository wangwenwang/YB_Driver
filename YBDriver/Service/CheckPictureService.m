//
//  CheckPictureService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "CheckPictureService.h"
#import <AFNetworking.h>
#import "OrderPictureModel.h"

@implementation CheckPictureService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrPictures = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getOrderAutographAndPicture:(NSString *)idx {
    NSDictionary *parameters   = [NSDictionary dictionaryWithObjectsAndKeys:
                      idx, @"strOrderIdx",
                      @"", @"strLicense",
                      @"ios", @"UUID",
                      nil];
    
    __weak typeof(self)wkSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:API_GET_ORDER_PICTURE parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            NSArray *arrResult = responseObject[@"result"];
            [_arrPictures removeAllObjects];
            for (int i = 0; i < arrResult.count; i++) {
                OrderPictureModel *model = [[OrderPictureModel alloc] init];
                [model setDict:arrResult[i]];
                [wkSelf.arrPictures addObject:model];
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
