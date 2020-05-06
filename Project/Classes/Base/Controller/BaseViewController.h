//
//  BaseViewController.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <NavigationControllerDelegate>

- (instancetype)initWithHidesBottomBar:(BOOL)hide;
/**
 *  设置导航栏
 */
- (void)setNavigationBarStyle;
/**
 *  设置状态栏样式
 */
- (UIBarStyle)statusBarStyle;
/**
 *  设置导航栏颜色
 */
- (UIColor *)barTintColor;
/**
 *  导航栏标题颜色和按钮颜色
 */
- (UIColor *)tintColor;

/** 强制横屏*/
- (void)setupInterfaceOrientation:(UIInterfaceOrientation)orientation;
@end
