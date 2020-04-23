//
//  CALayer+Helper.h
//  Project
//
//  Created by Chenyi on 2019/8/29.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum: NSUInteger {
    CALayerDirectionHorizontal,
    CALayerDirectionVertical
} CALayerDirection;
typedef enum : NSUInteger {
    GradientLayerSequenceForward,
    GradientLayerSequenceInverted
} GradientLayerSequence;

@interface CALayer (Helper)
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors direction:(CALayerDirection)direction;
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations direction:(CALayerDirection)direction sequence:(GradientLayerSequence)sequence;
+ (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

+ (CAShapeLayer *)dashLineLayerWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor lineDirection:(CALayerDirection)lineDirection pattern:(NSArray<NSNumber *> *)pattern;
@end

NS_ASSUME_NONNULL_END
