//
//  CYNavBarView.h
//  Project
//
//  Created by Chenyi on 2018/3/15.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYNavBarView : UIView

@property (nonatomic, strong) UIColor *titleColor;

/**
 自定义导航栏

 @param title 标题
 @param titleColor 标题颜色
 @param image 返回按钮图标
 @param clickEvent 返回点击事件
 */
+ (instancetype)navBarWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backItemImage:(UIImage *)image backItemClickEvent:(void (^)(void))clickEvent;
@end
