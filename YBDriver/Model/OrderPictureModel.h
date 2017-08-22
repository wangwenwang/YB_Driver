//
//  OrderPictureModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 订单签名或图片信息
@interface OrderPictureModel : NSObject

/// 图片类型为客户签名
@property (copy, nonatomic) NSString *AUTOGRAPH;

///图片类型为现场图片
@property (copy, nonatomic) NSString *PICTURE;

/// 最终交货图片
@property (copy, nonatomic) NSString *PICTURE2;


///
@property (copy, nonatomic) NSString *IDX;

///
@property (copy, nonatomic) NSString *PRODUCT_IDX;

/// 图片路径
@property (copy, nonatomic) NSString *PRODUCT_URL;

/// 标记图片时签名还是现场图片 "Autograph"为签名  "pricture"为现场图片
@property (copy, nonatomic) NSString *REMARK;


- (void)setDict:(NSDictionary *)dict;

@end
