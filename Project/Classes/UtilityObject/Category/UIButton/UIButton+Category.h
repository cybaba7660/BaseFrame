//
//  UIButton+Category.h
//  Project
//
//  Created by Chenyi on 16/5/4.
//  Copyright © 2016年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonImageAlignment) {
    ButtonImageAlignmentLeft,
    ButtonImageAlignmentRight,
    ButtonImageAlignmentTop,
    ButtonImageAlignmentBottom
};
typedef void(^ButtonClickedEvent)(UIButton *button);
@interface UIButton (Category)

- (void)addCallBackAction:(ButtonClickedEvent)action
        forControlEvents:(UIControlEvents)controlEvents;

- (void)addCallBackAction:(ButtonClickedEvent)action;

/**
 调整图片与文字的相对位置
 @param alignment 位置
 @param interval 图片与文字的间距
 */
-(void)setImageAlignment:(ButtonImageAlignment)alignment interval:(CGFloat)interval;
@end

@interface UIButton (EnlargeTouchArea)

/**
 *  扩大 UIButton 的點擊範圍
 *  控制上下左右的延長範圍
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
