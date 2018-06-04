//
//  RegisterViewController.m
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/4.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterService.h"
#import <MBProgressHUD.h>
#import "Tools.h"

@interface RegisterViewController ()<RegisterServiceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameF;

@property (weak, nonatomic) IBOutlet UITextField *pwdF;

@property (strong, nonatomic) RegisterService *service;

@end

@implementation RegisterViewController

- (instancetype)init {
    
    if(self = [super init]) {
        
        _service = [[RegisterService alloc] init];
        _service.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

// UITextField代理方法，是否允许输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
    
    //不能输入空格
    if ([string isEqualToString: @" "]){
        
        [Tools showAlert:self.view andTitle:@"不能输入空格"];
        return NO;
    }
    
    if (textField == self.userNameF){
        
        if (![Tools isNumber:string]){
            
            [Tools showAlert:self.view andTitle:@"手机号必须是数字"];
            return NO;
        }
    }else if (textField == self.pwdF){
        
        // 密码不作限制
    }
    
    // 用户名限制11位数
    if (textField == self.userNameF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 事件

- (IBAction)registerOnclick {
    
    // 是否手机号码
    BOOL isMobileNumber = [Tools isMobileNumber:_userNameF.text];
    
    if(![_userNameF.text isEqualToString:@""]) {
        
        if(![_pwdF.text isEqualToString:@""]) {
            
            if(isMobileNumber) {
                
                NSString *userName = _userNameF.text;
                NSString *pwd = _pwdF.text;
                [_service registerLM:userName andPsw:pwd];
            } else {
                
                [Tools showAlert:self.view andTitle:@"手机号码格式不正确"];
            }
        } else {
            
            [Tools showAlert:self.view andTitle:@"密码不能为空"];
        }
    }else {
        
        [Tools showAlert:self.view andTitle:@"手机号码不能为空"];
    }
}

- (IBAction)backOnclick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - RegisterServiceDelegate

- (void)successOfRegister:(NSString *)msg {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        usleep(1700000);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSUserDefaults standardUserDefaults] setValue:_userNameF.text forKey:udUserName];
            [[NSUserDefaults standardUserDefaults] setValue:_pwdF.text forKey:udPassWord];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}


- (void)failureOfRegister:(NSString *)msg {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg];
}

@end
