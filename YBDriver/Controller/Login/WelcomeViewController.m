//
//  WelcomeViewController.m
//  newDriver
//
//  Created by 凯东源 on 16/8/29.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Tools.h"

@interface WelcomeViewController () {
    AppDelegate *_app;
}

@property (weak, nonatomic) IBOutlet UIImageView *ybImage;


@end

@implementation WelcomeViewController
#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    self = [super init];
    if (self) {
        _app = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    _ybImage.alpha = 0;
    [_ybImage.layer setAffineTransform:CGAffineTransformMakeScale(0, 0)];
    [_ybImage.layer setAffineTransform:CGAffineTransformMakeRotation(-2)];
    
    // 设置动画，动画完成跳转到登陆界面
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _ybImage.alpha = 1.0;
        [_ybImage.layer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
        [_ybImage.layer setAffineTransform:CGAffineTransformMakeRotation(0)];
    } completion:^(BOOL finished) {
        [self loginOnclick];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
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


typedef void (^Animation)(void);

#pragma mark -- 点击事件
- (void)loginOnclick {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    [Tools setRootViewController:_app.window andViewController:nav];
}

@end
