//
//  UITextField+Helper.m
//  Project
//
//  Created by Chenyi on 2019/9/6.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import "UITextField+Helper.h"

@implementation UITextField (Helper)
- (void)setInputType:(TextFieldInputType)inputType {
    objc_setAssociatedObject(self, @selector(inputType), @(inputType), OBJC_ASSOCIATION_ASSIGN);
    if (inputType == TextFieldInputTypePhone) {
        self.inputLimit = TextFieldInputLimitNumber;
        self.maxLength = 11;
    }else if (inputType == TextFieldInputTypeAccount) {
        self.inputLimit = TextFieldInputLimitLetterOrNumber;
        self.maxLength = 16;
    }else if (inputType == TextFieldInputTypePassword) {
        self.secureTextEntry = YES;
        self.inputLimit = TextFieldInputLimitLetterOrNumber;
        self.maxLength = 16;
    }else if (inputType == TextFieldInputTypeVerificationCode) {
        self.inputLimit = TextFieldInputLimitLetterOrNumber;
        self.maxLength = 6;
    }
}
- (TextFieldInputType)inputType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setInputLimit:(TextFieldInputLimit)inputLimit {
    objc_setAssociatedObject(self, @selector(inputLimit), @(inputLimit), OBJC_ASSOCIATION_ASSIGN);
    if (inputLimit & TextFieldInputLimitNumber) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }else if (inputLimit & TextFieldInputLimitChinese) {
    }else if (inputLimit & TextFieldInputLimitDecimal) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
        self.limitDecimalLenght = 2;
    }else if (inputLimit & TextFieldInputLimitLetterOrNumber) {
        self.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    [self addTarget:self action:@selector(handleTextFieldTextDidChangeAction) forControlEvents:UIControlEventEditingChanged];
}
- (TextFieldInputLimit)inputLimit {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(handleTextFieldTextDidChangeAction) forControlEvents:UIControlEventEditingChanged];
}
- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setTextDidChangeEvent:(void (^)(UITextField *))textDidChangeEvent {
    objc_setAssociatedObject(self, @selector(textDidChangeEvent), textDidChangeEvent, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(handleTextFieldTextDidChangeAction) forControlEvents:UIControlEventEditingChanged];
}
- (void (^)(UITextField *))textDidChangeEvent {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLimitDecimalLenght:(NSUInteger)limitDecimalLenght {
    objc_setAssociatedObject(self, @selector(limitDecimalLenght), @(limitDecimalLenght), OBJC_ASSOCIATION_ASSIGN);
}
- (NSUInteger)limitDecimalLenght {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)handleTextFieldTextDidChangeAction {
    if (self.textDidChangeEvent) {
        self.textDidChangeEvent(self);
    }
    if (self.inputLimit & TextFieldInputLimitNumber) {
        self.text = [self.text justNumber];
    }
    if (self.inputLimit & TextFieldInputLimitDecimal) {
        self.text = [self.text justDecimal];
        NSRange pointRange = [self.text rangeOfString:@"."];
        if (pointRange.location != NSNotFound) {
            if (pointRange.location == 0) {
                self.text = [@"0" stringByAppendingString:self.text];
                pointRange = [self.text rangeOfString:@"."];
            }
            NSString *decimalStr = [self.text substringFromIndex:pointRange.location + pointRange.length];
            if (self.limitDecimalLenght && decimalStr.length > self.limitDecimalLenght) {
                self.text = [self.text substringToIndex:pointRange.location + pointRange.length + self.limitDecimalLenght];
            }
            NSRange morePointRange = [decimalStr rangeOfString:@"."];
            if (morePointRange.location != NSNotFound) {
                self.text = [self.text substringToIndex:pointRange.location + pointRange.length + morePointRange.location];
            }
        }
    }
    if (self.inputLimit & TextFieldInputLimitLetterOrNumber) {
        self.text = [self.text justLetterOrNumber];
    }
    UITextRange *selectRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectRange.start offset:0];
    
    if (!position && self.inputLimit & TextFieldInputLimitChinese) {
        self.text = [self.text justChinese];
    }
    
    if (!position && self.maxLength > 0 && self.text.length > self.maxLength) {
        NSRange rangeIndex = [self.text rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        if (rangeIndex.length == 1) {
            self.text = [self.text substringToIndex:self.maxLength];
        }else {
            NSRange tempRange = [self.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            NSInteger tempLength;
            if (tempRange.length > self.maxLength) {
                tempLength = tempRange.length - rangeIndex.length;
            }else {
                tempLength = tempRange.length;
            }
            self.text = [self.text substringWithRange:NSMakeRange(0, tempLength)];
        }
    }
}

- (void)setEditable:(BOOL)editable {
    objc_setAssociatedObject(self, @selector(editable), @(editable), OBJC_ASSOCIATION_ASSIGN);
    if (!editable) {
        self.delegate = self;
    }
}
- (BOOL)editable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    return textField.editable;
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  return textField.editable;
}

- (void)setPlacehold:(NSString *)placehold font:(UIFont *)font {
    [self setPlacehold:placehold color:nil font:font];
}
- (void)setPlacehold:(NSString *)placehold color:(UIColor *)color {
    [self setPlacehold:placehold color:color font:nil];
}
- (void)setPlacehold:(NSString *)placehold color:(UIColor *)color font:(UIFont *)font {
    NSString *attrText = placehold;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithCapacity:2];
    if (color) {
        [attrs setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attrs setObject:font forKey:NSFontAttributeName];
    }
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:attrText attributes:attrs];
    self.attributedPlaceholder = attrM;
}
- (void)addRightItemWithNorImageName:(NSString *)norName viewMode:(UITextFieldViewMode)viewMode event:(CallBackEvent)event {
    [self addRightItemWithNorImageName:norName selImageName:nil viewMode:viewMode event:event];
}
static char kTextFieldCallBackBlock;
- (void)addRightItemWithNorImageName:(NSString *)norName selImageName:(NSString *)selName viewMode:(UITextFieldViewMode)viewMode event:(CallBackEvent)event {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
    [button setImage:[UIImage imageNamed:norName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setAdjustsImageWhenHighlighted:NO];
    button.size = button.currentImage.size;
    self.rightView = button;
    self.rightViewMode = viewMode;
    objc_setAssociatedObject(self, &kTextFieldCallBackBlock, event, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)buttonClickedEvent:(UIButton *)button {
    CallBackEvent block = objc_getAssociatedObject(self, &kTextFieldCallBackBlock);
    block ? block(self, button) : nil;
}
@end
