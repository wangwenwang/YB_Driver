//
//  LocationService.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/18.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "LocationService.h"
#import "LocationContineTimeModel.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "Tools.h"

@interface LocationService () {
    /// 上传缓存位置点信息集合是每次上传的数量
    int _updataCacheLocationsCount;
    AppDelegate *_app;
}

@end

@implementation LocationService

- (instancetype)init {
    if(self = [super init]) {
        _updataLocationSpanTimeMin = 0.2;
        _isNeedChangeUpdataLocationSpanTime = NO;
        _updataCacheLocationsCount = 20;
        _app = [[UIApplication sharedApplication] delegate];//单例初始化方式
    }
    return self;
}

/**
 * 上传位置信息
 *
 * location: 位置信息 CLLocationCoordinate2D
 */
- (void)updataLocation : (CLLocationCoordinate2D) location {
    NSMutableArray *array = [self getLocalLocationPointList];
    NSLog(@"本地保存的位置点数据数量：%lu", (unsigned long)array.count);
    if(array.count > 0) {
        NSLog(@"本地有缓存数据，先保存到本地在上传");
        [self saveLocationPointInLocal:location];
        [self updataCacheLocations];
    }else {//本地无保存位置点信息，直接上传
        NSLog(@"本地无保存位置点信息，直接上传");
        [self updataOneLocation:location];
    }
}

/**
 * 上传单个位置点
 *
 * location: 需要上传的点
 */
- (void)updataOneLocation:(CLLocationCoordinate2D)location {
    NSLog(@"上传单个位置点");
    __weak typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _app.user.IDX, @"strUserIdx",
                                @(location.longitude), @"cordinateX",
                                @(location.latitude), @"cordinateY",
                                @"ios默认code地址", @"address",
                                [Tools getCurrentDate], @"date",
                                @"", @"strLicense",
                                nil];
    
    NSLog(@"上传单点josn:%@", parameters);
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager POST:API_UPDATA_LOCATION parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        double type = [responseObject[@"type"] doubleValue];
        if(type >= 1) {//发送成功，并且需要更改上传定位时间间隔
            NSLog(@"上传成功");
            if(weakSelf.updataLocationSpanTimeMin != type) {//需要更改上传时间间隔
                NSLog(@"需要更改上传时间间隔:更改为%f分钟", type);
                weakSelf.updataLocationSpanTimeMin = type;
                weakSelf.isNeedChangeUpdataLocationSpanTime = YES;
            }
            if([_delegate respondsToSelector:@selector(uploadOneLocationSuccess)]) {
                [_delegate uploadOneLocationSuccess];
            }
        }else {//发送失败
            [weakSelf saveLocationPointInLocal:location];
            if([_delegate respondsToSelector:@selector(uploadOneLocationFailure)]) {
                [_delegate uploadOneLocationFailure];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        [weakSelf saveLocationPointInLocal:location];
    }];
}

/// 上传缓存的位置点信息集合
- (void)updataCacheLocations {
    NSLog(@"上传缓存的位置点信息集合");
    NSMutableArray *array = [self getLocalLocationPointList];
    if(array.count > _updataCacheLocationsCount) {
        //超过单次上传数量，分批上传，每次上传20条数据（默认）
        NSLog(@"超过单次上传数量，分批上传");
        NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
        for(int i = 0; i < _updataCacheLocationsCount; i++) {
            [arrTemp addObject:array[i]];
        }
        [self updataLocations:arrTemp];
    }else {//小于单次上传数量，直接上传
        NSLog(@"小于单次上传数量，直接上传");
        [self updataLocations:array];
    }
}

/**
 * 上传位置点集合
 *
 * locations: 需要上传的位置点集合
 */
- (void)updataLocations:(NSMutableArray *)locations {
    NSLog(@"上传位置点集合");
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _app.user.IDX, @"strUserIdx",
                                [self changeLocationContineTimeListToJsonString:locations], @"strJson",
                                @"", @"strLicense",
                                nil];
    
    NSLog(@"上传集合点josn:%@", parameters);
    
    __weak typeof(self) weakSelf = self;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:API_UPDATA_LOCATION_LIST parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        double _type = [responseObject[@"type"] doubleValue];
        if(_type >= 1) {//上传位置点信息集合成功
            [weakSelf deleteUpdataLocationsFromLocal];
            NSMutableArray *array = [weakSelf getLocalLocationPointList];
            if(array.count > 0) {
                NSLog(@"本地还有位置点缓存数据，继续上传缓存本地位置点信息");
                [weakSelf updataCacheLocations];
            }
            if(_type > 1) {//发送成功，并且需要更改上传定位时间间隔
                if(weakSelf.updataLocationSpanTimeMin != _type) {//需要更改上传时间间隔
                    NSLog(@"需要更改上传时间间隔:更改为%f分钟", _type);
                    weakSelf.updataLocationSpanTimeMin = _type;
                    weakSelf.isNeedChangeUpdataLocationSpanTime = YES;
                }
            }
            if([_delegate respondsToSelector:@selector(uploadMoreLocationSuccess)]) {
                [_delegate uploadMoreLocationSuccess];
            }
        }else {
            NSLog(@"异常，上传位置接口返回type小于1");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        NSLog(@"上传单个点位置信息失败！");
        if([_delegate respondsToSelector:@selector(uploadMoreLocationFailure)]) {
            [_delegate uploadMoreLocationFailure];
        }
    }];
    
}

