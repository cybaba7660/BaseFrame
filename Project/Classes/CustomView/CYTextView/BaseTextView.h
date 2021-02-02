//
//  CYTextView.h
//  Project
//
//  Created by Chenyi on 2019/10/14.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTextView : UIView

@property (nonatomic, copy) NSString *placehold;
@property (nonatomic, strong) UIColor *placeholdColor;
@property (nonatomic, assign) NSInteger limitLength;
@property (nonatomic, copy) NSString *limitLengthLabelAppendText;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UILabel *limitLengthLabel;

@property (nonatomic, copy) void(^maxLengthEvent)(UITextView *textView);

@end

NS_ASSUME_NONNULL_END
