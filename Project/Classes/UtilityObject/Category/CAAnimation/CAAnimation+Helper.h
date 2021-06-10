//
//  CAAnimation+Helper.h
//  Project
//
//  Created by CC on 2021/6/10.
//  Copyright © 2021 Chenyi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (Helper)
+ (void)selectAnimation:(BOOL)selected inLayer:(CALayer *)layer;
@end

NS_ASSUME_NONNULL_END
