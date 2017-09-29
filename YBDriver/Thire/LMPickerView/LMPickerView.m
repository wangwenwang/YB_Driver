//
//  LMPickerView.m
//  LMPickerView
//
//  Created by 凯东源 on 2017/7/28.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMPickerView.h"
#import "LMBlurredView.h"

@interface LMPickerView ()<LMBlurredViewDelegate>

// 模糊背景
@property (strong, nonatomic) LMBlurredView *blurredView;

// 显示时间选择器控件容器
@property (strong, nonatomic) UIView *datePickerContainerView;

// 时间选择器是否弹出
@property (assign, nonatomic) BOOL isShowDatePicker;

// 时间选择
@property (strong, nonatomic) UIDatePicker *datePicker;

// 已经选择的时间
@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation LMPickerView



//  虚化值 0 - 10
#define kBlurryLevel 5.1

// datePickerContainerView alpha渐变时间
#define kDatePickerContainerView_alpha_Duration 0.47f



// 关闭时间选择器类型
typedef enum _CloseDatePicker {
    
    CloseDatePicker_TYPE_SURE  = 0,         // 确定
    CloseDatePicker_TYPE_CANCEL,            // 取消
} DateType;



#pragma mark - 选择时间模块

- (UIImage *)imageWithUIView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


- (void)initDatePicker {
    
    _selectedDate = [NSDate date];
    
    _datePickerContainerView = [[UIView alloc] init];
    _date = [NSDate date];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)showDatePicker {
    
    if(_isShowDatePicker) return;
    
    CGFloat screenWidth = [UIScreen mainScreen] .bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen] .bounds.size.height;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 虚化背景
    _blurredView = [[LMBlurredView alloc] init];
    [_blurredView blurry:kBlurryLevel];
    _blurredView.delegate = self;
    
    CGFloat width = screenWidth - 10 * 2;
    CGFloat height = width * 2 / 3;
    
    CGFloat buttonHeight = 35;
    CGFloat buttonWidth = 100;
    CGFloat buttonSpan = (width - buttonWidth * 2) / 3;
    
    // 容器
    [_datePickerContainerView setFrame:CGRectMake(0, 0, width, height + buttonHeight + 10)];
    [_datePickerContainerView setCenter:CGPointMake(screenWidth / 2, screenHeight / 2)];
    _datePickerContainerView.clipsToBounds = YES;
    _datePickerContainerView.backgroundColor = [UIColor whiteColor];
    
    // 弹出动画 参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [window addSubview:_datePickerContainerView];
    _datePickerContainerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration: kDatePickerContainerView_alpha_Duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _datePickerContainerView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDatePickerContainerView_alpha_Duration];
    _datePickerContainerView.alpha = 1.0;
    [UIView commitAnimations];
    
    
    UIButton *cancelBtn = nil;
    UIButton *sureBtn = nil;
    for (UIView *view in _datePickerContainerView.subviews) {
        
        if(view.tag == 1033) {
            
            cancelBtn = (UIButton *)view;
        } else if(view.tag == 1034) {
            
            sureBtn = (UIButton *)view;
        }
    }
    
    // 取消按钮
    if(!cancelBtn) {
        
        cancelBtn = [[UIButton alloc] init];
        cancelBtn.tag = 1033;
        [cancelBtn setFrame:CGRectMake(buttonSpan, height + 5, buttonWidth, buttonHeight)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:YBGreen];
        cancelBtn.layer.cornerRadius = 2.0;
        [cancelBtn addTarget:self action:@selector(cancelDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerContainerView addSubview:cancelBtn];
    }
    
    // 确认按钮
    if(!sureBtn) {
        
        sureBtn = [[UIButton alloc] init];
        sureBtn.tag = 1034;
        [sureBtn setFrame:CGRectMake(buttonSpan * 2 + buttonWidth, height + 5, buttonWidth, buttonHeight)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:YBGreen];
        sureBtn.layer.cornerRadius = 2.0;
        [sureBtn addTarget:self action:@selector(sureDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerContainerView addSubview:sureBtn];
    }
    
    // 日期选择器
    [_datePicker setFrame:CGRectMake(0, 0, width, height)];
    _datePicker.minimumDate = _minimumDate;
    _datePicker.maximumDate = _maximumDate;
    _datePicker.date = _date;
    [_datePickerContainerView addSubview:_datePicker];
    _selectedDate = _date;
    
    // 添加遮盖，只显示 年 月
    if([_dateType isEqualToString:@"yyyy-MM"]) {
        
        CGFloat fdWidth = CGRectGetWidth(_datePickerContainerView.frame) / 2.5;
        UIView *fd = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_datePickerContainerView.frame) - fdWidth, 0, fdWidth, height)];
        fd.backgroundColor = _datePickerContainerView.backgroundColor;
        [_datePickerContainerView addSubview:fd];
        _isShowDatePicker = YES;
    }
}


// 改变时间
- (void)dateChanged:(UIDatePicker *)datePicker {
    
    NSDate *date = datePicker.date;
    _selectedDate = date;
}


// 取消时间
- (void)cancelDateClick:(UIButton *)sender {
    
    [self closeDatePickerView:CloseDatePicker_TYPE_CANCEL];
}


// 确定时间
- (void)sureDateClick:(UIButton *)sender {
    
    [self closeDatePickerView:CloseDatePicker_TYPE_SURE];
    _date = _selectedDate;
}


- (void)closeDatePickerView:(NSUInteger)type {
    
    [UIView beginAnimations:[NSString stringWithFormat:@"%lu", (unsigned long)type] context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView setAnimationDuration:0.3f];
    _datePickerContainerView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    [UIView commitAnimations];
    
    // UIViewAnimationOptionBeginFromCurrentState 从当前状态开始动画
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _datePickerContainerView.alpha = 0;
    } completion:nil];
    
    // 移除虚化背景
    [_blurredView clear];
}


// 动画回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSString *LM = (NSString *)anim;
    NSUInteger LM_I = [LM integerValue];
    
    if(LM_I == CloseDatePicker_TYPE_SURE) {
        
        if([_delegate respondsToSelector:@selector(PickerViewComplete:)]) {
            
            [_delegate PickerViewComplete:_selectedDate];
        }
        _datePickerContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [_datePickerContainerView removeFromSuperview];
        _isShowDatePicker = NO;
    } else if(LM_I == CloseDatePicker_TYPE_CANCEL) {
        
        _datePickerContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [_datePickerContainerView removeFromSuperview];
        _isShowDatePicker = NO;
    }
}


#pragma mark - LMBlurredViewDelegate

- (void)LMBlurredViewClear {
    
    [self closeDatePickerView:CloseDatePicker_TYPE_CANCEL];
}

@end
