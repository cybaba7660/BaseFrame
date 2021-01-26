//
//  LinkageScrollView.h
//  Project
//
//  Created by CC on 2020/8/7.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LinkageRootScrollView : UIScrollView
/** defaults 0.*/
@property (nonatomic, assign) NSInteger defaultLinkageIndex;

/** 绑定联动的所有子视图*/
- (void)bindingLinkedScrollViews:(NSArray<UIScrollView *> *)scrollViews;

/** 切换当前联动的子视图*/
- (void)switchLinkageIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
