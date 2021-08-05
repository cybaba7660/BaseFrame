//
//  CYTextView.m
//  Project
//
//  Created by Chenyi on 2019/10/14.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "BaseTextView.h"
//#define HEIGHT_ADAPTIVE_MAX WIDTH(120)
#define HEIGHT_ADAPTIVE_MAX 120
@interface BaseTextView () <UITextViewDelegate> {
    
}
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *placeholderLabel;
@property (nonatomic, weak) UILabel *limitLengthLabel;
@end
@implementation BaseTextView
- (void)dealloc {
}
#pragma mark - Set/Get
- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        self.textView.text = text;
        [self textViewDidChange:self.textView];
    }
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textView.textColor = textColor;
}
- (void)setFont:(UIFont *)font {
    _font = font;
    self.textView.font = font;
    self.placeholderLabel.font = font;
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
- (void)setLimitLabelHidden:(BOOL)limitLabelHidden {
    _limitLabelHidden = limitLabelHidden;
    self.limitLengthLabel.hidden = limitLabelHidden;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (limitLabelHidden) {
            make.bottom.mas_equalTo(0);
        }else {
            make.bottom.mas_equalTo(self.limitLengthLabel.mas_top);
        }
    }];
}
- (void)setLimitLength:(NSUInteger)limitLength {
    _limitLength = limitLength;
    [self refreshLimitLengthLabelText];
}
- (void)setLimitLengthLabelAppendText:(NSString *)limitLengthLabelAppendText {
    _limitLengthLabelAppendText = limitLengthLabelAppendText;
    [self refreshLimitLengthLabelText];
}
#pragma mark - External
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - UI
- (void)setupUI {
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    [self addSubview:textView];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    textView.textContainerInset = UIEdgeInsetsMake(10, 4, 10, 4);
    textView.backgroundColor = UIColor.clearColor;
    textView.showsVerticalScrollIndicator = NO;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    NSDictionary *attributes = @{
        NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:paragraphStyle
        
    };
    textView.typingAttributes = attributes;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    UILabel *placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.textContainerInset.left + 5, textView.textContainerInset.top, 0, 0)];
    self.placeholderLabel = placeholdLabel;
    placeholdLabel.font = textView.font;
    placeholdLabel.textColor = COLOR_W(200);
    [textView addSubview:placeholdLabel];
    [placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(textView.textContainerInset.left + 4);
        make.top.mas_offset(textView.textContainerInset.top);
    }];
    
    UILabel *limitLengthLabel = [[UILabel alloc] init];
    self.limitLengthLabel = limitLengthLabel;
    limitLengthLabel.font = Font_Medium(12);
    limitLengthLabel.textColor = COLOR_W(150);
    limitLengthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:limitLengthLabel];
    [self refreshLimitLengthLabelText];
    [limitLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(0);
        make.height.mas_offset(40);
    }];
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
/** 调整文本显示的高度 */
- (void)adjustContentTextViewHeight {
    CGFloat height  = [self.textView sizeThatFits:CGSizeMake(self.textView.width, CGFLOAT_MAX)].height;
    if (height > HEIGHT_ADAPTIVE_MAX) {
        height = HEIGHT_ADAPTIVE_MAX;
        self.textView.scrollEnabled = YES;
    }else {
        self.textView.scrollEnabled = NO;
    }
    CGFloat originalHeight = self.textView.height;
    if (fabs(height - originalHeight) > 1) {
        CGFloat marginVertical = MARGIN_INPUT_VIEW_SINGLE_LINE * 2;
        height += marginVertical;
        CGFloat top = self.superview.top + (self.superview.height - height);
        self.superview.top = top;
        self.superview.height = height;
    }
}
#pragma mark - EventMethods
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
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
            self.maxLengthEvent ? self.maxLengthEvent(textView) : nil;
        }
    }
    _text = textView.text;
    self.placeholderLabel.hidden = textView.text.length;
    [self refreshLimitLengthLabelText];
    [self setNeedsLayout];
    self.textDidChanged ? self.textDidChanged(textView) : nil;
    if (self.adaptiveHeight) [self adjustContentTextViewHeight];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textDidBegin ? self.textDidBegin(textView) : nil;
}
#pragma mark - CommonMethods

@end
