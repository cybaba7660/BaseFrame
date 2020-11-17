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
    
    UIColor *unselectedItemColor = UIColor.lightGrayColor;
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:unselectedItemColor];
    }else {
        NSDictionary *attr       = @{
                NSForegroundColorAttributeName : unselectedItemColor,
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
    
    NSArray *normalImagesName = @[@"tabbar_home", @"tabbar_second", @"tabbar_third", @"tabbar_me"];
    NSArray *selectedImagesName = @[@"tabbar_home_press", @"tabbar_second_press", @"tabbar_third_press", @"tabbar_me_press"];
    NSArray *tabbarTitles = @[@"首页", @"活动", @"发现", @"我的"];
    NSArray *vcClasses = @[[HomeVC class], [SecondVC class], [ThirdVC class], [MeVC class]];
    NSMutableArray *navs = @[].mutableCopy;
    for (int i = 0; i < tabbarTitles.count; i ++) {
        UIImage *normalImage = [[UIImage imageNamed:normalImagesName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImage = [[UIImage imageNamed:selectedImagesName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:tabbarTitles[i] image:normalImage selectedImage:selImage];
        UIViewController *vc    = [[vcClasses[i] alloc] init];
        vc.tabBarItem = tabbarItem;
        UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [navs addObject:nav];
    }
    self.viewControllers = navs;
    
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
