//
//  BaseTabBar.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BaseTabBar.h"
#define TAG_ITEM   1100
#define TAG_ITEM_IMAGE  1200
#define TAG_ITEM_LABEL  1300
#define Magin 23
@implementation TabBarItemConfig
+ (instancetype)configWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage raised:(BOOL)raised index:(NSInteger)index clickedEvent:(CommonBlock)clickedEvent {
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
    UIView *lastSelectedCustomItem;
}
@property (nonatomic, copy) CommonBlock itemClickedEvent;
@end

@implementation BaseTabBar
#pragma mark - External
- (void)addItemWithConfig:(TabBarItemConfig *)config {
    [customTabBarConfigs addObject:config];
    
    UIView *customTabBarItem = [[UIView alloc] init];
    customTabBarItem.tag = TAG_ITEM + config.index;
    customTabBarItem.backgroundColor = UIColor.clearColor;
    [self addSubview:customTabBarItem];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTabBarItemClickedEvent:)];
    [customTabBarItem addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.tag = TAG_ITEM_IMAGE;
    imageView.contentMode = UIViewContentModeCenter;
    [customTabBarItem addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.tag = TAG_ITEM_LABEL;
    textLabel.textColor = TABBAT_COLOR;
    textLabel.font = Font_Regular(13);
    textLabel.textAlignment = NSTextAlignmentCenter;
    [customTabBarItem addSubview:textLabel];
    
    imageView.normalImage = config.image;
    imageView.selectedImage = config.selectedImage;
    textLabel.text = config.title;
}
- (void)unselectedCustomItem {
    [(UIImageView *)[lastSelectedCustomItem viewWithTag:TAG_ITEM_IMAGE] setSelected:NO];
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
            UIView *customItem = [self viewWithTag:TAG_ITEM + i];
            customItem.frame = CGRectMake(itemWidth * i, 0, itemWidth, kTabBar_H);
            UIImageView *imageView = [customItem viewWithTag:TAG_ITEM_IMAGE];
            imageView.frame = CGRectMake(0, kDevice_Is_iPhoneX ? 0 : 4, itemWidth, 30);
            UILabel *textLabel = [customItem viewWithTag:TAG_ITEM_LABEL];
            textLabel.frame = CGRectMake(0, kDevice_Is_iPhoneX ? 30 : 29, itemWidth, kDevice_Is_iPhoneX ? 20 : 19);
            if (arrm.firstObject.raised) {
                customItem.top = -Magin;
                customItem.height = kTabBar_H + Magin;
                imageView.height = 30 + Magin;
            }
            [self bringSubviewToFront:customItem];
            [arrm removeObjectAtIndex:0];
        }else {
            UIView *item = systemTabBarItems.firstObject;
            item.frame = CGRectMake(itemWidth * i, 0, itemWidth, kTabBar_H);
            [systemTabBarItems removeObjectAtIndex:0];
        }
    }
}
#pragma mark - ClickedEvent
- (void)customTabBarItemClickedEvent:(UITapGestureRecognizer *)tap {
    UIView *item = tap.view;
    if (lastSelectedCustomItem != item) {
        [(UIImageView *)[lastSelectedCustomItem viewWithTag:TAG_ITEM_IMAGE] setSelected:NO];
        lastSelectedCustomItem = item;
    }
    
    UIImageView *imageView = (UIImageView *)[item viewWithTag:TAG_ITEM_IMAGE];
    imageView.selected ^= 1;
    NSInteger index = item.tag - TAG_ITEM;
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
            UIButton *raisedButton = [self viewWithTag:TAG_ITEM + config.index];
            
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

