//
//  OrderPictureModel.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "OrderPictureModel.h"

@implementation OrderPictureModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _AUTOGRAPH = @"Autograph";
        _PICTURE = @"pricture";
        _PICTURE2 = @"pictureS";
        
        _IDX = @"";
        _PRODUCT_IDX = @"";
        _PRODUCT_URL = @"";
        _REMARK = @"";
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _IDX = dict[@"IDX"];
    _PRODUCT_IDX = dict[@"PRODUCT_IDX"];
    _PRODUCT_URL = dict[@"PRODUCT_URL"];
    _REMARK = dict[@"REMARK"];
}

@end
