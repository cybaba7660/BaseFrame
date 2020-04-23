//
//  XQAlertView.m
//  Example
//
//  Created by NB-022 on 16/8/25.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import "XQAlertView.h"

#define TEXTFIELD_TAG_BEGIN  8
#define XQVIEW_TAG(tag)   tag + 50

@interface XQAlertView ()
/** 标题Lable */
@property (nonatomic, weak) UILabel *titleLab;
/** 背景View */
@property (nonatomic, weak) UIView *backgroundView;
/** 底部所有按钮的父控件 */
@property (nonatomic, weak) UIView *bottomView;
/** 所有编辑框的父控件 */
@property (nonatomic, weak) UIView *tfView;
/** 存储按钮回调事件block的字典 */
@property (nonatomic, strong) NSMutableDictionary *buttonHandle;

@end

@implementation XQAlertView
{
    NSInteger buttonTag;
    NSInteger textFieldTag;
    CGFloat tfViewY;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        [self addNofification];
        [self setDefaultValue];
        CGFloat originY   = 0;
        CGFloat selfWidth = WIDTH(250);
        if (title) {
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, selfWidth, HEIGHT(43))];
            self.titleLab     = titleLab;
            titleLab.text     = title;
            titleLab.font     = [UIFont systemFontOfSize:FONTSIZE(18)];
            [titleLab setTextAlignment:NSTextAlignmentCenter];
            [titleLab setBackgroundColor:RGBACOLOR(245, 245, 245, 1.0)];
            [self addSubview:titleLab];
            originY += HEIGHT(43);
        }
        if (message) {
            CGFloat mesLabX = (selfWidth - WIDTH(210)) * 0.5;
            CGFloat mesLabH = [self caculateHeightWithMessage:message].height + HEIGHT(10) * 2;
            UILabel *mesLab = [[UILabel alloc] initWithFrame:CGRectMake(mesLabX, originY, WIDTH(210), mesLabH)];
            mesLab.text     = message;
            mesLab.font     = [UIFont systemFontOfSize:FONTSIZE(16)];
            [mesLab setNumberOfLines:0];
            [mesLab setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:mesLab];
            originY += mesLabH;
        }
        tfViewY    = originY + HEIGHT(3);
        self.frame = CGRectMake(0, 0, selfWidth, originY);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 设置默认值 */
- (void)setDefaultValue
{
    buttonTag               = 2;
    textFieldTag            = TEXTFIELD_TAG_BEGIN;
    tfViewY                 = 0;
    _themeColor             = RGBACOLOR(230, 230, 230, 1);
    self.backgroundColor    = [UIColor whiteColor];
    self.clipsToBounds      = YES;
    self.layer.cornerRadius = WIDTH(3);
}

- (void)addNofification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void)addButtonWithTitle:(NSString *)title style:(XQAlertButtonStyle)style handle:(void (^)(void))handle
{
    if (self.bottomView == nil) {
        CGFloat bottomH    = HEIGHT(55);
        CGRect frame       = self.frame;
        frame.size.height  = frame.size.height + bottomH;
        self.frame         = frame;
        
        CGFloat bottomY    = frame.size.height - bottomH;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, frame.size.width, bottomH)];
        self.bottomView    = bottomView;
        [self addSubview:bottomView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBACOLOR(90, 90, 90, 1) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self imageWithColor:RGBACOLOR(230, 230, 230, 1)] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE(16)]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setClipsToBounds:YES];
    [button.layer setCornerRadius:WIDTH(2)];
    if (style == XQAlertButtonStyleCancel) {
        [button setTag:XQVIEW_TAG(style)];
    }else if (style == XQAlertButtonStyleDestructive) {
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTag:XQVIEW_TAG(style)];
    }else {
        [button setTag:XQVIEW_TAG(buttonTag)];
        buttonTag++;
    }
    if (handle) {
        [self.buttonHandle setObject:handle forKey:[NSString stringWithFormat:@"%zd", button.tag]];
    }
    [self.bottomView addSubview:button];
}

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder handle:(void (^)(UITextField *))handle
{
    if (self.tfView == nil) {
        UIView *tfView = [[UIView alloc] initWithFrame:CGRectMake(0, tfViewY, self.frame.size.width, HEIGHT(40))];
        self.tfView    = tfView;
        [tfView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:tfView];
    }
    
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder  = placeholder;
    tf.borderStyle  = UITextBorderStyleRoundedRect;
    tf.tag          = XQVIEW_TAG(textFieldTag);
    textFieldTag++;
    [self.tfView addSubview:tf];
    if (handle) {
        handle(tf);
    }
}

- (void)show
{
    if (self.tfView) {
        [self setTextFieldFrame];
    }
    [self setButtonFrame];
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView    = backgroundView;
    [backgroundView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.4)];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

#pragma mark - start setter
- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    int begin   = 0;
    
    if (themeColor == nil) return;
    
