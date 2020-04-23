//
//  UIView+ViewController.m
//  LGJSegmentHeaderPage
//
//  Created by 劉光軍 on 2017/6/19.
//  Copyright © 2017年 劉光軍. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        } else if ([next isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = (UINavigationController *)next;
            return nav.viewControllers.lastObject;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

@end
