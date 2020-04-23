//
//  XQToast.h
//  Example
//
//  Created by NB-022 on 16/5/6.
//  Copyright © 2016年 ufuns. All rights reserved.
//  仿android的Toast

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static CGFloat const TOAST_LENGTH_SHORT = 1.5;
static CGFloat const TOAST_LENGTH_LONG  = 3.0;

@interface XQToast : NSObject

/** 显示的时长（默认为TOAST_LENGTH_SHORT） */
@property (nonatomic, assign) CGFloat duration;

/** 字体大小（默认字体大小为14） */
@property (nonatomic, assign) CGFloat fontSize;

/** 距离底部的距离（默认为距离底部110） */
@property (nonatomic, assign) CGFloat bottomInsets;

/** 距离左部的距离（默认为水平居中显示） */
@property (nonatomic, assign) CGFloat leftInsets;

/** 是否居中显示（默认为NO，若设置centerShow为YES，则bottomInsets和leftInsets的设置无效） */
@property (nonatomic, assign, getter=isCenterShow) BOOL centerShow;

/**
 *  创建一个带文本信息的Toast
 *  @parameter  :  text     文本信息
 *  @return     :  Toast实例
 */
+ (XQToast *)makeText:(NSString *)text;

/**
 *  创建一个带图片信息的Toast
 *  @parameter  :  image    图片信息
 *  @return     :  Toast实例
 */
+ (XQToast *)makeImage:(UIImage *)image;

/**
 *  创建一个带文本信息的Toast
 *  @parameter  :  text     文本信息
 *  @parameter  :  duration 显示时长
 *  @return     :  Toast实例
 */
+ (XQToast *)makeText:(NSString *)text
             duration:(CGFloat)duration;

/**
 *  创建一个带图片信息的Toast
 *  @parameter  :  image    图片信息
 *  @parameter  :  duration 显示时长
 *  @return     :  Toast实例
 */
+ (XQToast *)makeImage:(UIImage *)image
              duration:(CGFloat)duration;

/**
 *  创建一个带文本信息和图片的Toast
 *  @parameter  :  text     文本信息
 *  @parameter  :  image    图片信息
 *  @return     :  Toast实例
 */
+ (XQToast *)makeText:(NSString *)text
                image:(UIImage *)image;

/**
 *  创建一个带文本信息和图片的Toast
 *  @parameter  :  text     文本信息
 *  @parameter  :  image    图片信息
 *  @parameter  :  duration 显示时长
 *  @return     :  Toast实例
 */
+ (XQToast *)makeText:(NSString *)text
                image:(UIImage *)image
             duration:(CGFloat)duration;

/** 显示Toast信息 */
- (void)show;

@end
