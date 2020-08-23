//
//  UIButton+Helper.m
//  Project
//
//  Created by CC on 2020/8/23.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "UIButton+Helper.h"

@implementation UIButton (Helper)
- (void)widthToFit {
    [self widthToFitWithIncrease:0];
}
- (void)widthToFitWithIncrease:(CGFloat)increase {
    if (self.currentTitle.length) {
        self.width = [self.currentTitle calculateWidthWithFont:self.titleLabel.font] + increase;
    }else {
        self.width = [self.currentAttributedTitle calculateWidth] + increase;
    }
}
- (void)heightToFit {
    [self heightToFitWithIncrease:0];
}
- (void)heightToFitWithIncrease:(CGFloat)increase {
    if (self.currentTitle.length) {
        self.height = [self.currentTitle calculateHeightWithFont:self.titleLabel.font limitWidth:self.width] + increase;
    }else {
        self.height = [self.currentAttributedTitle calculateHeightWithLimitWidth:self.width] + increase;
    }
}
@end
