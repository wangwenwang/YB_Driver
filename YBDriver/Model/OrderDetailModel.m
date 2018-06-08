//
//  OrderDetailModel.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (instancetype)init {
    if(self = [super init]) {
        _PRODUCT_NO = @"";
        _PRODUCT_NAME = @"";
        _ORDER_QTY = @0;
        _ORDER_UOM = @"";
        _ORDER_WEIGHT = @"";
        
        _ORDER_VOLUME = @"";
        _ISSUE_QTY = @"";
        _ISSUE_WEIGHT = @"";
        _ISSUE_VOLUME = @"";
        _PRODUCT_PRICE = @"";
        
        _ACT_PRICE = @"";
        _MJ_PRICE = @"";
        _MJ_REMARK = @"";
        _ORG_PRICE = @0;
        _PRODUCT_URL = @"";
        
        _PRODUCT_TYPE = @"";
        _ORD_J_NO = @"";
        _ORD_FROM_NAME = @"";
        _ORD_REQUEST_ISSUE = @"";
        _ORD_REMARK_CLIENT = @"";
        _ORD_TO_REGION = @"";
        _ORD_QTY = @"";
        _SHIP_FROM_NAME = @"";
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _PRODUCT_NO = dict[@"PRODUCT_NO"];
    _PRODUCT_NAME = dict[@"PRODUCT_NAME"];
    _ORDER_QTY = dict[@"ORDER_QTY"];
    _ORDER_UOM = dict[@"ORDER_UOM"];
    _ORDER_WEIGHT = dict[@"ORDER_WEIGHT"];
    
    _ORDER_VOLUME = dict[@"ORDER_VOLUME"];
    _ISSUE_QTY = dict[@"ISSUE_QTY"];
    _ISSUE_WEIGHT = dict[@"ISSUE_WEIGHT"];
    _ISSUE_VOLUME = dict[@"ISSUE_VOLUME"];
    _PRODUCT_PRICE = dict[@"PRODUCT_PRICE"];
    
    _ACT_PRICE = dict[@"ACT_PRICE"];
    _MJ_PRICE = dict[@"MJ_PRICE"];
    _MJ_REMARK = dict[@"MJ_REMARK"];
    _ORG_PRICE = dict[@"ORG_PRICE"];
    _PRODUCT_URL = dict[@"PRODUCT_URL"];
    
    _PRODUCT_TYPE = dict[@"PRODUCT_TYPE"];
    _ORD_J_NO = dict[@"ORD_J_NO"];
    _ORD_FROM_NAME = dict[@"ORD_FROM_NAME"];
    _ORD_REQUEST_ISSUE = dict[@"ORD_REQUEST_ISSUE"];
    _ORD_REMARK_CLIENT = dict[@"ORD_REMARK_CLIENT"];
    _ORD_TO_REGION = dict[@"ORD_TO_REGION"];
    _ORD_QTY = dict[@"ORD_QTY"];
    _SHIP_FROM_NAME = dict[@"SHIP_FROM_NAME"];
}

@end
