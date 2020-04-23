//
//  XQActionSheet.m
//  biaoqing
//
//  Created by ufuns on 16/1/22.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#import "XQActionSheet.h"

CGFloat const buttonHeight = 45;

@interface XQActionSheet ()

@property (nonatomic, assign) CGFloat actionSheetHeight;

@property (nonatomic, retain) UIView *modeView;

@end

@implementation XQActionSheet

/** 创建普通button的ActionSheetView */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<XQActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init]) {
        self.actionSheetHeight = 0;
        self.delegate          = delegate;
        [self addTitleLabel:title];
        [self addDestructiveButton:destructiveButtonTitle];
        if(otherButtonTitles) {
            // 1.第一个参数
            UIButton *button = [self creatButtonWithTitle:otherButtonTitles];
            [button setTag:1];
            [button setFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, buttonHeight)];
            [self addSubview:button];
            self.actionSheetHeight += buttonHeight;
            [self addSeparatorLine:self.actionSheetHeight - 1];
            
            //2.从第2个参数开始，依此取得所有参数的值
            int tag = 2;
            NSString *curTitle;
            va_list list;
            va_start(list, otherButtonTitles);
            while ((curTitle = va_arg(list, NSString*))){
                UIButton *subButton = [self creatButtonWithTitle:curTitle];
                [subButton setTag:tag++];
                [subButton setFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, buttonHeight)];
                [self addSubview:subButton];
                self.actionSheetHeight += buttonHeight;
                [self addSeparatorLine:self.actionSheetHeight - 1];
            }
            va_end(list);
        }
        [self addCancelButton:cancelButtonTitle];
    }
    return self;
}

/** 创建带有自定义view的ActionSheetView */
- (instancetype)initWithCustomView:(UIView *)view Delegate:(id<XQActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init]) {
        self.actionSheetHeight = 0;
        self.delegate          = delegate;
        if (view) {
            CGRect viewRect    = CGRectMake(0, 0, kDeviceWidth, view.frame.size.height);
            view.frame         = viewRect;
            self.actionSheetHeight += view.frame.size.height;
            [self addSubview:view];
            [self addSeparatorLine:self.actionSheetHeight - 1];
        }
        [self addDestructiveButton:destructiveButtonTitle];
        if(otherButtonTitles) {
            // 1.第一个参数
            UIButton *button = [self creatButtonWithTitle:otherButtonTitles];
            [button setTag:1];
            [button setFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, buttonHeight)];
            [self addSubview:button];
            self.actionSheetHeight += buttonHeight;
            [self addSeparatorLine:self.actionSheetHeight - 1];
            
            //2.从第2个参数开始，依此取得所有参数的值
            int tag = 2;
            NSString *curTitle;
            va_list list;
            va_start(list, otherButtonTitles);
            while ((curTitle = va_arg(list, NSString*))){
                UIButton *subButton = [self creatButtonWithTitle:curTitle];
                [subButton setTag:tag++];
                [subButton setFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, buttonHeight)];
                [self addSubview:subButton];
                self.actionSheetHeight += buttonHeight;
                [self addSeparatorLine:self.actionSheetHeight - 1];
            }
            va_end(list);
        }
        [self addCancelButton:cancelButtonTitle];
    }
    return self;
}

- (void)dealloc
{
    [_modeView release];
    _modeView     = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)addTitleLabel:(NSString *)title
{
    if (title) {
        UILabel *label = [[[UILabel alloc] init] autorelease];
        [label setText:title];
        [label setTextColor:RGBACOLOR(180, 180, 180, 1.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
        [label setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:label];
        self.actionSheetHeight += 45;
        [self addSeparatorLine:self.actionSheetHeight - 1];
    }
}

- (void)addDestructiveButton:(NSString *)destructiveButtonTitle
{
    if (destructiveButtonTitle) {
        UIButton *button = [self creatButtonWithTitle:destructiveButtonTitle];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTag:0];
        [button setFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, buttonHeight)];
        [self addSubview:button];
        self.actionSheetHeight += buttonHeight;
        [self addSeparatorLine:self.actionSheetHeight - 1];
    }
}

- (void)addCancelButton:(NSString *)cancelButtonTitle
{
    if (self.actionSheetHeight > 0) {
        UIView *separatorLine = [[[UIView alloc] initWithFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, 10)] autorelease];
        [separatorLine setBackgroundColor:RGBACOLOR(220, 220, 220, 1.0)];
        [self addSubview:separatorLine];
        self.actionSheetHeight += 10;
    }
    
    if (cancelButtonTitle) {
        UIButton *button = [self creatButtonWithTitle:cancelButtonTitle];
        [button setTag:-1];
        [button setFrame:CGRectMake(0, self.actionSheetHeight, kDeviceWidth, buttonHeight)];
        [self addSubview:button];
        self.actionSheetHeight += buttonHeight;
    }
}

/** 快速创建一个按钮 */
- (UIButton *)creatButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self colorToUIImage:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self colorToUIImage:RGBACOLOR(195, 195, 195, 1.0)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(actionSheetButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/** 快速加入一条分割线 */
- (void)addSeparatorLine:(CGFloat)originY
{
    UIView *separatorLine = [[[UIView alloc] initWithFrame:CGRectMake(0, originY, kDeviceWidth, 1)] autorelease];
    [separatorLine setBackgroundColor:RGBACOLOR(230, 230, 230, 1.0)];
    [self addSubview:separatorLine];
}

- (void)showInView:(UIView *)view
{
    CGFloat width    = view.frame.size.width;
    CGFloat height   = view.frame.size.height;
    
    _modeView = [[UIView alloc] initWithFrame:view.bounds];
    [_modeView setBackgroundColor:[UIColor blackColor]];
    [_modeView setAlpha:0];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideActionSheet)] autorelease];
    [_modeView addGestureRecognizer:tap];
    [view addSubview:_modeView];
    
    [self setFrame:CGRectMake(0, height, width, self.actionSheetHeight)];
    [view addSubview:self];
    [self expendAnimation:YES];
}

- (void)hideActionSheet
{
    [self expendAnimation:NO];
}

- (void)actionSheetButtonEvent:(UIButton *)sender
{
    if (sender.tag == -1) {
        [self expendAnimation:NO];
        return ;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetButtonDidClick:ButtonType:)]) {
        [self.delegate actionSheetButtonDidClick:self ButtonType:(int)sender.tag];
    }
    [self expendAnimation:NO];
}

- (void)setTitleColor:(UIColor *)color
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            [label setTextColor:color];
            break;
        }
    }
}

- (void)expendAnimation:(BOOL)isShow
{
    CGFloat originX = self.frame.origin.x;
    CGFloat originY = self.frame.origin.y;
    CGFloat width   = self.frame.size.width;
    CGFloat height  = self.frame.size.height;
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (isShow) {
                             self.frame = CGRectMake(originX, originY - self.actionSheetHeight, width, height);
                             self.modeView.alpha = 0.5;
                         }else {
                             self.frame = CGRectMake(originX, originY + self.actionSheetHeight, width, height);
                             self.modeView.alpha = 0;
                         }
                     } completion:^(BOOL finished) {
                         if (!isShow) {
                             [self.modeView removeFromSuperview];
                             [self removeFromSuperview];
                             if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetWasHidden)]) {
                                 [self.delegate actionSheetWasHidden];
                             }
                         }
                     }];
}

- (UIImage *)colorToUIImage:(UIColor *)color
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
@end
