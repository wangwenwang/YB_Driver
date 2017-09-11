//
//  Tools.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//请求API
//方式：POST
//类型：application/x-www-form-urlencoded
+ (NSString *)postAPI:(NSString *)urlStr andString:(NSString *)postStr;

/*!
 * @brief 把字典转换成JSON字符串
 * @param dict 字典
 * @return 返回JSON字符串
 */
+ (NSString *)JsonStringWithDictonary:(NSDictionary *)dict;

/// 提示  参数:View    NSString
+ (void)showAlert:(NSObject *)view andTitle:(NSString *)title;

/// 网络状态
+ (BOOL)isConnectionAvailable;

/**
 * 获取手机当前时间
 *
 * return 手机当前时间 "yyy-MM-dd HH:mm:ss"
 */
+ (NSString *)getCurrentDate;

/**
 * 获取订单交付状态
 *
 * str： 后台返回的订单交付状态码，英文字符
 *
 * return 订单交付状态，中文字符
 */
+ (NSString *)getOrderPayState:(NSString *)str;

/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

/// 筛选出最小的数
+ (NSInteger)getMinNumber:(NSInteger)a andB:(NSInteger)b;

/// 淡入效果的转场动画
+ (void)setRootViewController:(UIWindow *)window andViewController:(UIViewController *)vc;

/// 判断是否管理员和物流商
+ (BOOL)isADMINorWLS;


+ (void)skipLocationSettings;


+ (void)skipNotifiationSettings;

+ (BOOL)isLocationServiceOpen;

/**
 提示带时间参数
 
 @param view  父窗口
 @param title 标题
 @param time  停留时间
 */
+ (void)showAlert:(nullable UIView *)view andTitle:(nullable NSString *)title andTime:(NSTimeInterval)time;

@end
