//
//  XQAlertView.h
//  Example
//
//  Created by NB-022 on 16/8/25.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XQAlertButtonStyle) {
    XQAlertButtonStyleCancel      = 0,  /**< 取消样式 */
    XQAlertButtonStyleDestructive = 1,  /**< 不可撤销样式 */
    XQAlertButtonStyleDefault     = 2,  /**< 默认样式 */
};

@interface XQAlertView : UIView
/** 标题颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 主题颜色(默认样式按钮的背景色) */
@property (nonatomic, strong) UIColor *themeColor;
/**
 *  创建一个XQAlertView对象
 *  @parameter : title    标题
 *  @parameter : message  提示消息
 *  @return    : XQAlertView的实例
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
/**
 *  增加一个按钮
 *  @parameter : title   按钮标题
 *  @parameter : style   按钮样式
 *  @parameter : handle  按钮点击回调block
 */
- (void)addButtonWithTitle:(NSString *)title style:(XQAlertButtonStyle)style handle:(void (^)(void))handle;
/**
 *  增加一个编辑框
 *  @parameter : placeholder  textField的占位符
 *  @parameter : handle       block，包含一个textfield
 */
- (void)addTextFieldWithPlaceholder:(NSString *)placeholder handle:(void (^)(UITextField *textField))handle;
/**
 *  显示XQAlertView的实例
 */
- (void)show;

@end
