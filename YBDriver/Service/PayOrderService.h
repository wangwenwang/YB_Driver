//
//  PayOrderService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/8.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PayOrderServiceDelegate <NSObject>

@optional
- (void)success;

@optional
- (void)failure:(NSString *)msg;

@end

@interface PayOrderService : NSObject

@property (weak, nonatomic)id <PayOrderServiceDelegate> delegate;

/**
 * 将 uiimage 对象转换成 base64 字符串
 *
 * image: 需要转换的图片
 *
 * return 转换完对应图片的 base64 字符串
 */
- (NSString *)changeImageToString:(UIImage *)image;

/**
 * 提交订单
 *
 * orderIdx: 订单的 idx
 *
 * image1Str: 现场图片1的 base64 字符串
 *
 * image2Str: 现场图片2的 base64 字符串
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)payOrderWithPicture:(NSString *)idx andOrderPayState:(NSString *)state andImage1Str:(NSString *)str1 andImage2Str:(NSString *)str2;

@end
