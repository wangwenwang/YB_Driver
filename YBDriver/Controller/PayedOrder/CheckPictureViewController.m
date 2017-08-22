//
//  CheckPictureViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "CheckPictureViewController.h"
#import "CheckPictureService.h"
#import "OrderPictureModel.h"
#import "Tools.h"
#import "PhotoBroswerVC.h"
#import <MBProgressHUD.h>

@interface CheckPictureViewController ()<CheckPictureServiceDelegate>

/// 查看订单线路的业务类
@property (strong, nonatomic) CheckPictureService *service;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

- (IBAction)btnOnclick:(UIButton *)sender;

@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) UIImage *image3;
@property (strong, nonatomic) UIImage *image4;

@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation CheckPictureViewController

#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    self = [super init];
    if (self) {
        _service = [[CheckPictureService alloc] init];
        _service.delegate = self;
        _images = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    self.title = @"查看图片";
    
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        [_service getOrderAutographAndPicture:_orderIDX];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
    }
    
    for (int i = 0; i < 4; i++) {
        //缓冲中...
        [_images addObject:[UIImage imageNamed:@"activitying"]];
    }
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
/**
 * 设置 imageview 的图片
 *
 * imageUrl: 图片的网络路径
 */
- (UIImage *)setImageFieldImage:(NSString *)imageUrl {
    UIImage *image = nil;
    if(imageUrl) {
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *imageData;
        if(url) {
            imageData = [NSData dataWithContentsOfURL:url];
        }
        if(imageData) {
            image = [UIImage imageWithData:imageData];
        }
    }
    return image;
}

/*
 *  本地图片展示
 */
-(void)localImageShow:(NSUInteger)index{
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        NSArray *localImages = [weakSelf.images copy];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
        for (NSUInteger i = 0; i< localImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image = localImages[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.view.subviews[i];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

#pragma mark -- 点击事件
- (IBAction)btnOnclick:(UIButton *)sender {
//    [Tools showImage:sender.imageView];
    [self localImageShow:sender.tag - 1001];
}

#pragma mark -- CheckPictureServiceDelegate
- (void)success {
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [_images removeAllObjects];
        
        /// 查看图片一大图
        if(_service.arrPictures.count > 0) {
            OrderPictureModel *model = _service.arrPictures[0];
            NSString *url = [NSString stringWithFormat:@"%@Uploadfile/%@", API_LOAD_URL, model.PRODUCT_URL];
            if(url) {
                [MBProgressHUD showHUDAddedTo:_btn1 animated:YES];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    _image1 = [self setImageFieldImage:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:_btn1 animated:YES];
                        [_btn1 setImage:_image1 forState:UIControlStateNormal];
                        [_images replaceObjectAtIndex:0 withObject:_image1];
                    });
                });
            }
        }
        /// 查看图片二大图
        if(_service.arrPictures.count > 1) {
            OrderPictureModel *model = _service.arrPictures[1];
            NSString *url = [NSString stringWithFormat:@"%@Uploadfile/%@", API_LOAD_URL, model.PRODUCT_URL];
            if(url) {
                [MBProgressHUD showHUDAddedTo:_btn2 animated:YES];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    _image2 = [self setImageFieldImage:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:_btn2 animated:YES];
                        [_btn2 setImage:_image2 forState:UIControlStateNormal];
                        [_images replaceObjectAtIndex:1 withObject:_image2];
                    });
                });
                
            }
        }
        /// 查看图片三大图
        if(_service.arrPictures.count > 2) {
            OrderPictureModel *model = _service.arrPictures[2];
            NSString *url = [NSString stringWithFormat:@"%@Uploadfile/%@", API_LOAD_URL, model.PRODUCT_URL];
            if(url) {
                [MBProgressHUD showHUDAddedTo:_btn3 animated:YES];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    _image3 = [self setImageFieldImage:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:_btn3 animated:YES];
                        [_btn3 setImage:_image3 forState:UIControlStateNormal];
                        [_images replaceObjectAtIndex:2 withObject:_image3];
                    });
                });
            }
        }
        /// 查看图片四大图
        if(_service.arrPictures.count > 3) {
            OrderPictureModel *model = _service.arrPictures[3];
            NSString *url = [NSString stringWithFormat:@"%@Uploadfile/%@", API_LOAD_URL, model.PRODUCT_URL];
            if(url) {
                [MBProgressHUD showHUDAddedTo:_btn4 animated:YES];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    _image4 = [self setImageFieldImage:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:_btn4 animated:YES];
                        [_btn4 setImage:_image4 forState:UIControlStateNormal];
                        [_images replaceObjectAtIndex:3 withObject:_image4];
                    });
                });
            }
        }
    });
}

- (void)failure:(NSString *)msg {
    [Tools showAlert:self.view andTitle:msg ? msg : @"请求照片失败"];
}

@end
