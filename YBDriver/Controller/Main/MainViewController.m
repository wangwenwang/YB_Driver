//
//  MainViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "MainViewController.h"
#import <SDCycleScrollView.h>
#import "OrderPathCheckViewController.h"
#import "LocationService.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "MyBMKLocationService.h"

#define alertModel 3

@interface MainViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, MyBMKLocationServiceDelegate, LocationServiceDelegate, CLLocationManagerDelegate> {
    
    /// 百度地图定位服务
    BMKLocationService *_locationService;
    
    // 记录用户最近坐标
    CLLocationCoordinate2D _location;
    
    // 用户位置是否有更新
    BOOL _isUpdataLocation;
    
    // 百度地图定位服务
    MyBMKLocationService *_localService;
    
    //业务类
    LocationService *_myLocationService;
    
    /// 测试用来查看上传多少条记录，无实用功能
    int _i;
    
    AppDelegate *_app;
}

/// 图片轮播控件容器
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

/// 百度地图控件
@property (weak, nonatomic) IBOutlet BMKMapView *baiduMapView;

/// 进入我的位置
- (IBAction)myLocationOnclick:(UIButton *)sender;

/// 进入货物路线场景
- (IBAction)checkOrderPathOnclick:(UIButton *)sender;

// 弹出3个定位受权（包括iOS11下始终允许）
@property (strong, nonatomic) CLLocationManager *reqAuth;

// 定位延迟，始终化1，允许定位后为0。 解决iOS11下无法弹出始终允许定位权限(与原生请求定位权限冲突)
@property (assign, nonatomic) unsigned PositioningDelay;

@end

@implementation MainViewController

