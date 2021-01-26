//
//  LinkageScrollView.m
//  Project
//
//  Created by CC on 2020/8/7.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "LinkageRootScrollView.h"
@interface LinkageRootScrollView () <UIScrollViewDelegate> {
    LinkageOffset offset;
    NSArray<UIScrollView *> *linkedScrollViews;
}
@end
@implementation LinkageRootScrollView
#pragma mark - Set/Get
- (void)setDefaultLinkageIndex:(NSInteger)defaultLinkageIndex {
    _defaultLinkageIndex = defaultLinkageIndex;
    if (linkedScrollViews.count > defaultLinkageIndex) {
        self.linkage_ScrollView = linkedScrollViews[defaultLinkageIndex];
    }
}
#pragma mark - External
- (void)bindingLinkedScrollViews:(NSArray<UIScrollView *> *)scrollViews {
    linkedScrollViews = scrollViews;
    for (UIScrollView *scrollView in scrollViews) {
        scrollView.linkage_ScrollView = self;
    }
    if (scrollViews.count > _defaultLinkageIndex) {
        self.linkage_ScrollView = linkedScrollViews[_defaultLinkageIndex];
    }
}
- (void)switchLinkageIndex:(NSInteger)index {
    self.linkage_ScrollView = linkedScrollViews[index];
}
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.linkage_ScrollEnable = YES;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - CommonMethods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.height;
    if (!self.linkage_ScrollEnable) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, maxOffsetY);
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        offset = LinkageOffsetCeil;
    }else if (offsetY >= maxOffsetY) {
        offset = LinkageOffsetFloor;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, maxOffsetY);
        if (self.linkage_ScrollView.contentSize.height > self.linkage_ScrollView.height) {
            self.linkage_ScrollEnable = NO;
        }
    }else {
        offset = LinkageOffsetMiddle;
    }
    
}
@end
