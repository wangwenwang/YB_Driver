//
//  MyBMKLocationService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/20.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "MyBMKLocationService.h"

@interface MyBMKLocationService ()<BMKLocationServiceDelegate> {
    
}

@end

@implementation MyBMKLocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = self;
        //启动LocationService
        [_locationService startUserLocationService];
        //设置定位精度
        _locationService.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        _locationService.distanceFilter = YBLocationDistance;
        if(SystemVersion > 9.0) {
            _locationService.allowsBackgroundLocationUpdates = YES;
        }
        _locationService.pausesLocationUpdatesAutomatically = NO;
    }
    return self;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if([_myDelegate respondsToSelector:@selector(myDidUpdateBMKUserLocation:)]) {
        [_myDelegate myDidUpdateBMKUserLocation:userLocation];
    }
}

@end
