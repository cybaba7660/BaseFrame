//
//  BaseTabBar.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseTabBar.h"
#define TAG_ADD_ITEMS 1100
#define Magin 23
@implementation TabBarItemConfig
+ (instancetype)configWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage raised:(BOOL)raised index:(NSInteger)index clickedEvent:(CallBackBlock)clickedEvent {
    TabBarItemConfig *config = [[TabBarItemConfig alloc] init];
    config.title = title;
    config.image = image;
    config.selectedImage = selectedImage;
    config.raised = raised;
    config.index = index;
    config.callBack = clickedEvent;
    return config;
}
@end

@interface BaseTabBar ()
{
    NSMutableArray<TabBarItemConfig *> *customTabBarConfigs;
    UIButton *lastSelectedCustomItem;
}
@property (nonatomic, copy) CallBackBlock itemClickedEvent;
@end

@implementation BaseTabBar
#pragma mark - External
- (void)addItemWithConfig:(TabBarItemConfig *)config {
    [customTabBarConfigs addObject:config];
    UIButton *customTabBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    customTabBarItem.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [customTabBarItem setTitle:config.title forState:UIControlStateNormal];
    [customTabBarItem setTitleColor:TABBAT_COLOR forState:UIControlStateNormal];
    [customTabBarItem setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [customTabBarItem setImage:config.image forState:UIControlStateNormal];
    [customTabBarItem setImage:config.selectedImage forState:UIControlStateSelected];
    [customTabBarItem addTarget:self action:@selector(customTabBarItemClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [customTabBarItem setAdjustsImageWhenHighlighted:NO];
    [self addSubview:customTabBarItem];
    customTabBarItem.tag = TAG_ADD_ITEMS + config.index;
    [customTabBarItem setImageAlignment:ButtonImageAlignmentTop interval:3];
}
- (void)unselectedCustomItem {
    lastSelectedCustomItem.selected = NO;
}
#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.shadowImage = [UIImage imageWithColor:UIColor.clearColor];
        customTabBarConfigs = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    Class class = NSClassFromString(@"UITabBarButton");
    NSMutableArray *systemTabBarItems = [NSMutableArray array];
    int totalCount = 0;
    for (UIView *view in self.subviews) {//遍历tabbar的子控件
        if ([view isKindOfClass:class]) {
            view.tag = TAG_SYSTEM_ITEMS + totalCount;
            totalCount ++;
            [systemTabBarItems addObject:view];
        }
    }
    totalCount += customTabBarConfigs.count;
    CGFloat itemWidth = self.width / totalCount;
    NSMutableArray<TabBarItemConfig *> *arrm = [customTabBarConfigs mutableCopy];
    for (int i = 0; i < totalCount; i ++) {
        if (arrm.count && arrm.firstObject.index == i) {
            UIButton *customItem = [self viewWithTag:TAG_ADD_ITEMS + i];
//            [customItem setBorderWidth:2 borderColor:UIColor.redColor];
            customItem.frame = CGRectMake(itemWidth * i, 4, itemWidth, kTabBar_H);
            if (arrm.firstObject.raised) {
                customItem.top = -Magin - 1;
                customItem.height = kTabBar_H + Magin;
//                [customItem setImageAlignment:ButtonImageAlignmentTop interval:5 + Magin / 2];
            }
            [self bringSubviewToFront:customItem];
            [arrm removeObjectAtIndex:0];
        }else {
            UIView *item = systemTabBarItems.firstObject;
//            [item setBorderWidth:2 borderColor:UIColor.redColor];
            item.frame = CGRectMake(itemWidth * i, 0, itemWidth, kTabBar_H);
            [systemTabBarItems removeObjectAtIndex:0];
        }
    }
}
#pragma mark - ClickedEvent
- (void)customTabBarItemClickedEvent:(UIButton *)button {
    if (lastSelectedCustomItem != button) {
        lastSelectedCustomItem.selected = NO;
        lastSelectedCustomItem = button;
    }
    
    button.selected ^= 1;
    NSInteger index = button.tag - TAG_ADD_ITEMS;
    TabBarItemConfig *itemConfig;
    for (TabBarItemConfig *config in customTabBarConfigs) {
        if (config.index == index) {
            itemConfig = config;
            break;
        }
    }
    
    itemConfig.callBack ? itemConfig.callBack(@(index)) : nil;
    if (self.tabBarDelegate && [self.delegate respondsToSelector:@selector(customTabBarItemsDidSelectedAtIndex:)]) {
        [self.tabBarDelegate customTabBarItemsDidSelectedAtIndex:index];
    }
}
//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (!self.isHidden) {
        for (TabBarItemConfig *config in customTabBarConfigs) {
            UIButton *raisedButton = [self viewWithTag:TAG_ADD_ITEMS + config.index];
            
            //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
            CGPoint newP = [self convertPoint:point toView:raisedButton];
            
            //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
            if ([raisedButton pointInside:newP withEvent:event]) {
                return raisedButton;
            }
        }
        return [super hitTest:point withEvent:event];
    }else {
        //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}
@end

