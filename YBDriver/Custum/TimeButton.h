//
//  TimeButton.h
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/22.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeButton : UIButton

// 记录上一次选择的时间
@property (strong, nonatomic) NSDate *date;

// 传给服务器的时间 格式：yyyy-MM-dd
@property (nonatomic, copy) NSString *dateStr;

@end
