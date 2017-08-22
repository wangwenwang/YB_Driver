//
//  LoginViewController.h
//  newDriver
//
//  Created by 凯东源 on 16/8/29.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

// 计时器，固定间隔时间上传位置信息
@property (strong, nonatomic) NSTimer *localTimer;

@end
