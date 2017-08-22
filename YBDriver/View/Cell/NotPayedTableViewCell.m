//
//  NotPayedTableViewCell.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "NotPayedTableViewCell.h"

@implementation NotPayedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrder:(OrderModel *)order {
    _orderNoLabel.text = order.ORD_NO;
    _orderStartTimeLabel.text = order.TMS_DATE_ISSUE;
    _orderToNameLabel.text = order.ORD_TO_NAME;
}

@end
