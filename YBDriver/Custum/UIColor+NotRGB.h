//
//  UIColor+NotRGB.h
//  HFWParkingProject
//
//  Created by Eric on 2016/11/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NotRGB)
+ (UIColor *)colorWithHexString:(NSString *)color andAlpha:(CGFloat)alpha;  
@end
