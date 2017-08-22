//
//  ChangePasswordViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/5.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordService.h"
#import "NSString+Trim.h"
#import "Tools.h"
#import <MBProgressHUD.h>

@interface ChangePasswordViewController ()<ChangePasswordServiceDelatate>

/// 原密码
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;

/// 新密码
@property (weak, nonatomic) IBOutlet UITextField *aField;

/// 重复确认新密码
@property (weak, nonatomic) IBOutlet UITextField *bField;

/// 提交按钮
- (IBAction)commitOnclick:(UIButton *)sender;

/// 更改密码的业务类
@property (strong, nonatomic) ChangePasswordService *changePswService;

@end

@implementation ChangePasswordViewController

#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        _changePswService = [[ChangePasswordService alloc] init];
        _changePswService.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    self.title = @"修改密码";
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

#pragma mark -- 功能函数
- (IBAction)commitOnclick:(UIButton *)sender {
    NSString *oldPsw = [_oldPasswordField.text trim];
    NSString *newPsw = [_aField.text trim];
    NSString *reNewPsw = [_bField.text trim];
    if(![oldPsw isEqualToString:@""]) {
        if(![newPsw isEqualToString:@""]) {
            if(![reNewPsw isEqualToString:@""]) {
                if([newPsw isEqualToString:reNewPsw]) {
                    if(reNewPsw.length >= 6) {
                        //判断连接状态
                        if([Tools isConnectionAvailable]) {
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [_changePswService changePassword:oldPsw andNewPassword:reNewPsw];
                        }else {
                            [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
                        }
                    }else {
                        [Tools showAlert:self.view andTitle:@"新密码不能小于六位数字或字母！"];
                    }
                }else {
                    [Tools showAlert:self.view andTitle:@"两次输入新密码不同！"];
                }
            } else {
                [Tools showAlert:self.view andTitle:@"请再次输入新密码！"];
            }
        }else {
            [Tools showAlert:self.view andTitle:@"请输入新密码！"];
        }
    }else {
        [Tools showAlert:self.view andTitle:@"请输入原密码！"];
    }
}

#pragma mark -- ChangePasswordServiceDelatate
- (void)success {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:@"修改密码成功！"];
}

- (void)failure {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:@"修改密码失败！"];
}
@end
