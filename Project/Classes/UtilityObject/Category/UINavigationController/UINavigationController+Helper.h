//
//  UINavigationController+Helper.h
//  Project
//
//  Created by Chenyi on 2019/9/19.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


static char const * const ObjectTagKey = "ObjectTag";
@interface UINavigationController (Helper) <UINavigationBarDelegate, UINavigationControllerDelegate>
@property(readwrite, getter= isViewTransitionInProgress) BOOL viewTransitionInProgress;
@end

NS_ASSUME_NONNULL_END
