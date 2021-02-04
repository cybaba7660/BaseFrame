//
//  ShadeView.h
//  Project
//
//  Created by CC on 2021/2/4.
//  Copyright © 2021 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OPACITY_SHADE 0.65

NS_ASSUME_NONNULL_BEGIN

@interface ShadeView : UIView
+ (instancetype)newInView:(UIView *)inView addSubView:(UIView *(^)(ShadeView *fatherView))addSubView completionHandler:(void(^)(BOOL result))completionHandler;
- (void)show;
@end

NS_ASSUME_NONNULL_END
