//
//  CheckPictureService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckPictureServiceDelegate <NSObject>

@optional
- (void)success;

@optional
- (void)failure:(NSString *)msg;

@end

@interface CheckPictureService : NSObject

@property (strong, nonatomic) NSMutableArray *arrPictures;

@property (weak, nonatomic)id <CheckPictureServiceDelegate> delegate;

/**
 * 获取订单的电子签名和现场图片信息集合
 *
 * orderIDX: 订单的 idx
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)getOrderAutographAndPicture:(NSString *)idx;

/**
 * 获取图片的 url 路径
 *
 * remarkInt: 图片标记 （0 客户签名， 1 现场图片1， 2,3 现场图片2）
 *
 * return: 对应图片的网络 url
 */

@end
