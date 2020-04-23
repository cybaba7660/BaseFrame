//
//  UIView+AbnormalView.m
//  Project
//
//  Created by Chenyi on 2019/11/8.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UIView+AbnormalView.h"

@implementation UIView (AbnormalView)
- (void)setAbnormalView:(AbnormalView *)abnormalView {
    objc_setAssociatedObject(self, @selector(abnormalView), abnormalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AbnormalView *)abnormalView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)showAbnormalViewWithType:(AbnormalType)type tips:(NSString *)tips refreshEvent:(CallBackBlock)refreshEvent {
    if (self.abnormalView) {
        [self.abnormalView refreshTips:tips];
        return;
    }
    if (type == AbnormalTypeNetWorkError) {
        self.abnormalView = [AbnormalView showNetworkErrorInView:self tips:tips refreshEvent:refreshEvent];
    }
}
- (void)dismissAbnormalView {
    [self.abnormalView dismiss];
}
@end
