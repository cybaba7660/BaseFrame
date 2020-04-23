//
//  CALayer+Helper.m
//  Project
//
//  Created by Chenyi on 2019/8/29.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "CALayer+Helper.h"

@implementation CALayer (Helper)
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors direction:(CALayerDirection)direction {
    return [self gradientLayerWithFrame:frame colors:colors locations:nil direction:direction sequence:GradientLayerSequenceForward];
}
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations direction:(CALayerDirection)direction sequence:(GradientLayerSequence)sequence {
    NSUInteger star = 0 ^ sequence;
    NSUInteger destination = 1 ^ sequence;
    
    CGPoint startPoint = CGPointMake(star, star);
    CGPoint endpoint = CGPointMake(destination, star);
    
    if (direction == CALayerDirectionVertical) {
        endpoint = CGPointMake(star, destination);
    }
    
    return [self gradientLayerWithFrame:frame colors:colors locations:locations startPoint:startPoint endPoint:endpoint];
}
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    NSMutableArray *colorsM = [NSMutableArray arrayWithCapacity:colors.count];
    for (id color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsM addObject:(__bridge id)[(UIColor *)color CGColor]];
        }else {
            [colorsM addObject:color];
        }
    }
    layer.colors = colorsM;
    if (locations) {
        layer.locations = locations;
    }
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    return layer;
}
+ (CAShapeLayer *)dashLineLayerWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor lineDirection:(CALayerDirection)lineDirection pattern:(NSArray<NSNumber *> *)pattern {
    
    CAShapeLayer *dashLine = [CAShapeLayer layer];
    [dashLine setStrokeColor:lineColor.CGColor];
    // 3.0f设置虚线的宽度
    [dashLine setLineWidth:lineDirection ? frame.size.width : frame.size.height];
    [dashLine setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [dashLine setLineDashPattern:pattern];
    [dashLine setLineDashPhase:1];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:frame.origin];
    CGPoint toPoint = CGPointMake(CGRectGetMaxX(frame), frame.origin.y);
    if (lineDirection == CALayerDirectionVertical) {
        toPoint = CGPointMake(frame.origin.x, CGRectGetMaxY(frame));
    }
    [path addLineToPoint:toPoint];
    dashLine.path = path.CGPath;
    return dashLine;
}
@end
