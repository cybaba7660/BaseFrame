//
//  UIImage+Helper.h
//  Project
//
//  Created by Chenyi on 2019/10/8.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Helper)
- (UIImage *)scaleToWidth:(CGFloat)width;
- (UIImage *)scaleToHeight:(CGFloat)height;
@end

@interface UIImage (RenderMode)
/** 取消UIImage的渲染模式 */
+ (UIImage *)imageRenderingModeImageNamed:(NSString *)imageName;


@end

@interface UIColor (Hex)
/** 默认alpha为1 */
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/** 从十六进制字符串获取颜色,默认alpha为1 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/** 从十六进制字符串获取颜色，alpha需要自己传递 color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
