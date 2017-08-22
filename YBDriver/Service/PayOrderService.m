//
//  PayOrderService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/8.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "PayOrderService.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

@implementation PayOrderService

- (NSString *)changeImageToString:(UIImage *)image {
    if(image) {
        NSData *imageData = UIImagePNGRepresentation(image);
        if(imageData) {
            return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

- (void)payOrderWithPicture:(NSString *)idx andOrderPayState:(NSString *)state andImage1Str:(NSString *)str1 andImage2Str:(NSString *)str2 {
    NSString *s = @"";
    if([state isEqualToString:@"N"]) {
        s = @"S";
    } else {
        s = @"Y";
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  idx, @"strOrderIdx",
                  str1, @"PictureFile1",
                  str2, @"PictureFile2",
                  s, @"AutographFile",
                  @"", @"strLicense",
                  @"ios", @"UUID",
                  nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:API_PAY_ORDER parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        int type = [responseObject[@"type"] intValue];
        if(type == 1) {
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
