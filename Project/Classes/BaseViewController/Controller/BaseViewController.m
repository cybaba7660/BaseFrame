//
//  BaseViewController.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () 

@end

@implementation BaseViewController
- (instancetype)initWithHidesBottomBar:(BOOL)hide {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = hide;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VC_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [self barTintColor];
    self.navigationController.navigationBar.tintColor    = [self tintColor];
    self.navigationController.navigationBar.barStyle = [self statusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNavigationBarStyle];
    // 更换返回按钮的图片
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButtonImage;
    [UINavigationBar appearance].backIndicatorImage = backButtonImage;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.translucent = NO;
}
- (void)setNavigationBarStyle {
}

- (UIBarStyle)statusBarStyle {
    return UIBarStyleBlack;
}

- (UIColor *)barTintColor {
    return UIColor.whiteColor;
}

- (UIColor *)tintColor {
    return UIColor.blackColor;
}
#pragma mark - 横屏设置
- (BOOL)shouldAutorotate {
      return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
     return UIInterfaceOrientationPortrait;
}
/** 强制横屏*/
- (void)setupInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        // 从2开始是因为前两个参数已经被selector和target占用
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}
#pragma mark - 状态栏设置
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
