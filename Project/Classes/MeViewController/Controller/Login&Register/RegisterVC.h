//
//  RegisterVC.h
//  Project
//
//  Created by Chenyi on 2019/9/5.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterVC : BaseViewController
@property (nonatomic, copy) void(^registerCompleted)(BOOL completed, NSString *account, NSString *psw);
@end

NS_ASSUME_NONNULL_END
