//
//  PayedOrderViewController.h
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayedOrderViewController : UIViewController

/// 界面显示到前台的时候是否要刷新数据、主要在司机交付订单成功后返回该界面和登陆界面使用
@property (assign, nonatomic) BOOL shouldRefresh;

@end
