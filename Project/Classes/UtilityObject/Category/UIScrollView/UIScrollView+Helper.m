//
//  UIScrollView+Helper.m
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UIScrollView+Helper.h"
#define ResponseListCount 20
@implementation UIScrollView (Helper)
- (void)dealloc {
    [self removeObserverBlocks];
}
- (void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
- (void)endRefreshCount:(NSInteger)count {
    [self endRefreshCount:count maxCount:ResponseListCount];
}
- (void)endRefreshCount:(NSInteger)count maxCount:(NSInteger)maxCount {
    [self.mj_header endRefreshing];
    if (count < maxCount) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.mj_footer endRefreshing];
        [self.mj_footer resetNoMoreData];
    }
}
- (void)endEditingWhenTouched {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingEvent)];
    [self addGestureRecognizer:tap];
}
- (void)endEditingEvent {
    [[SystemManager currentVC].view endEditing:YES];
}
- (void)adjustsContentOffsetWithDestinationPoint:(CGPoint)destinationPoint originalPoint:(CGPoint)originalPoint {
    CGFloat minOffset = 0;
    if (self.contentSize.width > self.contentSize.height) {
        CGFloat maxOffset = self.contentSize.width - self.width;
        if (maxOffset < 0) {
            return;
        }
        CGFloat moveLen = originalPoint.x - destinationPoint.x;
        moveLen = moveLen > minOffset ? moveLen : minOffset;
        moveLen = moveLen < maxOffset ? moveLen : maxOffset;
        [self setContentOffset:CGPointMake(moveLen, 0) animated:YES];
    }else {
        CGFloat maxOffset = self.contentSize.height - self.height;
        if (maxOffset < 0) {
            return;
        }
        CGFloat moveLen = originalPoint.y - destinationPoint.y;
        moveLen = moveLen > minOffset ? moveLen : minOffset;
        moveLen = moveLen < maxOffset ? moveLen : maxOffset;
        [self setContentOffset:CGPointMake(0, moveLen) animated:YES];
    }
}
- (void)fillColorAtTheTopWhenPullDown:(UIColor *)fillColor {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
    view.backgroundColor = fillColor;
    view.tag = 26798;
    [self addSubview:view];
    
    __weak typeof(self) weakSelf = self;
    [self addObserverBlockForKeyPath:@"self.contentOffset" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        CGFloat offsetY = [newVal CGPointValue].y;
        offsetY = offsetY > 0 ? 0 : offsetY;
        offsetY = fabs(offsetY);
        UIView *fillView = [weakSelf viewWithTag:26798];
        fillView.frame = CGRectMake(0, -offsetY, fillView.width, offsetY);
    }];
}

//Linkage
- (void)setLinkage_ScrollEnable:(BOOL)linkage_ScrollEnable {
    objc_setAssociatedObject(self, @selector(linkage_ScrollEnable), @(linkage_ScrollEnable), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)linkage_ScrollEnable {
    id value = objc_getAssociatedObject(self, _cmd);
    return [value boolValue];
}
- (void)setLinkage_ScrollView:(UIScrollView *)linkage_ScrollView {
    objc_setAssociatedObject(self, @selector(linkage_ScrollView), linkage_ScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIScrollView *)linkage_ScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)linkage_scrollViewDidScroll {
    if (self.linkage_ScrollView.linkage_ScrollEnable) {
        self.contentOffset = CGPointMake(self.contentOffset.x, 0);
        return;
    }
    CGFloat offsetY = self.contentOffset.y;
    CGFloat maxOffsetY = self.contentSize.height - self.height;
    if (offsetY <= 0) {
        self.linkage_ScrollEnable = NO;
        self.linkage_ScrollView.linkage_ScrollEnable = YES;
    }else if (offsetY >= maxOffsetY) {
    }else {
        
    }
}
@end
