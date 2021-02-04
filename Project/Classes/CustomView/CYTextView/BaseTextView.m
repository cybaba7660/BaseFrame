//
//  CYTextView.m
//  Project
//
//  Created by Chenyi on 2019/10/14.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "BaseTextView.h"
@interface BaseTextView () {
    
}
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *placeholderLabel;
@end
@implementation BaseTextView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Set/Get
- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}
- (void)setLimitLength:(NSUInteger)limitLength {
    _limitLength = limitLength;
    [self refreshLimitLengthLabelText];
}
- (void)setLimitLengthLabelAppendText:(NSString *)limitLengthLabelAppendText {
    _limitLengthLabelAppendText = limitLengthLabelAppendText;
    [self refreshLimitLengthLabelText];
}
- (void)setFont:(UIFont *)font {
    _font = font;
    self.textView.font = font;
    self.placeholderLabel.font = font;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
#pragma mark - External
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [NotificationCenter addObserver:self selector:@selector(textViewTextDidChangeEvent:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.limitLengthLabel sizeToFit];
    self.limitLengthLabel.left = self.width - WIDTH(10) - self.limitLengthLabel.width;
    self.limitLengthLabel.top = self.height - WIDTH(10) - self.limitLengthLabel.height;
    
    self.textView.frame = CGRectMake(0, 0, self.width, self.limitLengthLabel.top - WIDTH(6));
}
#pragma mark - UI
- (void)setupUI {
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:15];
    self.textView = textView;
    [self addSubview:textView];
    textView.textContainerInset = UIEdgeInsetsMake(10, 4, 10, 4);
    textView.backgroundColor = UIColor.clearColor;
    
    UILabel *placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.textContainerInset.left + 4, textView.textContainerInset.top, 0, 0)];
    self.placeholderLabel = placeholdLabel;
    placeholdLabel.font = textView.font;
    placeholdLabel.textColor = COLOR_W(200);
    [textView addSubview:placeholdLabel];
    
    UILabel *limitLengthLabel = [[UILabel alloc] init];
    self.limitLengthLabel = limitLengthLabel;
    limitLengthLabel.font = Font_Medium(12);
    limitLengthLabel.textColor = COLOR_W(150);
    limitLengthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:limitLengthLabel];
    [self refreshLimitLengthLabelText];
}
#pragma mark - EventMethods
- (void)textViewTextDidChangeEvent:(NSNotification *)noti {
    // 通知回调的实例的不是当前实例的话直接返回
    UITextView *textView = noti.object;
    if (!textView) {
        return;
    }
    
    // 禁止第一个字符输入空格或者换行
    if (textView.text.length == 1) {
        if ([textView.text isEqualToString:@" "] || [textView.text isEqualToString:@"\n"]) {
            textView.text = @"";
        }
    }
    
    if (_limitLength != NSUIntegerMax && _limitLength != 0 && textView.text.length) {
        if (!textView.markedTextRange && textView.text.length > _limitLength) {
            textView.text = [textView.text substringToIndex:_limitLength]; // 截取最大限制字符数.
            [textView.undoManager removeAllActions]; // 达到最大字符数后清空所有 undoaction, 以免 undo 操作造成crash.
        }
    }
    _text = textView.text;
    self.placeholderLabel.hidden = textView.text.length;
    [self refreshLimitLengthLabelText];
    [self setNeedsLayout];
    self.maxLengthEvent ? self.maxLengthEvent(textView) : nil;
}
- (void)refreshLimitLengthLabelText {
    NSString *text = @(self.textView.text.length).stringValue;
    if (_limitLength > 0) {
        text = [text stringByAppendingFormat:@"/%zd", _limitLength];
    }
    if (_limitLengthLabelAppendText.length) {
        text = [text stringByAppendingFormat:@" %@", _limitLengthLabelAppendText];
    }
    self.limitLengthLabel.text = text;
}
#pragma mark - CommonMethods

@end
