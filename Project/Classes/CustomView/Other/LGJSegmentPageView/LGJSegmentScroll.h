//
//  LGJSegmentScroll.h
//  LGJSegmentHeaderPage
//
//  Created by 劉光軍 on 2017/6/20.
//  Copyright © 2017年 劉光軍. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加子视图的时机
typedef enum:NSUInteger {
    SegmentAddNormal,//滑动或者动画结束
    SegmentAddScale,//根据设置滑动百分比添加0-1
}SegmentAddTiming;

@protocol LGJSegmentScrollDelegate <NSObject>

/**
 *  滑动结束
 */
- (void)scrollEndIndex:(NSInteger)index;
/**
 *  动画结束
 */
- (void)animationEndIndex:(NSInteger)index;
/**
 *  偏移的百分比
 */
- (void)scrollOffsetScale:(CGFloat)scale;

@end

@interface LGJSegmentScroll : UIScrollView

/**
 *  第一次进入是否加载，YES加载 countLImit个页面，默认NO
 */
@property (nonatomic, assign) BOOL loadAll;

/**
 *  缓存页面数目 默认 -all
 */
@property (nonatomic, assign) NSInteger countLimit;

/**
 *  默认显示开始的位置 默认-1
 */
@property (nonatomic, assign) NSInteger showIndex;

/**
 *  代理
 */
@property (nonatomic, assign) id<LGJSegmentScrollDelegate> segmentDelegate;

/**
 *  block
 */
@property (nonatomic, copy) void(^scrollEnd)(NSInteger);
@property (nonatomic, copy) void(^animationEnd)(NSInteger);
@property (nonatomic, copy) void(^offsetScale)(CGFloat);

/**
 *  添加时机，默认动画或者滑动结束添加
 */
@property (nonatomic, assign) SegmentAddTiming addTiming;
/**
 *  SegmentAddScale时 使用
 */
@property (nonatomic, assign) CGFloat addScale;

- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources;

/**
 *  创建之后 初始化
 */
- (void)createView;







@end
