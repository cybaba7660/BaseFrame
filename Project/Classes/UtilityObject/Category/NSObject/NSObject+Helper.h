//
//  NSObject+Helper.h
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSObject (Helper)
@property (nonatomic, strong) NSObject *cy_obj;
@property (nonatomic, strong) NSObject *cy_obj1;
@property (nonatomic, strong) NSObject *cy_obj2;
@property (nonatomic, assign) NSUInteger cy_index;
@property (nonatomic, assign) BOOL cy_selected;
@end


@interface NSObject (Keyboard)
typedef void(^KeyboardWillChangeFrameBlock)(CGFloat keyboardY, CGFloat duration);
@property (nonatomic, copy) KeyboardWillChangeFrameBlock changeFrameBlock;
- (void)registerKeyboardWillChangeFrameNotification:(KeyboardWillChangeFrameBlock)changeFrameBlock;
- (void)resignNotificationObserver;
@end

@interface NSObject (Sandbox)
- (void)saveToSandbox;
+ (instancetype)objectFromSandbox;
+ (BOOL)removeObjectFromSandbox;
@end

@interface NSObject (Runtime)

@end
