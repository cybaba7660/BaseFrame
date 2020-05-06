//
//  BaseTabBarController.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTabBarController.h"
#import "BaseViewController.h"
#import "HomeVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"
#import "MeVC.h"
#import <Messages/Messages.h>
@interface BaseTabBarController () <BaseTabBarDelegate, UITabBarControllerDelegate>
@end

@implementation BaseTabBarController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:UIColor.lightGrayColor];
    }else {
        NSDictionary *attr       = @{
                NSForegroundColorAttributeName : UIColor.lightGrayColor,
                //NSFontAttributeName : Font_Regular(13)
            };
            NSDictionary *attrSelect = @{
                NSForegroundColorAttributeName : MAIN_COLOR,
                //NSFontAttributeName : Font_Regular(13)
            };
            [[UITabBarItem appearance] setTitleTextAttributes:attr forState:UIControlStateNormal];
            [[UITabBarItem appearance] setTitleTextAttributes:attrSelect forState:UIControlStateSelected];
    }
    [[UITabBar appearance] setTintColor:MAIN_COLOR];
    //[[UITabBar appearance] setBarTintColor:COLOR_W(69)];
    
    HomeVC   *vc1    = [[HomeVC alloc] init];
    SecondVC *vc2    = [[SecondVC alloc] init];
    ThirdVC  *vc3    = [[ThirdVC alloc] init];
    MeVC     *vc4    = [[MeVC alloc] init];
    
    UIImage *normalImage_1 = [[UIImage imageNamed:@"tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage_1 = [[UIImage imageNamed:@"tabbar_home_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabbarItem_1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:normalImage_1 selectedImage:selImage_1];
    
    UIImage *normalImage_2 = [[UIImage imageNamed:@"tabbar_second"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage_2 = [[UIImage imageNamed:@"tabbar_second_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabbarItem_2 = [[UITabBarItem alloc] initWithTitle:@"活动" image:normalImage_2 selectedImage:selImage_2];
    
    UIImage *normalImage_3 = [[UIImage imageNamed:@"tabbar_third"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage_3 = [[UIImage imageNamed:@"tabbar_third_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabbarItem_3 = [[UITabBarItem alloc] initWithTitle:@"发现" image:normalImage_3 selectedImage:selImage_3];
    
    UIImage *normalImage_4 = [[UIImage imageNamed:@"tabbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage_4 = [[UIImage imageNamed:@"tabbar_me_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabbarItem_4 = [[UITabBarItem alloc] initWithTitle:@"我的" image:normalImage_4 selectedImage:selImage_4];
    
    vc1.tabBarItem = tabbarItem_1;
    vc2.tabBarItem = tabbarItem_2;
    vc3.tabBarItem = tabbarItem_3;
    vc4.tabBarItem = tabbarItem_4;
    
    UINavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:vc4];
    self.viewControllers = @[nav1, nav2, nav3, nav4];
//    self.selectedIndex = 0;
}

#pragma mark - BaseTabBarDelegate

#pragma mark - Event
#pragma mark - Get
#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
        viewController = [(UINavigationController *)viewController visibleViewController];
    }
    
//    [(BaseTabBar *)self.tabBar unselectedCustomItem];
    return YES;
}

#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIInterfaceOrientationMask mask = [self.selectedViewController supportedInterfaceOrientations];
    return mask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
@end
