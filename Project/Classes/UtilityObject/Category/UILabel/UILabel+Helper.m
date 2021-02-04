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

- (void)widthToFit {
    [self widthToFitWithIncrease:0];
}
- (void)widthToFitWithIncrease:(CGFloat)increase {
    if (self.attributedText.length) {
        self.width = [self.attributedText calculateWidth] + increase;
    }else {
        self.width = [self.text calculateWidthWithFont:self.font] + increase;
    }
}
- (void)heightToFit {
    [self heightToFitWithIncrease:0];
}
- (void)heightToFitWithIncrease:(CGFloat)increase {
    if (self.attributedText.length) {
        self.height = [self.attributedText calculateHeightWithLimitWidth:self.width] + increase;
    }else {
        self.height = [self.text calculateHeightWithFont:self.font limitWidth:self.width] + increase;
    }
}
@end
