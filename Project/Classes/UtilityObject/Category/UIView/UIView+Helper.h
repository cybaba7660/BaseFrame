//
//  UIView+Helper.h
//  Project
//
//  Created by Chenyi on 2019/8/29.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Helper)
- (void)setCornerRound;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setCornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masks;
- (void)setCornerRoundByRoundingCorners:(UIRectCorner)rectCorner;
- (void)setCornerRadius:(CGFloat)cornerRadius rectCorner:(UIRectCorner)rectCorner;

- (void)setBorderWidth:(CGFloat)width borderColor:(UIColor *)color;

- (void)setShadowRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor;
- (void)setShadowRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset;
- (void)setShadowRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset opacity:(float)opacity;

- (void)clean;

- (void)gradualDisplay;
- (void)gradualDismiss;
- (void)gradualDismissAndRemove:(BOOL)remove;

- (void)setAllowableDrag:(BOOL)allowableDrag;
- (void)setAllowableDrag:(BOOL)allowableDrag adsorbed:(BOOL)adsorbed;
- (void)setAllowableDrag:(BOOL)allowableDrag invalidArea:(UIEdgeInsets)invalidArea;
- (void)setAllowableDrag:(BOOL)allowableDrag invalidArea:(UIEdgeInsets)invalidArea adsorbed:(BOOL)adsorbed;
@end

@interface UIView (Screenshot)
//View截图
- (UIImage*)screenshot;

//ScrollView截图 contentOffset
- (UIImage*)screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

//View按Rect截图
- (UIImage*)screenshotInFrame:(CGRect)frame;

@end

@interface UIView (Animation)
//左右抖动动画
- (void)shakeAnimation;

//旋转180度
- (void)trans180DegreeAnimation;

@end

@interface UIView (ViewController)
@property (nonatomic, weak, readonly) UINavigationController *navigationController;
@property (nonatomic, weak, readonly) UIViewController *viewController;
@end


NS_ASSUME_NONNULL_END
