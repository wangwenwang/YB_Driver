//
//  PayOrderViewController.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/8.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderViewController : UIViewController

/// 订单编号
@property (copy, nonatomic) NSString *orderIDX;

/// 订单交付状态 N:未交付，S:已到达，Y:已交付
@property (copy, nonatomic) NSString *orderPayState;


@end
