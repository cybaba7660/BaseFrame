//
//  UIImageView+Helper.h
//  Project
//
//  Created by Chenyi on 2019/9/23.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Helper)
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) BOOL selected;
- (void)addLongPressToSaveImage;
@end

NS_ASSUME_NONNULL_END
