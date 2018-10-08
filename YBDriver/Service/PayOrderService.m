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

- (void)geocoderToLocation:(NSString *)address {
    
    NSString *a = @"http://api.map.baidu.com/geocoder/v2/?address=";
    NSString *b = @"&output=json&ak=dUz4AKCXgwSrbGOYRNTyy8Mya0tg6b1c&mcode=com.kaidongyuan.Geocoder";
    NSString *url = [NSString stringWithFormat:@"%@%@%@", a, address, b];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
        int status = [responseObject[@"status"] intValue];
        @try {
            
            NSDictionary *dicResult = responseObject[@"result"];
            int comprehension = [dicResult[@"comprehension"] intValue];
            int confidence = [dicResult[@"confidence"] intValue];
            NSString *level = dicResult[@"level"];
            int precise = [dicResult[@"precise"] intValue];
            NSDictionary *dicLocation = dicResult[@"location"];
            float lat = [dicLocation[@"lat"] floatValue];
            float lng = [dicLocation[@"lng"] floatValue];
            
            if([_delegate respondsToSelector:@selector(successGeo:)]) {
                
                [_delegate successGeo:CLLocationCoordinate2DMake(lat, lng)];
                NSLog(@"转换坐标完毕");
                NSLog(@"%@", address);
                NSLog(@"%f, %f", lng, lat);
            }
        } @catch (NSException *exception) {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

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

- (void)payOrderWithPicture:(NSString *)idx andOrderPayState:(NSString *)state andImage1Str:(NSString *)str1 andImage2Str:(NSString *)str2 andToLng:(NSNumber *)toLng andToLat:(NSNumber *)toLat andCurrentLng:(NSNumber *)currentLng andCurrentLat:(NSNumber *)currentLat{
    NSString *s = @"";
    if([state isEqualToString:@"N"]) {
        s = @"S";
    } else {
        s = @"Y";
    }
    
    currentLat = @(22.71011111111111);
    currentLng = @(113.8584311111111);
    
    NSLog(@"strOrderIdx:%@", idx);
    NSLog(@"currentLat:%@", currentLat);
    NSLog(@"currentLng:%@", currentLng);
    NSLog(@"toLat:%@", toLat);
    NSLog(@"toLng:%@", toLng);
    NSLog(@"AutographFile:%@", s);
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                idx, @"strOrderIdx",
                                str1, @"PictureFile1",
                                str2, @"PictureFile2",
                                s, @"AutographFile",
                                @"", @"strLicense",
                                @"ios", @"UUID",
                                toLng, @"toLng",
                                toLat, @"toLat",
                                currentLng, @"currentLng",
                                currentLat, @"currentLat",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:API_PAY_ORDER1 parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
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
