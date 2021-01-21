//
//  HomeCyCleViewCell.h
//  Project
//
//  Created by Chenyi on 2019/9/5.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLAnimatedImageView;
NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSString *const kHomeCyCleViewCellID;
@interface HomeCyCleViewCell : UICollectionViewCell
@property (nonatomic, weak, readonly) YYAnimatedImageView *contentImageView;
@end

NS_ASSUME_NONNULL_END
