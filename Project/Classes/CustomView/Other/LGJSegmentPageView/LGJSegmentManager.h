//
//  LGJSegmentManager.h
//  LGJSegmentHeaderPage
//
//  Created by 劉光軍 on 2017/6/20.
//  Copyright © 2017年 劉光軍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGJSegmentHead.h"
#import "LGJSegmentScroll.h"
#import "LGJSegmentPageH.h"

@interface LGJSegmentManager : NSObject

/**
 *  绑定两个view
 */
+ (void)associateHead:(LGJSegmentHead *)head
           withScroll:(LGJSegmentScroll *)scroll
           completion:(void(^)(void))completion;
+ (void)associateHead:(LGJSegmentHead *)head        withScroll:(LGJSegmentScroll *)scroll
     contentChangeAni:(BOOL)ani
           completion:(void (^)(void))completion
            selectEnd:(void(^)(NSInteger index))selectEnd;

@end
