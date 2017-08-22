//
//  OrderDetailViewController.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailService.h"

@interface OrderDetailViewController : UIViewController

/// 用户的 idx
@property (copy, nonatomic) NSString *orderIDX;

@property (strong, nonatomic)OrderDetailService *service;

@end
