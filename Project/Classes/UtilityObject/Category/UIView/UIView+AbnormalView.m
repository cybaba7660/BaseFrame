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
        [AbnormalView showInView:self imageName:@"abnormal_image" tips:tips refreshText:NSLocalizedString(@"重新加载", nil) refreshEvent:refreshEvent];
    }else if (type == AbnormalTypeNoData) {
        [AbnormalView showInView:self imageName:@"abnormal_image" tips:tips refreshText:nil refreshEvent:nil];
    }else if (type == AbnormalTypeNotLogged) {
        [AbnormalView showInView:self imageName:@"abnormal_image" tips:tips refreshText:NSLocalizedString(@"马上登录", nil) refreshEvent:refreshEvent];
    }
}
- (void)dismissAbnormalView {
    [self.abnormalView dismiss];
}
@end
