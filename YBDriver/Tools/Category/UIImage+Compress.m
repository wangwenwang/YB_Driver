//
//  UIImage+Compress.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/9.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "UIImage+Compress.h"
#import <UIKit/UIKit.h>

@implementation UIImage (Compress)

- (NSData *)compressImage:(UIImage *)image andMaxLength:(int)maxLength {
    CGSize newSize = [self scaleImage:image andImageLength:350];
    UIImage *newImage = [self resizeImage:image andNewSize:newSize];
    
    CGFloat compress = 0.9;
    NSData *data = UIImageJPEGRepresentation(newImage, compress);
    
    while(data.length > maxLength && compress > 0.01) {
        compress -= 0.02;
        data = UIImageJPEGRepresentation(newImage, compress);
    }
    
    return data;
}

/**
 *  通过指定图片最长边，获得等比例的图片size
 *
 *  image:       原始图片
 *
 *  imageLength: 图片允许的最长宽度（高度）
 *
 *  return 获得等比例的size
 */
- (CGSize)scaleImage:(UIImage *)image andImageLength:(CGFloat)imageLength {
    
    CGFloat newWidth = 0.0;
    CGFloat newHeight = 0.0;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    if (width > imageLength || height > imageLength){
        
        if (width > height) {
            
            newWidth = imageLength;
            newHeight = newWidth * height / width;
            
        }else if(height > width){
            
            newHeight = imageLength;
            newWidth = newHeight * width / height;
            
        }else{
            
            newWidth = imageLength;
            newHeight = imageLength;
        }
        
    }
    return CGSizeMake(newWidth, newHeight);
}

/**
 *  获得指定size的图片
 *
 *  image:   原始图片
 *
 *  newSize: 指定的size
 *
 *  return 调整后的图片
 */
- (UIImage *)resizeImage:(UIImage *)image andNewSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//水印位置枚举
typedef enum {
    TopLeft,
    TopRight,
    BottomLeft,
    BottomRight
} WaterMarkCorner;

- (UIImage *)waterMarkedImage:(NSString *)waterMarkText {
    
    UIColor *waterMarkTextColor = [UIColor whiteColor];
    UIFont *waterMarkTextFont = [UIFont systemFontOfSize:20.0];
    UIColor *backgroundColor = [UIColor clearColor];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    waterMarkTextColor, NSForegroundColorAttributeName,
                                    waterMarkTextFont, NSFontAttributeName,
                                    backgroundColor, NSBackgroundColorAttributeName,
                                    nil];
    
    
    CGSize textSize = [waterMarkText sizeWithAttributes:textAttributes];
    
    CGRect textFrame = CGRectMake(0, 0, textSize.width, textSize.height);
    
    CGSize imageSize = self.size;
    
    WaterMarkCorner corner = BottomRight;
    CGPoint margin = CGPointMake(20, 20);
    
    switch (corner) {
        case TopLeft:
            textFrame.origin = margin;
            break;
            
        case TopRight:
            textFrame.origin = CGPointMake(imageSize.width - textSize.width - margin.x, margin.y);
            break;
            
        case BottomLeft:
            textFrame.origin = CGPointMake(margin.x, imageSize.height - textSize.height - margin.y);
            break;
            
        case BottomRight:
            CGPointMake(imageSize.width - textSize.width - margin.x,
                        imageSize.height - textSize.height - margin.y);
            break;
            
        default:
            break;
    }
    
    // 开始给图片添加文字水印
    UIGraphicsBeginImageContext(imageSize);
    [self drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [waterMarkText drawInRect:textFrame withAttributes:textAttributes];
    
    UIImage *waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return waterMarkedImage;
}

@end
