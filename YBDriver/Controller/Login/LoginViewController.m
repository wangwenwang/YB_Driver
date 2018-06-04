//
//  LoginViewController.m
//  newDriver
//
//  Created by 凯东源 on 16/8/29.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextField.h"
#import "LoginService.h"
#import <MBProgressHUD.h>
#import "Tools.h"
#import "NSString+Trim.h"
#import "MainViewController.h"
#import "UnPayedOrderViewController.h"
#import "PayedOrderViewController.h"
#import "MineViewController.h"
#import "AppDelegate.h"
#import "ManangeInformationViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<LoginServiceDelegate>{
    
    //业务类
    LoginService *_loginService;
    
    AppDelegate *_app;
}

@property (weak, nonatomic) IBOutlet LoginTextField *userNameT;
@property (weak, nonatomic) IBOutlet LoginTextField *pswT;
- (IBAction)loginBtn:(UIButton *)sender;

@end

@implementation LoginViewController

#pragma mark - 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        _loginService = [[LoginService alloc] init];
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
    
    self.navigationController.navigationBar.topItem.title = @"登陆";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //填充帐号密码
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:udUserName];
    _userNameT.text = name;
    NSString *psw = [[NSUserDefaults standardUserDefaults] valueForKey:udPassWord];
    _pswT.text = psw;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    [self.view layoutIfNeeded];
    
    //帐号
    UIImageView *uImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(_userNameT.frame), CGRectGetHeight(_userNameT.frame))];
    uImage.image = [UIImage imageNamed:@"ic_username"];
    _userNameT.leftViewMode = UITextFieldViewModeAlways;
    _userNameT.leftView = uImage;
    
    //密码
    UIImageView *pswImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(_pswT.frame), CGRectGetHeight(_pswT.frame))];
    pswImage.image = [UIImage imageNamed:@"ic_password"];
    _pswT.leftViewMode = UITextFieldViewModeAlways;
    _pswT.leftView = pswImage;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

#pragma mark - 事件
- (IBAction)loginBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *_name = [_userNameT.text trim];
    NSString *_psw = [_pswT.text trim];
    
    if(![_name isEqualToString:@""]) {
        if(![_psw isEqualToString:@""]) {
            if([Tools isConnectionAvailable]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _loginService.delegate = self;
                //13460871234    871234
                [_loginService login:_userNameT.text andPsw:_pswT.text];
            }else {
                [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
            }
        }else {
            [Tools showAlert:self.view andTitle:@"请输入密码！"];
        }
    }else {
        [Tools showAlert:self.view andTitle:@"请输入用户名！"];
    }
}

- (IBAction)registerOnclick {
    
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - LoginServiceDelegate
- (void)success {
    
    NSLog(@"登陆成功");
    
    [[NSUserDefaults standardUserDefaults] setValue:[_userNameT.text trim] forKey:udUserName];
    [[NSUserDefaults standardUserDefaults] setValue:[_pswT.text trim] forKey:udPassWord];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //tabbar导航
    UITabBarController *tbaVC = [[UITabBarController alloc] init];
    tbaVC.tabBar.tintColor = YBGreen;
    
    //子控制器
    MainViewController *mainVC = [[MainViewController alloc] init];
    PayedOrderViewController *payVC = [[PayedOrderViewController alloc] init];
    MineViewController *mineVC = [[MineViewController alloc] init];
    UnPayedOrderViewController *unPayVC = [[UnPayedOrderViewController alloc] init];
    tbaVC.viewControllers = @[mainVC, unPayVC, payVC, mineVC];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbaVC];
    
    //切换根控制器
    [UIView transitionWithView:_app.window duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_app.window setRootViewController:nav];
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (void)failure {
    
    NSLog(@"登陆失败");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:@"登陆失败"];
}

@end
