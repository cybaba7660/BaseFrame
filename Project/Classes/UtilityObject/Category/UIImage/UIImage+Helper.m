//
//  UIImage+Helper.m
//  Project
//
//  Created by Chenyi on 2019/10/8.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UIImage+Helper.h"
@implementation UIImage (Helper)
- (UIImage *)scaleToWidth:(CGFloat)width {
    CGFloat imageHeight = self.size.height / self.size.width * width;
    CGSize scaleSize = CGSizeMake(width, imageHeight);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, width, imageHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)scaleToHeight:(CGFloat)height {
    CGFloat imageWidth = self.size.width / self.size.height * height;
    CGSize scaleSize = CGSizeMake(imageWidth, height);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, imageWidth, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation UIImage (RenderMode)
+ (UIImage *)imageRenderingModeImageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end

@implementation UIColor (Hex)
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r                       截取的range = (0,2)
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;//     截取的range = (2,2)
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;//     截取的range = (4,2)
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;//将字符串十六进制两位数字转为十进制整数
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
@end
