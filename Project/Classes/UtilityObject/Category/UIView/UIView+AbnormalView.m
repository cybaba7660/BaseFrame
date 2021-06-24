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
- (void)showAbnormalViewWithType:(AbnormalType)type tips:(NSString *)tips refreshEvent:(CommonBlock)refreshEvent {
    if (type == AbnormalTypeNetWorkError) {
        NSString *refreshText = refreshEvent ? NSLocalizedString(@"重新加载", nil) : @"";
        [AbnormalView showInView:self imageName:@"abnormal_image" tips:tips refreshText:refreshText refreshEvent:refreshEvent];
    }else if (type == AbnormalTypeNoData) {
        NSString *refreshText = refreshEvent ? NSLocalizedString(@"刷新一下", nil) : @"";
        [AbnormalView showInView:self imageName:@"abnormal_image" tips:tips refreshText:refreshText refreshEvent:refreshEvent];
    }else if (type == AbnormalTypeNotLogged) {
        NSString *refreshText = refreshEvent ? NSLocalizedString(@"马上登录", nil) : @"";
        [AbnormalView showInView:self imageName:@"abnormal_image" tips:tips refreshText:refreshText refreshEvent:refreshEvent];
    }
}
- (void)dismissAbnormalView {
    [self.abnormalView dismiss];
}
@end
