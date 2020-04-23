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
@end
