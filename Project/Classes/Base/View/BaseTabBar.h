//
//  BaseTabBar.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TAG_SYSTEM_ITEMS 1200
@interface TabBarItemConfig : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) BOOL raised;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) CommonBlock callBack;
+ (instancetype)configWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage raised:(BOOL)raised index:(NSInteger)index clickedEvent:(CommonBlock)clickedEvent;
@end

@class BaseTabBar;
@protocol BaseTabBarDelegate <NSObject>
- (void)customTabBarItemsDidSelectedAtIndex:(NSInteger)index;
@end

@interface BaseTabBar : UITabBar
@property (weak, nonatomic) id <BaseTabBarDelegate> tabBarDelegate;
- (void)addItemWithConfig:(TabBarItemConfig *)config;
- (void)unselectedCustomItem;
@end
