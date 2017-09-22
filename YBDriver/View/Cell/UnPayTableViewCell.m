//
//  UnPayTableViewCell.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "UnPayTableViewCell.h"
#import "Tools.h"

@implementation UnPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setOrder:(OrderModel *)order {
    
    _orderNO.text = order.ORD_NO;
    _orderToName.text = order.ORD_TO_NAME;
    _orderToAddress.text = order.ORD_TO_ADDRESS;
    _orderIssueQTY.text = [Tools OneDecimal:order.ORD_QTY];
    _orderIssueWeight.text = order.ORD_WEIGHT;
    _orderDriverName.text = order.TMS_DRIVER_NAME;
    _orderDriverTelephone.text = order.TMS_DRIVER_TEL;
    _orderTmsShipmentNO.text = order.TMS_FLEET_NAME;
    _orderIssueDate.text = order.TMS_DATE_ISSUE;
}

@end
