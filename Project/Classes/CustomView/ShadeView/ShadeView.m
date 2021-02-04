//
//  ShadeView.m
//  Project
//
//  Created by CC on 2021/2/4.
//  Copyright © 2021 Chenyi. All rights reserved.
//

#import "ShadeView.h"

@interface ShadeView () {
    void(^callBack)(BOOL result);
}
@property (nonatomic, weak) UIView *shadeView;
@end
@implementation ShadeView
#pragma mark - Set/Get
#pragma mark - External
+ (instancetype)newInView:(UIView *)inView addSubView:(UIView *(^)(ShadeView *fatherView))addSubView completionHandler:(void(^)(BOOL result))completionHandler {
    ShadeView *view = [ShadeView.alloc initWithFrame:inView.bounds];
    [inView addSubview:view];
    view->callBack = completionHandler;
    view.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(dismiss)];
    [view addGestureRecognizer:tap];
    
    UIView *shade = [[UIView alloc] initWithFrame:view.bounds];
    view.shadeView = shade;
    shade.backgroundColor = UIColor.blackColor;
    [view addSubview:shade];
    shade.alpha = OPACITY_SHADE;
    
    [view addSubview:addSubView(view)];
    
    return view;
}
- (void)show {
    [self gradualDisplay];
}
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - UI
- (void)setupUI {
    
}
#pragma mark - EventMethods
- (void)dismiss {
    callBack ? callBack(NO) : nil;
    [self gradualDismissAndRemove:YES];
}
#pragma mark - CommonMethods

@end
