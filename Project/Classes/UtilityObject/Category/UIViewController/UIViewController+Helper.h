//
//  UIViewController+Helper.h
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Helper)
/** 设置导航栏透明度*/
@property (strong, nonatomic) NSNumber *navBarBgAlpha;

- (void)popCurrentVCAndPushVC:(UIViewController *)toVC animated:(BOOL)animated;
@end
NS_ASSUME_NONNULL_END
