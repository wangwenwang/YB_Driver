//
//  NSObject+JSONCategories.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/1.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "NSObject+JSONCategories.h"

@implementation NSObject (JSONCategories)

// NSArray/NSDictionary==>NSData
- (NSData*)arrayOrNSDictionaryToNSData{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
