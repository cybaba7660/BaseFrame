//
//  UIView+Helper.m
//  Project
//
//  Created by Chenyi on 2019/8/29.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)
- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self setCornerRadius:cornerRadius masksToBounds:NO];
}
- (void)setCornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masks {
    if (self.layer.cornerRadius != cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = masks;
    }
}

- (void)setCornerRound {
    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.layer.masksToBounds = YES;
}
- (void)setCornerRadius:(CGFloat)cornerRadius rectCorner:(UIRectCorner)rectCorner {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setCornerRoundByRoundingCorners:(UIRectCorner)rectCorner {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.height / 2, self.height / 2)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
//border
- (void)setBorderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
//shadow
- (void)setShadowRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor {
    [self setShadowRadius:radius shadowColor:shadowColor shadowOffset:CGSizeZero];
}
- (void)setShadowRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset {
    [self setShadowRadius:radius shadowColor:shadowColor shadowOffset:shadowOffset opacity:1];
}
- (void)setShadowRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset opacity:(float)opacity {
    self.layer.shadowRadius = radius;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = opacity;
}
- (void)clean {
    self.layer.cornerRadius = 0;
    self.layer.borderWidth = 0;
    self.layer.shadowRadius = 0;
}
//dashLine
- (void)setDashLineBorderWithLineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor lineDashPattern:(NSArray<NSNumber *> *)lineDashPattern {
    CAShapeLayer *dashLineLayer = [CAShapeLayer layer];
    dashLineLayer.lineWidth = lineWidth;
    dashLineLayer.strokeColor = lineColor.CGColor;
    dashLineLayer.fillColor = UIColor.clearColor.CGColor;
    dashLineLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    dashLineLayer.frame = self.bounds;
    
    //设置线条的样式
    dashLineLayer.lineCap = kCALineCapSquare;
    //[长，间距]
    dashLineLayer.lineDashPattern = @[@4, @2];
    
    for (CAShapeLayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            [layer removeFromSuperlayer];
        }
    }
    [self.layer addSublayer:dashLineLayer];
}

//display&dismiss
- (void)gradualDisplay {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}
- (void)gradualDismiss {
    [self gradualDismissAndRemove:NO];
}
- (void)gradualDismissAndRemove:(BOOL)remove {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (remove) {
            [self removeFromSuperview];
        }
    }];
}
- (void)setAllowableDrag:(BOOL)allowableDrag {
    [self setAllowableDrag:allowableDrag invalidArea:UIEdgeInsetsZero];
}
- (void)setAllowableDrag:(BOOL)allowableDrag adsorbed:(BOOL)adsorbed {
    [self setAllowableDrag:allowableDrag invalidArea:UIEdgeInsetsZero adsorbed:adsorbed];
}
- (void)setAllowableDrag:(BOOL)allowableDrag invalidArea:(UIEdgeInsets)invalidArea {
    [self setAllowableDrag:allowableDrag invalidArea:invalidArea adsorbed:NO];
}
static char invalidAreaKey;
static char adsorbedKey;
- (void)setAllowableDrag:(BOOL)allowableDrag invalidArea:(UIEdgeInsets)invalidArea adsorbed:(BOOL)adsorbed {
    if (allowableDrag) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEvent:)];
        [self addGestureRecognizer:pan];
        
    }else {
        for (UIGestureRecognizer *obj in self.gestureRecognizers) {
            if ([obj isKindOfClass:[UIPanGestureRecognizer class]]) {
                [self removeGestureRecognizer:obj];
                break;
            }
        }
    }
    objc_setAssociatedObject(self, &invalidAreaKey, @(invalidArea), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &adsorbedKey, @(adsorbed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)panGestureEvent:(UIPanGestureRecognizer *)pan {
    UIView *dragView = pan.view;
    CGPoint location = [pan translationInView:dragView];
    static CGPoint beganPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        beganPoint = CGPointMake(location.x, location.y);
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        UIEdgeInsets invalidArea = [objc_getAssociatedObject(self, &invalidAreaKey) UIEdgeInsetsValue];
        CGFloat moveLenHoriz = location.x - beganPoint.x;
        CGFloat moveLenVertical = location.y - beganPoint.y;
        if (CGAffineTransformIsIdentity(dragView.transform)) {
            if (moveLenHoriz < 0 && -(self.left - invalidArea.left) > moveLenHoriz) {
                beganPoint.x += moveLenHoriz + (self.left - invalidArea.left);
                moveLenHoriz = -(self.left - invalidArea.left);
            }else if (moveLenHoriz > 0 && (self.superview.width - invalidArea.right) - self.right < moveLenHoriz) {
                beganPoint.x += moveLenHoriz - ((self.superview.width - invalidArea.right) - self.right);
                moveLenHoriz = (self.superview.width - invalidArea.right) - self.right;
            }
            
            if (moveLenVertical < 0 && -(self.top - invalidArea.top) > moveLenVertical) {
                beganPoint.y += moveLenHoriz + (self.top - invalidArea.top);
                moveLenVertical = -(self.top - invalidArea.top);
            }else if (moveLenVertical > 0 && (self.superview.height - invalidArea.bottom) - self.bottom < moveLenVertical) {
                beganPoint.y += moveLenVertical - ((self.superview.height - invalidArea.bottom) - self.bottom);
                moveLenVertical = (self.superview.height - invalidArea.bottom) - self.bottom;
            }
            
            if (beganPoint.x < 0) {
                beganPoint.x = 0;
            }else if (beganPoint.x > self.width) {
                beganPoint.x = self.width;
            }else if (beganPoint.y < 0) {
                beganPoint.y = 0;
            }else if (beganPoint.y > self.height) {
                beganPoint.y = self.height;
            }
            
            dragView.layer.position = CGPointMake(dragView.layer.position.x + moveLenHoriz, dragView.layer.position.y + moveLenVertical);
            [pan setTranslation:beganPoint inView:dragView];
        }else {
            //坐标过于复杂算不出来......
//            CGPoint toPoint = CGPointMake(dragView.layer.position.x + moveLenVertical, dragView.layer.position.y - moveLenHoriz);
//            dragView.layer.position = toPoint;
//            [pan setTranslation:beganPoint inView:dragView];
        }
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        BOOL adsorbed = [objc_getAssociatedObject(self, &adsorbedKey) boolValue];
        if (adsorbed) {
            CGFloat left;
            if (dragView.centerX < dragView.superview.width / 2) {
                left = 0;
            }else {
                left = dragView.superview.width - dragView.width;
            }
            float moveLen = fabs(dragView.left - left);
            [UIView animateWithDuration:moveLen / 200 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                dragView.left = left;
            } completion:nil];
        }
        
    }
}
@end
@implementation UIView (ViewController)
- (UINavigationController *)navigationController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            if ([nextResponder isKindOfClass:[UINavigationController class]]) {
                nextResponder = [(UINavigationController *)nextResponder visibleViewController];
            }
            return (UIViewController *)nextResponder;
        }
        
    }
    return nil;
}

@end

@implementation UIView (Screenshot)

- (UIImage*)screenshot {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
    
}

- (UIImage *)screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset {
    UIGraphicsBeginImageContext(self.bounds.size);
    //need to translate the context down to the current visible portion of the scrollview
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -contentOffset.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.55);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIImage*) screenshotInFrame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), frame.origin.x, frame.origin.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

@end

@implementation UIView (Animation)

- (void)shakeAnimation {
    
    CALayer* layer = [self layer];
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 8.0f, position.y);
    CGPoint x = CGPointMake(position.x + 8.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

- (void)trans180DegreeAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }];
}
@end
