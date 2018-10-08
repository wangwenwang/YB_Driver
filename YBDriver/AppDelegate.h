//
//  AppDelegate.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UserModel *user;

// 记录用户最近坐标
@property (assign, nonatomic) CLLocationCoordinate2D currLocation;

//@property (assign, nonatomic) BOOL isPresen;

@end

