//
//  UITableView+NoDataPrompt.m
//  CMDriver
//
//  Created by 凯东源 on 17/2/20.
//  Copyright © 2017年 城马联盟. All rights reserved.
//

#import "UITableView+NoDataPrompt.h"

@implementation UITableView (NoDataPrompt)

- (void)noOrder:(NSString *)title {
    
    [self noDataWithImageName:@"noOrder" andTitle:title];
}


- (void)noTruck:(NSString *)title {
    
    [self noDataWithImageName:@"noTruck" andTitle:title];
}


- (void)noDriver:(NSString *)title {
    
    [self noDataWithImageName:@"noDriver" andTitle:title];
}


- (void)noSupply:(NSString *)title {
    
    [self noDataWithImageName:@"noSupply" andTitle:title];
}


// 隐藏提示
- (void)removeNoDataPrompt {
    NSArray *array = self.subviews;
    for(int i = 0; i < array.count; i++) {
        UIView *view = self.subviews[i];
        if(view.tag == 10068) {
            view.hidden = YES;
        }
    }
}


// 添加无数据提示 View
- (void)noDataWithImageName:(NSString *)imageName andTitle:(NSString *)title {
    
    //如果有，不实例
    NSArray *array = self.subviews;
    for(int i = 0; i < array.count; i++) {
        UIView *view = self.subviews[i];
        if(view.tag == 10068) {
            view.hidden = NO;
            return;
        }
    }
    
    //外框
    UIView *_noOrderView = [[UIView alloc] init];
    _noOrderView.tag = 10068;
    [_noOrderView setFrame:CGRectMake(0, 0, 120, 120)];
    [_noOrderView setCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 30)];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView setCenter:CGPointMake(CGRectGetWidth(_noOrderView.frame) / 2, CGRectGetHeight(_noOrderView.frame) / 2)];
    [_noOrderView addSubview:imageView];
    
    //文字
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor colorWithRed:191 / 255.0 green:191 / 255.0 blue:191 / 255.0 alpha:1.0]];
    [label setFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    label.text = title;
    [label setCenter:CGPointMake(CGRectGetWidth(_noOrderView.frame) / 2, CGRectGetHeight(_noOrderView.frame) / 2 + 60)];
    [_noOrderView addSubview:label];
    
    [self addSubview:_noOrderView];
}

@end
