//
//  UILabel+Helper.m
//  Project
//
//  Created by Chenyi on 2019/11/19.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UILabel+Helper.h"

@implementation UILabel (Helper)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector_1 = @selector(init);
        SEL swizzledSelector_1 = @selector(ex_init);
        [self swizzleInstanceMethod:originalSelector_1 with:swizzledSelector_1];

        SEL originalSelector_2 = @selector(initWithFrame:);
        SEL swizzledSelector_2 = @selector(ex_initWithFrame:);
        [self swizzleInstanceMethod:originalSelector_2 with:swizzledSelector_2];
    });
}

- (instancetype)ex_init {
    UILabel *instance = [self ex_init];
    instance.textColor = UIColor.blackColor;
    return instance;
}
- (instancetype)ex_initWithFrame:(CGRect)frame {
    UILabel *instance = [self ex_initWithFrame:frame];
    instance.textColor = UIColor.blackColor;
    return instance;
}

//Text
- (void)widthToFit {
    [self widthToFitWithIncrease:0];
}
- (void)widthToFitWithIncrease:(CGFloat)increase {
    self.width = [self.text calculateWidthWithFont:self.font] + increase;
}
- (void)heightToFit {
    [self heightToFitWithIncrease:0];
}
- (void)heightToFitWithIncrease:(CGFloat)increase {
    self.height = [self.text calculateHeightWithFont:self.font limitWidth:self.width] + increase;
}

//AttributedText
- (void)widthToFitByAttributedText {
    [self widthToFitByAttributedTextWithIncrease:0];
}
- (void)widthToFitByAttributedTextWithIncrease:(CGFloat)increase {
    self.width = [self.attributedText calculateWidth] + increase;
}
- (void)heightToFitByAttributedText {
    [self heightToFitByAttributedTextWithIncrease:0];
}
- (void)heightToFitByAttributedTextWithIncrease:(CGFloat)increase {
    self.height = [self.attributedText calculateHeightWithLimitWidth:self.width] + increase;
}

//Text color status.
static const void *kNormalTextColor = &kNormalTextColor;
- (void)setNormalTextColor:(UIColor *)normalTextColor {
    objc_setAssociatedObject(self, kNormalTextColor, normalTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.selected) {
        self.textColor = normalTextColor;
    }
}
- (UIColor *)normalTextColor {
    return objc_getAssociatedObject(self, kNormalTextColor) ? : self.textColor;
}

static const void *kselectedTextColor = &kselectedTextColor;
- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    objc_setAssociatedObject(self, kselectedTextColor, selectedTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.selected) {
        self.textColor = selectedTextColor;
    }
}
- (UIColor *)selectedTextColor {
    return objc_getAssociatedObject(self, kselectedTextColor);
}

static const void *kSelectedStatus = &kSelectedStatus;
- (void)setSelected:(BOOL)selected {
    objc_setAssociatedObject(self, kSelectedStatus, [NSNumber numberWithBool:selected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (selected && self.selectedTextColor) {
        self.textColor = self.selectedTextColor;
    }else if (!selected && self.normalTextColor) {
        self.textColor = self.normalTextColor;
    }
}
- (BOOL)selected {
    return [objc_getAssociatedObject(self, kSelectedStatus) boolValue];
}
@end
