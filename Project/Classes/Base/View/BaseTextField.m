//
//  BaseTextField.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseTextField.h"
@interface BaseTextField ()
{
    
}
@end
@implementation BaseTextField
+ (instancetype)viewWithFrame:(CGRect)frame {
    return [self viewWithFrame:frame leftImageName:nil leftText:nil leftColor:nil leftFont:nil rightImageName:nil];
}
+ (instancetype)viewWithFrame:(CGRect)frame leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font {
    return [self viewWithFrame:frame leftImageName:nil leftText:text leftColor:textColor leftFont:font rightImageName:nil];
}
+ (instancetype)viewWithFrame:(CGRect)frame leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font rightImageName:(NSString *)rightImageName {
    return [self viewWithFrame:frame leftImageName:nil leftText:text leftColor:textColor leftFont:font rightImageName:rightImageName];
}
+ (instancetype)viewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName {
    return [self viewWithFrame:frame leftImageName:leftImageName leftText:nil leftColor:nil leftFont:nil rightImageName:nil];
}
+ (instancetype)viewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName rightImageName:(NSString *)rightImageName {
    return [self viewWithFrame:frame leftImageName:leftImageName leftText:nil leftColor:nil leftFont:nil rightImageName:rightImageName];
}
+ (instancetype)viewWithFrame:(CGRect)frame rightImageName:(NSString *)rightImageName {
    return [self viewWithFrame:frame leftImageName:nil leftText:nil leftColor:nil leftFont:nil rightImageName:rightImageName];
}
+ (instancetype)viewWithFrame:(CGRect)frame leftImageName:(NSString *)leftImageName leftText:(NSString *)text leftColor:(UIColor *)textColor leftFont:(UIFont *)font rightImageName:(NSString *)rightImageName {
    BaseTextField *tf = [[BaseTextField alloc] initWithFrame:frame];
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (leftImageName) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:leftImageName];
        imageV.size = imageV.image.size;
        tf.leftView = imageV;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }else if (text) {
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.font = font;
        label.textColor = textColor;
        [label sizeToFit];
        tf.leftView = label;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    if (rightImageName) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:rightImageName];
        imageV.size = imageV.image.size;
        tf.rightView = imageV;
        tf.rightViewMode = UITextFieldViewModeAlways;
    }
    return tf;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    if (self.leftView) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, -10);
        iconRect = UIEdgeInsetsInsetRect(iconRect, insets);
    }
    return iconRect;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    if (self.rightView) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, -10, 0, 10);
        iconRect = UIEdgeInsetsInsetRect(iconRect, insets);
    }
    return iconRect;
}
//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    rect = UIEdgeInsetsInsetRect(rect, insets);
    return rect;
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    rect = UIEdgeInsetsInsetRect(rect, insets);
    return rect;
}

@end
