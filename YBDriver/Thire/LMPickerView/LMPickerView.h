//
//  LMPickerView.h
//  LMPickerView
//
//  Created by 凯东源 on 2017/7/28.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMPickerViewDelegate <NSObject>

@optional
- (void)PickerViewComplete:(NSDate *)date;

@optional
- (void)PickerViewCancel;

@end

@interface LMPickerView : UIView


@property (weak, nonatomic) id <LMPickerViewDelegate> delegate;


/**
 最小日期 默认当前时间
 */
@property (strong, nonatomic) NSDate *minimumDate;


/**
 最大日期 默认2066-11-24
 */
@property (strong, nonatomic) NSDate *maximumDate;


/**
 当前日期 默认当前时间
 */
@property (strong, nonatomic) NSDate *date;



/**
 日期类型 默认yyyy-MM-dd 还有yyyy-MM
 */
@property (copy, nonatomic) NSString *dateType;


/**
 初始化控件
 */
- (void)initDatePicker;


/**
 展示
 */
- (void)showDatePicker;

@end
