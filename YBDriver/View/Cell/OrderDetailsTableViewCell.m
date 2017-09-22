//
//  OrderDetailsTableViewCell.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "OrderDetailsTableViewCell.h"
#import "Tools.h"

@implementation OrderDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderDetail:(OrderDetailModel *)orderDetail {
    _productName.text = [NSString stringWithFormat:@"%@(%@)", orderDetail.PRODUCT_NAME, orderDetail.PRODUCT_NO];
    _playTime.text = orderDetail.ORD_REQUEST_ISSUE;
    _orderQTY.text = [NSString stringWithFormat:@"%@件", [Tools OneDecimal:orderDetail.ORD_QTY]];
    _sendQTY.text = [NSString stringWithFormat:@"%@件", [Tools OneDecimal:orderDetail.ISSUE_QTY]];
    NSString *text = orderDetail.ORD_TO_REGION;
    if(text) {
        NSArray *array = [text componentsSeparatedByString:@"."];
        if(array.count > 0) {
            _bigArea.text = array[0];
        }
        if(array.count > 1) {
            _region.text = array[1];
        }
        if(array.count > 2) {
            _office.text = array[2];
        }
    }

}

@end
