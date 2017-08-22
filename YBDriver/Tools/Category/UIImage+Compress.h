//
//  UIImage+Compress.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/9.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

/**
 *  压缩上传图片到指定字节
 *
 *  image:     压缩的图片
 *
 *  maxLength: 压缩后最大字节大小
 *
 *  return 压缩后图片的二进制
 */
- (NSData *)compressImage:(UIImage *)image andMaxLength:(int)maxLength;

//添加水印方法
- (UIImage *)waterMarkedImage:(NSString *)waterMarkText;

@end
