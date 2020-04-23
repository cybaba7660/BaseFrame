//
//  CYNavBarView.m
//  Project
//
//  Created by Chenyi on 2018/3/15.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "CYNavBarView.h"
@interface CYNavBarView ()

@property (nonatomic, copy) void(^clickEvent)(void);
@end

@implementation CYNavBarView

+ (instancetype)navBarWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backItemImage:(UIImage *)image backItemClickEvent:(void (^)(void))clickEvent{
    
    CYNavBarView *navBar = [[self alloc] init];
    
    if (title) {
        CGFloat labelW = 160;
        CGFloat labelH = 28;
        CGFloat labelX = ([UIScreen mainScreen].bounds.size.width - 160) * 0.5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 28, labelW, labelH)];
        label.text     = title;
        label.font     = [UIFont boldSystemFontOfSize:17];
        [label setTextAlignment:NSTextAlignmentCenter];
        [navBar addSubview:label];
        if (titleColor) {
            [label setTextColor:titleColor];
        }
    }
    
    if (image) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 32, 20, 21)];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn addTarget:navBar action:@selector(buttonClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:btn];
    }
    
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = [[UIColor lightGrayColor] CGColor];
    line.frame = CGRectMake(0, navBar.bounds.size.height - .7, navBar.bounds.size.width, .7);
    [navBar.layer addSublayer:line];
    
    if (clickEvent) {
        navBar.clickEvent = clickEvent;
    }
    return navBar;
}
- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    return self;
}

- (void)buttonClickEvent {
    if (self.clickEvent) {
        self.clickEvent();
    }
}
@end