/// 从本地保存的位置信息中删除上传完的位置信息集合
- (void)deleteUpdataLocationsFromLocal {
    NSLog(@"从本地保存的位置信息中删除上传完的位置信息集合");
    NSMutableArray *array = [self getLocalLocationPointList];
    NSMutableArray *newLocalLocationList = [[NSMutableArray alloc] init];
    if(newLocalLocationList.count > 20) {
        for (int i = _updataCacheLocationsCount; i < array.count; i++) {
            LocationContineTimeModel *location = array[i];
            //更改本地位置点数据中的 id 后台排序用
            location.ID = [NSString stringWithFormat:@"%d", ([location.ID intValue] - _updataCacheLocationsCount)];
            [newLocalLocationList addObject:array[i]];
        }
    }
    NSString *locationContineTimeListStr = [self changeLocationContineTimeListToJsonString:newLocalLocationList];
    [[NSUserDefaults standardUserDefaults] setValue:locationContineTimeListStr forKey:@"locationList"];
}

/**
 * 获取本地保存的位置点集合信息
 *
 * return 本地保存的位置点集合
 */
- (NSMutableArray *)getLocalLocationPointList {
    NSLog(@"获取本地保存的位置点集合信息");
    NSLog(@"判断是否有本地缓存");
    NSString *locationListData = [[NSUserDefaults standardUserDefaults] stringForKey:@"locationList"];
    
    if(locationListData) {
        NSLog(@"本地有缓存数据");
        NSMutableArray *locationContineTimeList = [self changeJsonStringToLocationContineTimeList:locationListData];
        NSLog(@"本地有缓存数据：%@", locationContineTimeList);
        return locationContineTimeList;
    }
    NSLog(@"本地无缓存数据");
    return [[NSMutableArray alloc] init];
}

/**
 * 将位置点信息保存到本地
 *
 * location: 位置信息 CLLocationCoordinate2D
 */
- (void)saveLocationPointInLocal:(CLLocationCoordinate2D)location {
    NSLog(@"保存位置点信息到本地");
    LocationContineTimeModel *locationModel = [self changeCLLocationCoordinated2DToLocationContineTime:location];
    NSMutableArray *array = [self getLocalLocationPointList];
    [array addObject:locationModel];
    
    //再次更改本地位置点数据中的 id ，确保 id 的值是顺序的，后台排序用
    NSInteger locationContineTimeCount = array.count;
    for (int i = 0; i < locationContineTimeCount; i++) {
        LocationContineTimeModel *model;
        model = array[i];
        model.ID = [NSString stringWithFormat:@"%d", i];
    }
    
    NSString *locationContineTimeListStr = [self changeLocationContineTimeListToJsonString:array];
    [[NSUserDefaults standardUserDefaults] setValue:locationContineTimeListStr forKey:@"locationList"];
}

/**
 * 将百度地图的位置点信息转换成本地的 LocationContineTime
 *
 * location: 需要转换的位置点 CLLocationCoordinate2D
 *
 * return LocationContineTime
 */
- (LocationContineTimeModel *)changeCLLocationCoordinated2DToLocationContineTime:(CLLocationCoordinate2D)location {
    NSLog(@"将百度地图的位置点信息转换成本地的 LocationContineTime");
    LocationContineTimeModel *locationContineTime = [[LocationContineTimeModel alloc] init];
    NSLog(@"--- 查询本地缓存ID开始 ---");
    locationContineTime.ID = [NSString stringWithFormat:@"%lu", (unsigned long)[[self getLocalLocationPointList] count]];
    NSLog(@"--- 查询本地缓存ID结束 ---");
    locationContineTime.USERIDX = _app.user.IDX;
    locationContineTime.ADDRESS = @"默认code地址";
    locationContineTime.CORDINATEX = @(location.longitude);
    locationContineTime.CORDINATEY = @(location.latitude);
    locationContineTime.TIME = [Tools getCurrentDate];
    return locationContineTime;
}

/**
 * 将json格式的字符串转换成位置信息点集合
 *
 * str: 需要转换的位置点集合的 json 格式的 string
 *
 * return 转换完的位置点信息集合
 */
- (NSMutableArray *)changeJsonStringToLocationContineTimeList:(NSString *)str {
    NSLog(@"将json格式的字符串转换成位置信息点集合");
    LocationContineTimeModel *locationModel;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDictionary *dict = [Tools dictionaryWithJsonString:str];
    
    NSMutableArray *arrResult = dict[@"result"];
    
    for (int i = 0; i < arrResult.count; i++) {
        NSDictionary *rc = arrResult[i];
        locationModel = [[LocationContineTimeModel alloc] init];
        locationModel.ID = rc[@"ID"];
        locationModel.USERIDX = rc[@"USERIDX"];
        locationModel.CORDINATEX = rc[@"CORDINATEX"];
        locationModel.CORDINATEY = rc[@"CORDINATEY"];
        locationModel.ADDRESS = rc[@"ADDRESS"];
        locationModel.TIME = rc[@"TIME"];
        [array addObject:locationModel];
    }
    return array;
}

/**
 * 将位置信息点集合转换成 string
 *
 * list: 需要转换的位置点集合
 *
 * return 转换完的 json 格式的 string
 */
- (NSString *)changeLocationContineTimeListToJsonString:(NSMutableArray *)array {
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        LocationContineTimeModel *model = array[i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              model.ID, @"ID",
                              model.USERIDX, @"USERIDX",
                              model.CORDINATEX, @"CORDINATEX",
                              model.CORDINATEY, @"CORDINATEY",
                              model.ADDRESS, @"ADDRESS",
                              model.TIME, @"TIME",
                              nil];
        [arrM addObject:dict];
    }
    
    NSDictionary *arrReturn = [NSDictionary dictionaryWithObject:arrM forKey:@"result"];
    NSString *returnStr = [Tools JsonStringWithDictonary:arrReturn];
    
    return returnStr;
}

@end
