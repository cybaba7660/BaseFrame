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
+ (void)showInView:(UIView *)inView imageName:(NSString *)imageName tips:(NSString *)tips refreshText:(NSString * __nullable)refreshText refreshEvent:(CallBackBlock __nullable)refreshEvent;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
