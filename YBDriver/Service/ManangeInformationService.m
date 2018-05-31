//
//  ManangeInformationService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "ManangeInformationService.h"
#import "AppDelegate.h"
#import "ManangeInformationModel.h"
#import <AFNetworking.h>

@interface ManangeInformationService () {
    AppDelegate *_app;
}
@end

@implementation ManangeInformationService

- (instancetype)init {
    if(self = [super init]) {
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _arrM = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getManangeInformationData:(NSString *)time {
    NSDictionary *parameters = nil;
    if(_app.user) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      _app.user.IDX, @"strUserId",
                      time, @"chartDate",
                      @"", @"strLicense",
                      nil];
    }
    
    NSLog(@"%@", parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:API_INFORMATION_MANANGE parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        [_arrM removeAllObjects];
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
            NSArray *arrResult = responseObject[@"result"];
            
            for (int i = 0; i < arrResult.count; i++) {
                NSDictionary *dict = arrResult[i];
                ManangeInformationModel *model = [[ManangeInformationModel alloc] init];
                [model setDict:dict];
                [_arrM addObject:model];
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
