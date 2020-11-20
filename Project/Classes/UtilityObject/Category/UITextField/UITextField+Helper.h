//
//  UITextField+Helper.h
//  Project
//
//  Created by Chenyi on 2019/9/6.
//  Copyright © 2019 Chenyi. All rights reserved.
//

@interface UITextField (Helper) <UITextFieldDelegate>
typedef NS_ENUM(NSUInteger, TextFieldInputType) {
    TextFieldInputTypeAccount = 0,
    TextFieldInputTypePassword,
    TextFieldInputTypeNick,
    TextFieldInputTypeName,
    TextFieldInputTypePhone,
    TextFieldInputTypeVerificationCode
};
typedef NS_OPTIONS(NSUInteger, TextFieldInputLimit) {
    TextFieldInputLimitChinese = 1 << 0,
    TextFieldInputLimitNumber = 1 << 1,
    TextFieldInputLimitDecimal = 1 << 2,
    TextFieldInputLimitLetterOrNumber = 1 << 3,
};
@property(nonatomic, assign) NSUInteger maxLength;
@property(nonatomic, assign) BOOL editable;
@property(nonatomic, assign) TextFieldInputLimit inputLimit;
@property(nonatomic, assign) TextFieldInputType inputType;
@property(nonatomic, assign) NSUInteger limitDecimalLenght;
@property(nonatomic, copy) void (^textDidChangeEvent)(UITextField *textField);

typedef void(^CallBackEvent)(UITextField *textField, UIButton *button);
- (void)setPlacehold:(NSString *)placehold font:(UIFont *)font;
- (void)setPlacehold:(NSString *)placehold color:(UIColor *)color;
- (void)setPlacehold:(NSString *)placehold color:(UIColor *)color font:(UIFont *)font;


- (void)addRightItemWithNorImageName:(NSString *)norName viewMode:(UITextFieldViewMode)viewMode event:(CallBackEvent)event;
- (void)addRightItemWithNorImageName:(NSString *)norName selImageName:(NSString *)selName viewMode:(UITextFieldViewMode)viewMode event:(CallBackEvent)event;
@end
