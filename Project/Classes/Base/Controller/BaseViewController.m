//
//  BaseViewController.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
- (instancetype)initWithHidesBottomBar:(BOOL)hide {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = hide;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VC_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarHidden = NO;
    
    
    self.navigationController.navigationBar.barTintColor = [self barTintColor];
    self.navigationController.navigationBar.tintColor    = [self tintColor];
    self.navigationController.navigationBar.barStyle = [self statusBarStyle];
    self.navigationController.navigationBar.translucent = NO;
    
    // 更换返回按钮的图片
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButtonImage;
    [UINavigationBar appearance].backIndicatorImage = backButtonImage;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.blackColor};
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setNavigationBarStyle];
}
- (void)setNavigationBarStyle {
    
}

- (UIBarStyle)statusBarStyle {
    return UIBarStyleDefault;
}

- (UIColor *)barTintColor {
    return COLOR_W(250);
}

- (UIColor *)tintColor {
    return UIColor.blackColor;
}
#pragma mark - Event
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
    return UIStatusBarStyleDefault;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:BaseViewController.class]) {
        [viewController.navigationController setNavigationBarHidden:[(BaseViewController *)viewController navigationBarHidden] animated:animated];
    }
}
@end
