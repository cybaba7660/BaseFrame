//
//  LinkageScrollView.m
//  Project
//
//  Created by CC on 2020/8/7.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "LinkageRootScrollView.h"
#import "LinkageSubScrollView.h"
@interface LinkageRootScrollView () <UIScrollViewDelegate> {
    LinkageOffset offset;
}
@end
@implementation LinkageRootScrollView
#pragma mark - Set/Get
#pragma mark - External
- (void)bindingLinkedScrollViews:(NSArray<UIScrollView *> *)scrollViews {
    
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
    }else {
        offset = LinkageOffsetMiddle;
    }
    
    if (offset == LinkageOffsetCeil) {
        
    }else if (offset == LinkageOffsetFloor) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, maxOffsetY);
        if (self.linkage_ScrollView.contentSize.height > self.linkage_ScrollView.height) {
            self.linkage_ScrollEnable = NO;
        }
    }else {
        
    }
}
@end
