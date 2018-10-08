//
//  AppDelegate.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import <BaiduMapAPI_Base/BMKGeneralDelegate.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "LoginViewController.h"
#import <AFHTTPSessionManager.h>


@interface AppDelegate ()<BMKGeneralDelegate>{
    BMKMapManager * _mapManager;
}

//@property (nonatomic, strong)BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (NSMutableArray *)getLocalLocationPointList {
    return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _user = [[UserModel alloc] init];
    
    //地图操作
    _mapManager = [[BMKMapManager alloc] init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"q6NlGGmrhxUApRsoVoGfqWuN8oNa0DdP"  generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图加载失败！");
    }else {
        NSLog(@"百度地图加载成功！");
    }
    
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setBarTintColor:YBGreen];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ad_pic_3.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    
    //界面生成
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
//#ifdef DEBUG
//    LoginViewController *l = [[LoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:l];
    
//    [[NSUserDefaults standardUserDefaults] setValue:@"13460871234" forKey:udUserName];
//    [[NSUserDefaults standardUserDefaults] setValue:@"871234" forKey:udPassWord];
    
//    [[NSUserDefaults standardUserDefaults] setValue:@"13802670327" forKey:udUserName];
//    [[NSUserDefaults standardUserDefaults] setValue:@"670327" forKey:udPassWord];
    
//        [[NSUserDefaults standardUserDefaults] setValue:@"13726027405" forKey:udUserName];
//        [[NSUserDefaults standardUserDefaults] setValue:@"123456" forKey:udPassWord];
    
    
//    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
////    [_window setRootViewController:nav];
//    [l success];
//#else
    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
    [_window setRootViewController:welcomeVC];
//#endif
    
    [_window makeKeyAndVisible];
    //13660778263
    //13460871234
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- BMKGeneralDelegate
// 百度地图获取网络连接状态
- (void)onGetNetworkState:(int)iError {
    if(iError == 0) {
        NSLog(@"联网成功");
    }else {
        NSLog(@"联网失败，错误代码：Error:%d", iError);
    }
}

// 百度地图key是否正确能够连接
- (void)onGetPermissionState:(int)iError {
    if (iError == 0) {
        NSLog(@"授权成功");
    }else{
        NSLog(@"授权失败，错误代码：Error:%d", iError);
    }
}

@end
