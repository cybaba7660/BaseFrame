//
//  UIView+AbnormalView.h
//  Project
//
//  Created by Chenyi on 2019/11/8.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AbnormalView.h"
typedef NS_ENUM(NSUInteger, AbnormalType) {
    AbnormalTypeNetWorkError,
    AbnormalTypeNoData
};
@interface UIView (AbnormalView)
@property (nonatomic, weak) AbnormalView *abnormalView;
- (void)showAbnormalViewWithType:(AbnormalType)type tips:(NSString *)tips refreshEvent:(CallBackBlock)refreshEvent;
- (void)dismissAbnormalView;
@end
