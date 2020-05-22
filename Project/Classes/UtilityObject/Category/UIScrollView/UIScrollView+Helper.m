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
        CGFloat moveLen = originalPoint.x - destinationPoint.x;
        moveLen = moveLen > minOffset ? moveLen : minOffset;
        moveLen = moveLen < maxOffset ? moveLen : maxOffset;
        [self setContentOffset:CGPointMake(moveLen, 0) animated:YES];
    }else {
        CGFloat maxOffset = self.contentSize.height - self.height;
        CGFloat moveLen = originalPoint.y - destinationPoint.y;
        moveLen = moveLen > minOffset ? moveLen : minOffset;
        moveLen = moveLen < maxOffset ? moveLen : maxOffset;
        [self setContentOffset:CGPointMake(0, moveLen) animated:YES];
    }
}
@end
