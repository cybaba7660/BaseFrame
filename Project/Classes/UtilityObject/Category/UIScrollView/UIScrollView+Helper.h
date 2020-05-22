//
//  UIScrollView+Helper.h
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Helper)
- (void)endRefresh;
- (void)endRefreshCount:(NSInteger)count;
- (void)endRefreshCount:(NSInteger)count maxCount:(NSInteger)maxCount;
- (void)endEditingWhenTouched;

/** 设置偏移量移动到指定的点*/
- (void)adjustsContentOffsetWithDestinationPoint:(CGPoint)destinationPoint originalPoint:(CGPoint)originalPoint;
@end

NS_ASSUME_NONNULL_END
