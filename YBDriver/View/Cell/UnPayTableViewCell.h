//
//  UnPayTableViewCell.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface UnPayTableViewCell : UITableViewCell
/// 交货单号
@property (weak, nonatomic) IBOutlet UILabel *orderNO;

/// 到达名称
@property (weak, nonatomic) IBOutlet UILabel *orderToName;

/// 到达地址
@property (weak, nonatomic) IBOutlet UILabel *orderToAddress;

/// 货物总数
@property (weak, nonatomic) IBOutlet UILabel *orderIssueQTY;

/// 货物总重
@property (weak, nonatomic) IBOutlet UILabel *orderIssueWeight;

/// 司机姓名
@property (weak, nonatomic) IBOutlet UILabel *orderDriverName;

/// 司机手机
@property (weak, nonatomic) IBOutlet UILabel *orderDriverTelephone;

/// 承运商名
@property (weak, nonatomic) IBOutlet UILabel *orderTmsShipmentNO;

/// 出库时间
@property (weak, nonatomic) IBOutlet UILabel *orderIssueDate;

/// 订单详情
@property (strong, nonatomic)OrderModel *order;

/// 出库时间Label
@property (weak, nonatomic) IBOutlet UILabel *outTimeLabel;
@end
