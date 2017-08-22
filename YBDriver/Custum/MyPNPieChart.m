//
//  MyPNPieChart.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/11.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "MyPNPieChart.h"

@implementation MyPNPieChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)recompute {
    self.outerCircleRadius = CGRectGetWidth(self.bounds) / 2;
    self.innerCircleRadius = self.innerCircleRadius;
}

- (CGFloat)innerCircleRadius {
    return CGRectGetWidth(self.bounds) / 4;
}

@end
