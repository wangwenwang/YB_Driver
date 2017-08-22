//
//  PayOrderViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/8.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PayOrderService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Compress.h"
#import "Tools.h"
#import <MBProgressHUD.h>
#import "OrderDetailViewController.h"
#import "UnPayedOrderViewController.h"

@interface PayOrderViewController ()<UIAlertViewDelegate, UIImagePickerControllerDelegate, PayOrderServiceDelegate, UINavigationControllerDelegate> {
    
    /// 交付订单业务类
    PayOrderService *_service;
    
    /// 图片1
    UIImage *_image1;
    
    /// 图片2
    UIImage *_image2;
    
    /// 选择图片的角标，1 图片1，2 图片2
    int _currentUpdataPictureIndex;
    
    /// 显示选择上传图片方式的对话框
    UIAlertView *_showUpdataPictureWayAlert;
    
    /// 判断是否有图片
    BOOL _isHaveImageOne;
    BOOL _isHaveImageTwo;
}

/// 图片一覆盖的button N:卸货车照，S:车头牌照
@property (weak, nonatomic) IBOutlet UIButton *imageOneButton;

/// 添加图片按钮一 N:车头照片，S:车头牌照
@property (weak, nonatomic) IBOutlet UIButton *addPictureButtonOne;

/// 图片二覆盖的button N:车头照片，S:签单回执
@property (weak, nonatomic) IBOutlet UIButton *imageTwoButton;

/// 添加图片按钮二 N:卸货车照，S:签单回执
@property (weak, nonatomic) IBOutlet UIButton *addPictureButtonTwo;

/// 底部右侧按钮 N:确认到达，S:确认交付
@property (weak, nonatomic) IBOutlet UIButton *butttomRightButton;

/// 取消交付，回到订单详情界面
- (IBAction)cancelPayOnclick:(UIButton *)sender;

/// 图片一上覆盖的按钮控件点击事件 N:卸货车照，S:车头牌照
- (IBAction)onImageOneButtonClick:(UIButton *)sender;

/// 添加图片一按钮
- (IBAction)addPictureOneBtnOnclick:(UIButton *)sender;

/// 图片二上覆盖的按钮控件点击事件 N:车头照片，S:签单回执
- (IBAction)onImageTwoButtonClick:(UIButton *)sender;

/// 添加图片二按钮
- (IBAction)addPictureTwoBtnOnclick:(UIButton *)sender;

/// 底部右侧按钮点击事件 N:提交到达照片，S:提交交付照片
- (IBAction)commitPayOnclick:(UIButton *)sender;

@property (strong, nonatomic) OrderDetailViewController *orderDetailVC;

@property (strong, nonatomic) UnPayedOrderViewController *unPayedOrderVC;

@end

@implementation PayOrderViewController

#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    self = [super init];
    if (self) {
        _currentUpdataPictureIndex = 1;
        _showUpdataPictureWayAlert = [[UIAlertView alloc] init];
        _service = [[PayOrderService alloc] init];
        _service.delegate = self;
        _isHaveImageOne = NO;
        _isHaveImageTwo = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    self.title = @"交付订单";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
    if([_orderPayState isEqualToString:@"N"]) {
        [_addPictureButtonOne setTitle:@"车头照片" forState:UIControlStateNormal];
        [_addPictureButtonTwo setTitle:@"卸货车照" forState:UIControlStateNormal];
        [_butttomRightButton setTitle:@"确认到达" forState:UIControlStateNormal];
    }else if([_orderPayState isEqualToString:@"S"]) {
        [_addPictureButtonOne setTitle:@"车头牌照" forState:UIControlStateNormal];
        [_addPictureButtonTwo setTitle:@"签单回执" forState:UIControlStateNormal];
        [_butttomRightButton setTitle:@"确认交付" forState:UIControlStateNormal];
    }else {
        nil;
    }
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

#pragma mark -- 事件
- (IBAction)onImageOneButtonClick:(UIButton *)sender {
    _currentUpdataPictureIndex = 1;
    
    if(_isHaveImageOne) {
        [Tools showImage:_imageOneButton.imageView];
    } else {
        [self showUpdataPictureWay];
    }
}

- (IBAction)addPictureOneBtnOnclick:(UIButton *)sender {
    _currentUpdataPictureIndex = 1;
    [self showUpdataPictureWay];
}

- (IBAction)onImageTwoButtonClick:(UIButton *)sender {
    _currentUpdataPictureIndex = 2;
    
    if(_isHaveImageTwo) {
        [Tools showImage:_imageOneButton.imageView];
    } else {
        [self showUpdataPictureWay];
    }
}

- (IBAction)addPictureTwoBtnOnclick:(UIButton *)sender {
    _currentUpdataPictureIndex = 2;
    [self showUpdataPictureWay];
}

- (IBAction)cancelPayOnclick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commitPayOnclick:(UIButton *)sender {
    if(!_isHaveImageOne) {
        [Tools showAlert:self.view andTitle:@"请上上传现场图片1再提交！"];
        return;
    }
    if(!_isHaveImageTwo) {
        [Tools showAlert:self.view andTitle:@"请上上传现场图片2再提交！"];
        return;
    }
    
    UIImage *image1 = _imageOneButton.imageView.image;
    UIImage *image2 = _imageTwoButton.imageView.image;
    
    NSString *image1Str = [_service changeImageToString:image1];
    NSString *image2Str = [_service changeImageToString:image2];
    
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_service payOrderWithPicture:_orderIDX andOrderPayState:_orderPayState andImage1Str:image1Str andImage2Str:image2Str];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
    }
}

