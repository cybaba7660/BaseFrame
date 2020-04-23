//
//  XQToast.m
//  Example
//
//  Created by NB-022 on 16/5/6.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#define XQKeyWindow     [UIApplication sharedApplication].keyWindow
#define XQSize          [UIScreen mainScreen].bounds.size
#define XQEdgeInset     11
#define infinite        -99999
#define topInsetScale   0.75
#define dismissTime     0.15

#import "XQToast.h"

@interface XQToast()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XQToast

- (instancetype)init
{
    if (self = [super init]) {
        [self initDefalutValue];
        [self createView];
    }
    return self;
}

- (void)dealloc
{
    _imageView      = nil;
    _textLabel      = nil;
    _backgroundView = nil;
}

- (void)initDefalutValue
{
    _fontSize      = FONTSIZE(14);
    _bottomInsets  = HEIGHT(110);
    _leftInsets    = infinite;
    _centerShow    = NO;
}

- (void)createView
{
    UIView *backgroundView = [[UIView alloc] init];
    self.backgroundView    = backgroundView;
    
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [backgroundView.layer setCornerRadius:5];
    
    [XQKeyWindow addSubview:backgroundView];
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont systemFontOfSize:self.fontSize]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _textLabel;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

+ (XQToast *)makeText:(NSString *)text
{
    return [self makeText:text image:nil duration:TOAST_LENGTH_SHORT];
}

+ (XQToast *)makeImage:(UIImage *)image
{
    return [self makeText:nil image:image duration:TOAST_LENGTH_SHORT];
}

+ (XQToast *)makeText:(NSString *)text duration:(CGFloat)duration
{
    return [self makeText:text image:nil duration:duration];
}

+ (XQToast *)makeImage:(UIImage *)image duration:(CGFloat)duration
{
    return [self makeText:nil image:image duration:duration];
}

+ (XQToast *)makeText:(NSString *)text image:(UIImage *)image
{
    return [self makeText:text image:image duration:TOAST_LENGTH_SHORT];
}

+ (XQToast *)makeText:(NSString *)text image:(UIImage *)image duration:(CGFloat)duration
{
    XQToast *toast = [[self alloc] init];
    toast.duration = duration;
    if (text)  [toast.textLabel setText:text];
    if (image) [toast.imageView setImage:image];
    return toast;
}

- (void)show
{
    CGRect  bgRect = CGRectZero;
    CGFloat textH  = 0;
    
    if (self.isCenterShow) _leftInsets = infinite;
    
    if (_textLabel.text != nil) {
        
        NSDictionary *dictionary = @{NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize]};
        CGRect rect    = [self.textLabel.text boundingRectWithSize:CGSizeMake(XQSize.width, XQSize.height)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:dictionary
                                                            context:nil];
        
        CGFloat toastX = _leftInsets == infinite ? (XQSize.width - rect.size.width - WIDTH(XQEdgeInset) * 2) * 0.5 : _leftInsets;
        CGFloat toastY = XQSize.height - self.bottomInsets - rect.size.height - HEIGHT(XQEdgeInset);
        CGFloat toastW = rect.size.width + WIDTH(XQEdgeInset) * 2;
        CGFloat toastH = rect.size.height + HEIGHT(XQEdgeInset) * topInsetScale * 2;
        textH          = toastH;
        bgRect         = CGRectMake(toastX, toastY, toastW, toastH);
        [self.backgroundView addSubview:self.textLabel];
    }
    
    if (_imageView.image != nil) {
        CGFloat width   = bgRect.size.width > 0 ? (bgRect.size.width - WIDTH(XQEdgeInset) * 2) : 0;
        UIImage *image  = self.imageView.image;
        if (image.size.width <= width) {
            width = image.size.width;
        }else if (width <= 0){
            width = 100;
        }
        CGFloat height  = width * image.size.height / image.size.width + HEIGHT(XQEdgeInset) * topInsetScale;
        if (CGRectEqualToRect(bgRect, CGRectZero)) {  // 若没有文字信息
            CGFloat toastW  = width + WIDTH(XQEdgeInset) * 2;
            CGFloat toastH  = height + HEIGHT(XQEdgeInset) * topInsetScale;
            CGFloat toastX  = _leftInsets == infinite ? (XQSize.width - toastW) * 0.5 : _leftInsets;
            CGFloat toastY  = XQSize.height - self.bottomInsets - toastH;
            bgRect          = CGRectMake(toastX, toastY, toastW, toastH);
        }else {
            bgRect.origin.y = bgRect.origin.y - height;
            bgRect.size.height = bgRect.size.height + height;
        }
        CGFloat imageViewX  = (bgRect.size.width - width) * 0.5;
        CGFloat imageViewY  = HEIGHT(XQEdgeInset) * topInsetScale;
        [self.imageView setFrame:CGRectMake(imageViewX, imageViewY, width, height - HEIGHT(XQEdgeInset) * topInsetScale)];
        [self.backgroundView addSubview:self.imageView];
    }
    
    if (_textLabel.text != nil) {
        CGFloat textLabelX  = 0;
        CGFloat textLabelY  = CGRectGetMaxY(_imageView.frame);
        [self.textLabel setFrame:CGRectMake(textLabelX, textLabelY, bgRect.size.width, textH)];
        [self.backgroundView addSubview:self.textLabel];
    }
    
    if (self.isCenterShow) {
        bgRect.origin.y = (XQSize.height - bgRect.size.height) * 0.5;
    }
    
    [self.backgroundView setFrame:bgRect];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration
                                                      target:self
                                                    selector:@selector(removeToast)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

- (void)removeToast
{
    [self.timer invalidate];
    self.timer = nil;
    
    UIView *bg = self.backgroundView;
    [UIView animateWithDuration:dismissTime
                     animations:^{
                         [bg setAlpha:0];
                     } completion:^(BOOL finished) {
                         [bg removeFromSuperview];
                     }];
}

@end
