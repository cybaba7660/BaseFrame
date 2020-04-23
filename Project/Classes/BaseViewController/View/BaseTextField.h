//
//  BaseTextField.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField
+ (instancetype)viewWithFrame:(CGRect)frame;
+ (instancetype)viewWithFrame:(CGRect)frame leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font;
+ (instancetype)viewWithFrame:(CGRect)frame leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font rightImageName:(NSString *)rightImageName;
+ (instancetype)ViewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName;
+ (instancetype)viewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName rightImageName:(NSString *)rightImageName;
+ (instancetype)ViewWithFrame:(CGRect)frame rightImageName:(NSString *)rightImageName;
@end