#pragma mark - 生命周期
- (instancetype)init {
    
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"menu_index_unselected"];
        
        _baiduMapView.zoomLevel = 16;
        
        // 13800138000
        
        if([Tools isLocationServiceOpen]) {
            
            _PositioningDelay = 0;
        } else {
            _PositioningDelay = 1;
        }
        
        // 解决iOS11下无法弹出始终允许定位权限(与原生请求定位权限冲突)
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            sleep(_PositioningDelay);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _locationService = [[BMKLocationService alloc] init];
            });
        });
        

        _myLocationService = [[LocationService alloc] init];
        _myLocationService.delegate = self;
        
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    [self.view layoutIfNeeded];
    
    // 本地加载图片的轮播器
    SDCycleScrollView *_cycleScrollView1 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_cycleScrollView.frame)) imageNamesGroup:@[@"ad_pic_0.jpg", @"ad_pic_1.jpg", @"ad_pic_2.jpg", @"ad_pic_3.jpg"]];
    [self.view addSubview:_cycleScrollView1];
    
    [self startLocationService];
    [self startUpdataLocationTimer];
    
    //判断定位权限  延迟检查，因为用户首次选择需要时间
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(7);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([Tools isLocationServiceOpen]) {
                NSLog(@"应用拥有定位权限");
            } else {
                [Tools skipLocationSettings];
            }
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(_PositioningDelay);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _locationService.delegate = self;
        });
    });
    _baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_baiduMapView viewWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);

    self.navigationController.navigationBar.topItem.title = @"首页";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        usleep(800000);
        dispatch_async(dispatch_get_main_queue(), ^{

            _baiduMapView.userTrackingMode = BMKUserTrackingModeFollow;
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);

    _locationService.delegate = nil;
    _baiduMapView.delegate = nil; // 不用时，置nil
    [_baiduMapView viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

#pragma mark - 点击事件
- (IBAction)myLocationOnclick:(UIButton *)sender {
    
    _baiduMapView.userTrackingMode = BMKUserTrackingModeFollow;
    if([Tools isConnectionAvailable]) {
        
        NSLog(@"有网络");
    }else {
        
        NSLog(@"没网络");
    }
}

- (IBAction)checkOrderPathOnclick:(UIButton *)sender {
    
    OrderPathCheckViewController *orderVC = [[OrderPathCheckViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - 功能函数
// 上传位置信息
- (void)updataLocation:(NSTimer *)timer {
    
    NSLog(@"准备上传位置点信息！%d", _i);
    _i++;
    
    CLLocationCoordinate2D _lo = _location;
    if(_lo.latitude != 0 & _lo.longitude != 0)  {
        if(_isUpdataLocation) {
            //判断连接状态
            if([Tools isConnectionAvailable]) {
                [self alert:@"位置更改，上传"];
                [_myLocationService updataLocation:_lo];
            }else {
                [self alert:@"位置更改，保存"];
                [_myLocationService saveLocationPointInLocal:_lo];
            }
            NSLog(@"%s: %f   %f", __func__, _location.latitude, _location.longitude);
            _isUpdataLocation = NO;
        }
    }
}

// 开启间隔时间上传位置点计时器
- (void)startUpdataLocationTimer {
    if(_localTimer != nil) {
        [_localTimer invalidate];
        NSLog(@"关闭定时上传位置点信息计时器");
    }
    _localTimer = [NSTimer scheduledTimerWithTimeInterval:_myLocationService.updataLocationSpanTimeMin * 60 target:self selector:@selector(updataLocation:) userInfo:nil repeats:YES];
    NSLog(@"开启定时上传位置点信息计时器");
}

- (void)startLocationService {
    
    // 弹出定位授权窗口
    _reqAuth = [[CLLocationManager alloc] init];
    _reqAuth.delegate = self;
    _reqAuth.distanceFilter = 100;
    _reqAuth.pausesLocationUpdatesAutomatically = NO;
    if(SystemVersion > 9.0) {

        _reqAuth.allowsBackgroundLocationUpdates = YES;
    }
    [_reqAuth requestAlwaysAuthorization];
    [_reqAuth startUpdatingLocation];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{

            //初始化BMKLocationService
            _localService = [[MyBMKLocationService alloc] init];
            _localService.myDelegate = self;
        });
    });
}

#pragma mark - MyBMKLocationServiceDelegate 后台上传位置点
- (void)myDidUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    _location = userLocation.location.coordinate;
    _app.currLocation = userLocation.location.coordinate;
    _isUpdataLocation = YES;
    if(_myLocationService.isNeedChangeUpdataLocationSpanTime) {
        NSLog(@"更改上传位置点间隔时间：更改为:%f", _myLocationService.updataLocationSpanTimeMin);
        [self startUpdataLocationTimer];
        _myLocationService.isNeedChangeUpdataLocationSpanTime = NO;
    }else {
        NSLog(@"位置更改，不操作");
        //        [self alert:@"位置更改，不操作"];
    }
}

#pragma mark - BMKLocationServiceDelegate 前台显示
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
    [_baiduMapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    [_baiduMapView updateLocationData:userLocation];
}

#pragma mark - BMKMapViewDelegate 前台显示
// 百度地图初始化完成
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
    [_locationService startUserLocationService ];
    // 先关闭显示的定位图层
    _baiduMapView.showsUserLocation = NO;
    // 设置定位的状态
    _baiduMapView.userTrackingMode = BMKUserTrackingModeFollow;
    // 显示定位图层
    _baiduMapView.showsUserLocation = YES;
    // 设置定位精度
    _locationService.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // 指定最小距离更新(米)，默认：kCLDistanceFilterNone
    _locationService.distanceFilter = 1;
//    _baiduMapView.userTrackingMode = BMKUserTrackingModeFollow;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@", error);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启位置定位权限" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    });
}

#pragma mark - MyBMKLocationServiceDelegate
// 上传单点成功回调
- (void)uploadOneLocationSuccess {
    
    [self alert:@"上传单点成功"];
}

// 上传单点失败回调
- (void)uploadOneLocationFailure {
    
    [self alert:@"上传单点失败"];
}

// 上传集合点成功回调
- (void)uploadMoreLocationSuccess {
    
    [self alert:@"上传集合点成功"];
}

// 上传集合点失败回调
- (void)uploadMoreLocationFailure {
    
    [self alert:@"上传集合点失败"];
}

// 提示
- (void)alert:(NSString *)title {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(alertModel == 1) {
            
            [Tools showAlert:self.view andTitle:title];
        }else if(alertModel == 2) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
            
            nil;
        }
    });
}

@end