#pragma mark -- 功能函数
/// 显示选择上传图片方式的对话框
- (void)showUpdataPictureWay {
    _showUpdataPictureWayAlert.title = @"拍照上传";
    [_showUpdataPictureWayAlert addButtonWithTitle:@"取消"];
    [_showUpdataPictureWayAlert addButtonWithTitle:@"确定"];
    _showUpdataPictureWayAlert.cancelButtonIndex = 0;
    _showUpdataPictureWayAlert.delegate = self;
    [_showUpdataPictureWayAlert show];
}

#pragma mark -- UIAlertViewDelegate
/**
 * 显示对话框提示用户信息
 *
 * message: 显示的信息
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1://使用相机拍摄现场图片
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
                picker.delegate = self;
                picker.allowsEditing = NO;
                [self presentViewController:picker animated:YES completion:^{
                    nil;
                }];
            }else {
                /// 提示信息对话框
                UIAlertView *alert = [[UIAlertView alloc] init];
                alert.message = @"相机功能不可用！";
                [alert addButtonWithTitle:@"确定"];
                alert.cancelButtonIndex = 0;
                [alert show];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if(image != nil) {
        NSData *data = [image compressImage:image andMaxLength:1024*100];
        if(data != nil) {
            image = [UIImage imageWithData:data];
        }
    }
    
    if(image != nil) {
//        image = [image waterMarkedImage:@"测试"];
        switch (_currentUpdataPictureIndex) {
            case 1://添加的是现场图片1
                [_imageOneButton setImage:image forState:UIControlStateNormal];
                _isHaveImageOne = YES;
                break;
                
            case 2://添加的是现场图片2
                [_imageTwoButton setImage:image forState:UIControlStateNormal];
                _isHaveImageTwo = YES;
                break;
                
            default:
                break;
        }
    }
}

/// PopRoot 后自动刷新UnPayedOrderViewController的mytableView
- (void)unPayedOrderVcIsRequestDataYES {
    NSArray *arrNavVc = self.navigationController.viewControllers;
    NSArray *arrTabBarVc = nil;
    
    UITabBarController *tbVC = nil;
    _orderDetailVC = nil;
    _unPayedOrderVC = nil;
    
    for (int i = 0; i < arrNavVc.count; i++) {
        UIViewController *navVC = arrNavVc[i];
        if([navVC isMemberOfClass:[UITabBarController class]]) {
            tbVC = (UITabBarController *)navVC;
            arrTabBarVc = tbVC.viewControllers;
            for (int j = 0; j < arrTabBarVc.count; j++) {
                UIViewController *tabbarVC = arrTabBarVc[j];
                if([tabbarVC isMemberOfClass:[UnPayedOrderViewController class]]) {
                    _unPayedOrderVC = (UnPayedOrderViewController *)tabbarVC;
                    break;
                }
            }
        }else if([navVC isMemberOfClass:[OrderDetailViewController class]]) {
            _orderDetailVC = (OrderDetailViewController *)navVC;
        }
    }
    
    _unPayedOrderVC.isRequestData = YES;
}

#pragma mark -- PayOrderServiceDelegate
/// 提交订单成功回调
- (void)success {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:@"交付成功"];
    [self unPayedOrderVcIsRequestDataYES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 * 提交订单失败回调方法
 *
 * message: 显示的信息
 */
- (void)failure:(NSString *)msg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg ? msg : @"交付失败"];
}

@end
