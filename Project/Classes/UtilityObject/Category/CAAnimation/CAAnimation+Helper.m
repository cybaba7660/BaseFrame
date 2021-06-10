//
//  CAAnimation+Helper.m
//  Project
//
//  Created by CC on 2021/6/10.
//  Copyright © 2021 Chenyi. All rights reserved.
//

#import "CAAnimation+Helper.h"

@implementation CAAnimation (Helper)
+ (void)selectAnimation:(BOOL)selected inLayer:(CALayer *)layer {
    NSArray *valueSel = @[@(0.5), @(1.3), @(1)];
    NSArray *valueUnsel = @[@(0.8), @(1)];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25;
    animation.values = selected ? valueSel : valueUnsel;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:nil];
}
@end
