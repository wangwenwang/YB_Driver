//
//  LMBlurredView.m
//  Bule
//
//  Created by 凯东源 on 2017/7/27.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMBlurredView.h"

@implementation LMBlurredView


- (instancetype)init {
    
    if(self = [super init]) {
        
        _foregroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:20/255.0 alpha:0.5];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen] .bounds.size.width, [UIScreen mainScreen] .bounds.size.height);
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        
        // 手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurredOnclick)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (UIImage *)imageWithUIView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


- (UIImage *)blurryImage:(UIImage *)image blurLevel:(CGFloat)blur {
    
    // 创建属性
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    // 高斯模糊
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    
    // 生成图片
    CIContext *context = [CIContext contextWithOptions:nil];
    // 创建输出
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef outImage = [context createCGImage: result fromRect:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    
    return blurImage;
}


- (void)blurry:(CGFloat)level {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    imageView.alpha = 0;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIImage *currImage = [self imageWithUIView:window];
    
    [self addSubview:imageView];
    
    UIImage *bImage = [self blurryImage:currImage blurLevel:level];
    
    imageView.image = bImage;
    
    // 模糊前景色
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    coverView.backgroundColor = _foregroundColor;
    coverView.alpha = 0.1;
    [self addSubview:coverView];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        imageView.alpha = 1.0;
    }];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView setAnimationDuration:0.4f];
    coverView.alpha = 1.0;
    [UIView commitAnimations];
}


- (void)blurredOnclick {
    
    [self clear];
    
    if([_delegate respondsToSelector:@selector(LMBlurredViewClear)]) {
        
        [_delegate LMBlurredViewClear];
    }
}


- (void)clear {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
