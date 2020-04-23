//
//  LGJSegmentManager.m
//  LGJSegmentHeaderPage
//
//  Created by 劉光軍 on 2017/6/20.
//  Copyright © 2017年 劉光軍. All rights reserved.
//

#import "LGJSegmentManager.h"

@implementation LGJSegmentManager

+ (void)associateHead:(LGJSegmentHead *)head withScroll:(LGJSegmentScroll *)scroll completion:(void (^)(void))completion {
    [LGJSegmentManager associateHead:head withScroll:scroll contentChangeAni:YES completion:completion selectEnd:nil];
}

+ (void)associateHead:(LGJSegmentHead *)head withScroll:(LGJSegmentScroll *)scroll contentChangeAni:(BOOL)ani completion:(void (^)(void))completion selectEnd:(void (^)(NSInteger))selectEnd {
    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    head.showIndex = scroll.showIndex = showIndex;
    head.selectedIndex = ^(NSInteger index) {
        [scroll setContentOffset:CGPointMake(index*scroll.width, 0) animated:ani];
    };
    [head defaultAndCreateView];
    
    scroll.scrollEnd = ^(NSInteger index) {
        [head setSelectIndex:index];
        //在点击之后调用
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.animationEnd = ^(NSInteger index) {
        //在动画结束后调用
        [head animationEnd];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [head changePointScale:scale];
    };
    if (completion) {
        completion();
    }
    [scroll createView];
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}

@end
