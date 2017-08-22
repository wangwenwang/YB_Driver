//
//  OrderDetailsTableViewCell.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderDetailsTableViewCell : UITableViewCell

/// 产品名称
@property (weak, nonatomic) IBOutlet UILabel *productName;

/// 计划发运时间
@property (weak, nonatomic) IBOutlet UILabel *playTime;

/// 订货数量
@property (weak, nonatomic) IBOutlet UILabel *orderQTY;

/// 实际发货数量
@property (weak, nonatomic) IBOutlet UILabel *sendQTY;

/// 大区
@property (weak, nonatomic) IBOutlet UILabel *bigArea;

/// 地区
@property (weak, nonatomic) IBOutlet UILabel *region;

/// 办事处
@property (weak, nonatomic) IBOutlet UILabel *office;

/// 订单详情
@property (strong, nonatomic) OrderDetailModel *orderDetail;

@end
