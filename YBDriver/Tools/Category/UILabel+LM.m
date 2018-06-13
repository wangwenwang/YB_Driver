//
//  UILabel+LM.m
//  YBDriver
//
//  Created by wenwang wang on 2018/6/12.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import "UILabel+LM.h"

@implementation UILabel (LM)

- (CGSize)sizeThatFits:(CGSize)size {
    NSLog(@"");
    size = [super sizeThatFits:size];
//    if (@available(iOS 11.0, *)) {
//        float bottomInset = self.safeAreaInsets.bottom;
//        if (bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90)) {
//            size.height += bottomInset;
//        }
//    }
    
    return size;
}

@end
