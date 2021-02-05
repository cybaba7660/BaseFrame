//
//  UILabel+Helper.h
//  Project
//
//  Created by Chenyi on 2019/11/19.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Helper)

//Text
- (void)widthToFit;
- (void)widthToFitWithIncrease:(CGFloat)increase;
- (void)heightToFit;
- (void)heightToFitWithIncrease:(CGFloat)increase;

//AttributedText
- (void)widthToFitByAttributedText;
- (void)widthToFitByAttributedTextWithIncrease:(CGFloat)increase;
- (void)heightToFitByAttributedText;
- (void)heightToFitByAttributedTextWithIncrease:(CGFloat)increase;
@end

NS_ASSUME_NONNULL_END
