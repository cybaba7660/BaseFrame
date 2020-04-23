//
//  UIButton+Category.m
//  Project
//
//  Created by Chenyi on 16/5/4.
//  Copyright © 2016年 Chenyi. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

@implementation UIButton (Category)
- (void)setHighlighted:(BOOL)highlighted {
    //禁用按钮的高亮效果
}
- (void)addCallBackAction:(ButtonClickedEvent)action {
    [self addCallBackAction:action forControlEvents:UIControlEventTouchUpInside];
}

static char *const kAction = "kAction";
- (void)addCallBackAction:(ButtonClickedEvent)action
        forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, kAction, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(clickedEvent:) forControlEvents:controlEvents];
    if (action) {
        [self addTarget:self action:@selector(clickedEvent:) forControlEvents:controlEvents];
    }
}

- (void)clickedEvent:(UIButton *)button {
    ButtonClickedEvent block = objc_getAssociatedObject(self, kAction);
    block ? block(button) : nil;
}

- (void)setImageAlignment:(ButtonImageAlignment)alignment interval:(CGFloat)interval {
    
    // interval 图片与文字的间距
    interval = interval / 2;
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    CGSize imageSize = self.imageView.bounds.size.width ? self.imageView.bounds.size : self.imageView.image.size;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsZero, titleInsets = UIEdgeInsetsZero;
    if (alignment == ButtonImageAlignmentLeft) { // 图片在左，文字在右
        imageInsets = UIEdgeInsetsMake(0, 0, 0, interval);
        titleInsets = UIEdgeInsetsMake(0, interval, 0, 0);
    }
    else if (alignment == ButtonImageAlignmentRight) { // 图片在右，文字再左
        imageInsets = UIEdgeInsetsMake(0, titleSize.width + interval, 0, -(titleSize.width + interval));
        titleInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
    }
    else if (alignment == ButtonImageAlignmentTop) { // 图片在上，文字在下
        imageInsets = UIEdgeInsetsMake(0, 0, titleSize.height + interval, -titleSize.width);
        titleInsets = UIEdgeInsetsMake(imageSize.height + interval, -imageSize.width, 0, 0);
    }
    else if (alignment == ButtonImageAlignmentBottom) { // 图片在下，文字在上(很少需要，就不实现了)
        imageInsets = UIEdgeInsetsMake(titleSize.height + interval, 0, 0, -titleSize.width);
        titleInsets = UIEdgeInsetsMake(0, -imageSize.width, imageSize.height + interval, 0);
    }
    [self setImageEdgeInsets:imageInsets];
    [self setTitleEdgeInsets:titleInsets];
}
@end



@implementation UIButton (EnlargeTouchArea)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
