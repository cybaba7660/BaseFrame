//
//  BaseTextField.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField
@property (nonatomic, assign) BOOL menuEnable;
@property (nonatomic, assign) CGFloat horizContentOffset;
@property (nonatomic, assign) CGFloat leftViewAndRightViewOffset;
+ (instancetype)viewWithFrame:(CGRect)frame;
+ (instancetype)viewWithFrame:(CGRect)frame leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font;
+ (instancetype)viewWithFrame:(CGRect)frame leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font rightImageName:(NSString *)rightImageName;
+ (instancetype)viewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName;
+ (instancetype)viewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName rightImageName:(NSString *)rightImageName;
+ (instancetype)viewWithFrame:(CGRect)frame rightImageName:(NSString *)rightImageName;
@end
