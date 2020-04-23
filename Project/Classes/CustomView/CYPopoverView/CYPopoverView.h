//
//  CYPopoverView.h
//  DoubleColorBall
//
//  Created by Chenyi on 17/1/14.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedIndexPathDelegate;

typedef NS_ENUM(NSUInteger, DirectionType) {
    DirectionTypeOfUpLeft,      // 上左
    DirectionTypeOfUpCenter,    // 上中
    DirectionTypeOfUpRight,     // 上右
    
    DirectionTypeOfDownLeft,    // 下左
    DirectionTypeOfDownCenter,  // 下中
    DirectionTypeOfDownRight,   // 下右
    
    DirectionTypeOfLeftUp,      // 左上
    DirectionTypeOfLeftCenter,  // 左中
    DirectionTypeOfLeftDown,    // 左下
    
    DirectionTypeOfRightUp,     // 右上
    DirectionTypeOfRightCenter, // 右中
    DirectionTypeOfRightDown,   // 右下
};

@interface CYPopoverView : UIView

/** 弹出视图的底层*/
@property (nonatomic, strong) UIView * _Nonnull backGoundView;

/** 单元格的Title*/
@property (nonatomic, copy) NSArray * _Nonnull dataArray;

/** 可以给单元格左侧添加图片*/
@property (nonatomic, copy) NSArray * _Nonnull images;

/** 每一行的高度. 默认为 38*/
@property (nonatomic, assign) CGFloat row_height;

/** 设置每一行的字体*/
@property (nonatomic, assign) CGFloat fontSize;

/** 设置每一行的字体颜色*/
@property (nonatomic, assign) UIColor * _Nonnull titleTextColor;

@property (nonatomic, assign) id <SelectedIndexPathDelegate> _Nonnull delegate;
/** 初始化
 *  @parameter : origin     箭头的顶点
 *  @parameter : width      ---
 *  @parameter : height     ---
 *  @parameter : type       箭头方向
 *  @parameter : color      视图底色
 */
- (instancetype _Nonnull)initWithOrigin:(CGPoint) origin
                                  Width:(CGFloat) width
                                 Height:(CGFloat) height
                                   Type:(DirectionType)type
                                  Color:(UIColor * _Nonnull) color;

/** 显示*/
- (void)popView;

/** 移除*/
//- (void)dismiss;
@end
@protocol SelectedIndexPathDelegate <NSObject>

- (void)popoverView:(CYPopoverView *_Nonnull)popoverView selectIndexPathRow:(NSInteger)index;
@end
