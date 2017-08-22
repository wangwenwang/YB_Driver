//
//  UnPayedOrderViewController.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailService.h"

@interface UnPayedOrderViewController : UIViewController

@property (strong, nonatomic) OrderDetailService *orderDetailService;

@property (assign, nonatomic) BOOL isRequestData;

@end
