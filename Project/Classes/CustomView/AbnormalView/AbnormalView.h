//
//  AbnormalView.h
//  Project
//
//  Created by Chenyi on 2019/11/8.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AbnormalView : UIView
+ (instancetype)showNetworkErrorInView:(UIView *)inView tips:(NSString *)tips refreshEvent:(CallBackBlock)refreshEvent;
- (void)refreshTips:(NSString *)tips;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
