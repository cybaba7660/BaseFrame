//
//  BaseNavicationController.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UINavigationBarDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}
// 返回按钮的文字置空（在UINavigationController的子类或者分类categary）中添加该方法
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.backBarButtonItem = back;
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(shouldPopOnBackButtonPress)]) {
        shouldPop = [vc performSelector:@selector(shouldPopOnBackButtonPress)];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0.0 < subview.alpha && subview.alpha < 1.0) {
                [UIView animateWithDuration:0.25 animations:^{
                    subview.alpha = 1.0;
                }];
            }
        }
    }
    return NO;
}
#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end
