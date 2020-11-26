//
//  VerificationCodeButton.h
//  Project
//
//  Created by CC on 2020/11/21.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerificationCodeButton : UIButton
+ (instancetype)defaultInit;
- (void)startCoolingTime;
@property (nonatomic, copy) BOOL(^willEnable)(void);
@property (nonatomic, copy) void(^clickedHandler)(void);
@end

NS_ASSUME_NONNULL_END
