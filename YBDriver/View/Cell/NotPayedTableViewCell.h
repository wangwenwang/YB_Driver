//
//  NotPayedTableViewCell.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface NotPayedTableViewCell : UITableViewCell

/// 发货单号
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

/// 出库时间
@property (weak, nonatomic) IBOutlet UILabel *orderStartTimeLabel;

/// 到达名称
@property (weak, nonatomic) IBOutlet UILabel *orderToNameLabel;

// 订单详情
@property (strong, nonatomic)OrderModel *order;

@end
