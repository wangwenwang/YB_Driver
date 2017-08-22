//
//  MyBMKLocationService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/20.
//  Copyright © 2016年 凯东源. All rights reserved.
//

@protocol MyBMKLocationServiceDelegate <NSObject>

@optional
- (void)myDidUpdateBMKUserLocation:(BMKUserLocation *)userLocation;

@end

@interface MyBMKLocationService : BMKLocationService

@property (weak, nonatomic) id<MyBMKLocationServiceDelegate> myDelegate;

@property (strong, nonatomic) BMKLocationService *locationService;

@end
