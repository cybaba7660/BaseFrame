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
@end
