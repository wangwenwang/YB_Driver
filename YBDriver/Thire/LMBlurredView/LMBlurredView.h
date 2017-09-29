//
//  LMBlurredView.h
//  Bule
//
//  Created by 凯东源 on 2017/7/27.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMBlurredViewDelegate <NSObject>

@optional
- (void)LMBlurredViewClear;

@end

@interface LMBlurredView : UIView


@property (weak, nonatomic) id <LMBlurredViewDelegate> delegate;

// 模糊前景色
@property (strong, nonatomic) UIColor *foregroundColor;

- (void)blurry:(CGFloat)level;


- (void)clear;

@end
