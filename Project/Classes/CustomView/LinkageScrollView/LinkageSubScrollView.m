//
//  LinkageSubScrollView.m
//  Project
//
//  Created by CC on 2020/8/7.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "LinkageSubScrollView.h"
#import "LinkageRootScrollView.h"
@interface LinkageSubScrollView () <UIScrollViewDelegate> {
    LinkageOffset offset;
}
@end
@implementation LinkageSubScrollView
#pragma mark - Set/Get
#pragma mark - External
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
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.linkage_ScrollEnable) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.height;
    if (offsetY <= 0) {
        offset = LinkageOffsetCeil;
    }else if (offsetY >= maxOffsetY) {
        offset = LinkageOffsetFloor;
    }else {
        offset = LinkageOffsetMiddle;
    }
    
    if (offset == LinkageOffsetCeil) {
        self.linkage_ScrollEnable = NO;
        self.linkage_ScrollView.linkage_ScrollEnable = YES;
    }else if (offset == LinkageOffsetFloor) {
        
    }else {
        
    }
}
@end
