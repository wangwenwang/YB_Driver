//
//  StateTackModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateTackModel : NSObject

/// 时间
@property(copy, nonatomic)NSString *STATE_TIME;
/// 节点
@property(copy, nonatomic)NSString *ORDER_STATE;

@end
