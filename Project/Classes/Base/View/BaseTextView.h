//
//  CYTextView.h
//  Project
//
//  Created by Chenyi on 2019/10/14.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HEIGHT_INPUT_VIEW_SINGLE_LINE 40
#define MARGIN_INPUT_VIEW_SINGLE_LINE 8
NS_ASSUME_NONNULL_BEGIN
@interface BaseTextView : UIView
@property (nonatomic, copy) NSString *__nullable text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) BOOL limitLabelHidden;
@property (nonatomic, assign) NSUInteger limitLength;
@property (nonatomic, copy) NSString *limitLengthLabelAppendText;

@property (nonatomic, copy) void(^maxLengthEvent)(UITextView *textView);
@property (nonatomic, copy) void(^textDidChanged)(UITextView *textView);

@property (nonatomic, assign) BOOL adaptiveHeight;
@end

NS_ASSUME_NONNULL_END
