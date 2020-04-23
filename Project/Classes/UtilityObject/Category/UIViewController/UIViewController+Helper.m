//
//  UIViewController+Helper.m
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UIViewController+Helper.h"
#import "UINavigationController+Cloudox.h"
@implementation UIViewController (Helper)

//定义常量 必须是C语言字符串
static char *CloudoxKey = "CloudoxKey";
- (void)setNavBarBgAlpha:(NSNumber *)navBarBgAlpha {
    objc_setAssociatedObject(self, CloudoxKey, navBarBgAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackground:[navBarBgAlpha floatValue]];
}

- (NSNumber *)navBarBgAlpha {
    return objc_getAssociatedObject(self, CloudoxKey) ? : @(1);
}

- (void)popCurrentVCAndPushVC:(UIViewController *)toVC animated:(BOOL)animated {
    NSMutableArray *vcArray = self.navigationController.viewControllers.mutableCopy;
    [vcArray removeObject:self];
    [vcArray addObject: toVC];
    [self.navigationController setViewControllers:vcArray animated:animated];
}

@end