//    self.titleLab.backgroundColor = themeColor;
    
    UIButton *cancelBtn = [self.bottomView viewWithTag:XQVIEW_TAG(XQAlertButtonStyleCancel)];
    if (cancelBtn) begin++;
    
    UIButton *destruBtn = [self.bottomView viewWithTag:XQVIEW_TAG(XQAlertButtonStyleDestructive)];
    if (destruBtn) begin++;
    
    for (int i = begin; i < self.bottomView.subviews.count; i++) {
        UIButton *btn   = [self.bottomView viewWithTag:XQVIEW_TAG(i)];
        [btn setBackgroundImage:[self imageWithColor:themeColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleLab.textColor = titleColor;
}
#pragma mark end setter

#pragma mark - start 事件监听
- (void)buttonAction:(UIButton *)sender
{
    NSString *key    = [NSString stringWithFormat:@"%zd", sender.tag];
    void (^handle)(void) = [self.buttonHandle objectForKey:key];
    if (handle) {
        handle();
    }
    [self removeAlertView];
}

- (void)removeAlertView
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         self.alpha     = 0;
                     } completion:^(BOOL finished) {
                         self.transform = CGAffineTransformIdentity;
                         [self.backgroundView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect  frame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat dis   = frame.origin.y - CGRectGetMaxY(self.frame) - HEIGHT(5);
    
    if (dis >= 0) return;
    [UIView animateWithDuration:animateTime animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, dis);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animateTime animations:^{
        self.transform  = CGAffineTransformIdentity;
    }];
}
#pragma mark end 事件监听

#pragma mark - start 懒加载
- (NSMutableDictionary *)buttonHandle
{
    if (_buttonHandle == nil) {
        _buttonHandle = [NSMutableDictionary dictionary];
    }
    return _buttonHandle;
}
#pragma mark end 懒加载

#pragma mark - start 私有方法
/** 设置TextField的Frame */
- (void)setTextFieldFrame
{
    CGRect frame      = self.tfView.frame;
    frame.size.height = self.tfView.subviews.count * (HEIGHT(40));
    self.tfView.frame = frame;
    
    frame             = self.frame;
    frame.size.height = frame.size.height + self.tfView.subviews.count * (HEIGHT(40));
    self.frame        = frame;
    
    CGFloat tfW = WIDTH(200);
    CGFloat tfX = (self.frame.size.width - tfW) * 0.5;
    CGFloat tfH = HEIGHT(30);
    CGFloat tfY = HEIGHT(5);
    CGFloat edY = tfY;
    
    NSInteger count = TEXTFIELD_TAG_BEGIN + self.tfView.subviews.count;
    for (int i = TEXTFIELD_TAG_BEGIN; i < count; i++) {
        UITextField *tf = [self.tfView viewWithTag:XQVIEW_TAG(i)];
        tf.frame        = CGRectMake(tfX, tfY, tfW, tfH);
        tfY             = tfY + tfH + edY;
    }
    
    CGFloat bottomH       = HEIGHT(55);
    CGFloat bottomY       = self.frame.size.height - HEIGHT(55);
    self.bottomView.frame = CGRectMake(0, bottomY, frame.size.width, bottomH);
}

/** 设置Button的Frame */
- (void)setButtonFrame
{
    NSInteger count     = self.bottomView.subviews.count;
    CGFloat space       = (8 * [UIScreen mainScreen].bounds.size.width) / 320;
    CGFloat buttonW     = (self.frame.size.width - space * (count + 1)) / count;
    CGFloat buttonH     = HEIGHT(40);
    CGFloat buttonY     = (self.bottomView.frame.size.height - buttonH) * 0.5;
    
    CGFloat originX     = space;
    int begin           = 0;
    
    UIButton *cancelBtn = [self.bottomView viewWithTag:XQVIEW_TAG(XQAlertButtonStyleCancel)];
    if (cancelBtn) {
        cancelBtn.frame = CGRectMake(originX, buttonY, buttonW, buttonH);
        originX         = originX + space + buttonW;
        begin++;
    }
    
    UIButton *destruBtn = [self.bottomView viewWithTag:XQVIEW_TAG(XQAlertButtonStyleDestructive)];
    if (destruBtn) {
        destruBtn.frame = CGRectMake(originX, buttonY, buttonW, buttonH);
        originX         = originX + space + buttonW;
        begin++;
    }
    
    for (int i = begin, tag = 2; i < count; i++, tag++) {
        UIButton *btn   = [self.bottomView viewWithTag:XQVIEW_TAG(tag)];
        btn.frame       = CGRectMake(originX, buttonY, buttonW, buttonH);
        originX         = originX + (space + buttonW);
        [btn setBackgroundImage:[self imageWithColor:_themeColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat centerY = [UIScreen mainScreen].bounds.size.height * 0.5;
    self.center     = CGPointMake(centerX, centerY);
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGSize)caculateHeightWithMessage:(NSString *)message
{
    CGSize maxSize = CGSizeMake(WIDTH(210), CGFLOAT_MAX);
    UIFont *font   = [UIFont systemFontOfSize:FONTSIZE(16)];
    CGRect rect    = [message boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    return rect.size;
}
#pragma mark end 私有方法

@end
