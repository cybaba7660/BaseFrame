//
//  UIButton+Helper.h
//  Project
//
//  Created by CC on 2020/8/23.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Helper)
- (void)widthToFit;
- (void)widthToFitWithIncrease:(CGFloat)increase;
- (void)heightToFit;
- (void)heightToFitWithIncrease:(CGFloat)increase;
@end

NS_ASSUME_NONNULL_END
