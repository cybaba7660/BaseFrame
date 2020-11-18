//
//  NSObject+Helper.m
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "NSObject+Helper.h"
@implementation NSObject (Helper)
- (void)setCy_mark:(BOOL)cy_mark {
    objc_setAssociatedObject(self, @selector(cy_mark), @(cy_mark), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)cy_mark {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setCy_selected:(BOOL)cy_selected {
    objc_setAssociatedObject(self, @selector(cy_selected), @(cy_selected), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)cy_selected {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setCy_obj:(NSObject *)cy_obj {
    objc_setAssociatedObject(self, @selector(cy_obj), cy_obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSObject *)cy_obj {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCy_obj1:(NSObject *)cy_obj1 {
    objc_setAssociatedObject(self, @selector(cy_obj1), cy_obj1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSObject *)cy_obj1 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCy_obj2:(NSObject *)cy_obj2 {
    objc_setAssociatedObject(self, @selector(cy_obj2), cy_obj2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSObject *)cy_obj2 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCy_index:(NSUInteger)cy_index {
    objc_setAssociatedObject(self, @selector(cy_index), @(cy_index), OBJC_ASSOCIATION_ASSIGN);
}
- (NSUInteger)cy_index {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setCy_indexPath:(NSIndexPath *)cy_indexPath {
    objc_setAssociatedObject(self, @selector(cy_indexPath), cy_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSIndexPath *)cy_indexPath {
    return objc_getAssociatedObject(self, _cmd);
}
@end
@implementation NSObject (Keyboard)
- (void)setChangeFrameBlock:(KeyboardWillChangeFrameBlock)changeFrameBlock {
    objc_setAssociatedObject(self, @selector(changeFrameBlock), changeFrameBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (KeyboardWillChangeFrameBlock)changeFrameBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)registerKeyboardWillChangeFrameNotification:(KeyboardWillChangeFrameBlock)changeFrameBlock {
    self.changeFrameBlock = changeFrameBlock;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameEvent:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)keyboardWillChangeFrameEvent:(NSNotification *)notification {
    CGRect keyboredBeginFrame = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboredEndFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat yDistance = fabs(keyboredBeginFrame.origin.y - keyboredEndFrame.origin.y);
    if (!floor(yDistance)) {
        return;
    }
    //动画修改对应的视图位置
    self.changeFrameBlock ? self.changeFrameBlock(keyboredEndFrame.origin.y, duration) : nil;
    //键盘弹出或变化
    
    if (keyboredBeginFrame.origin.y > keyboredEndFrame.origin.y || (keyboredBeginFrame.size.height != yDistance)) {
        NSLog(@"键盘弹出或变化");
    }else { //键盘收起
        NSLog(@"键盘收起");
    }
}
- (void)resignNotificationObserver {
    self.changeFrameBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@implementation NSObject (Sandbox)
+ (instancetype)objectFromSandbox {
    NSString *plistPath = [self filePath];
    if ([FileManager fileExistsAtPath:plistPath]) {
        NSDictionary *dict  = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSObject *obj = [self mj_objectWithKeyValues:dict];
        return obj;
    }else {
        return nil;
    }
}
+ (BOOL)removeObjectFromSandbox {
    NSError *err;
    [FileManager removeItemAtPath:[self filePath] error:&err];
    NSLog(@"%@", err ? @"移除失败" : @"移除成功");
    return err ? NO : YES;
}
- (void)saveToSandbox {
    BOOL rs = [[self mj_keyValues] writeToFile:[self.class filePath] atomically:YES];
    if (rs) {
        NSLog(@"保存版本信息成功");
    }else {
        NSLog(@"保存版本信息失败");
    }
}
+ (NSString *)filePath {
    return [self filePathWithName:NSStringFromClass(self.class)];
}
+ (NSString *)filePathWithName:(NSString *)name {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:fileName];
    return plistPath;
}

@end
@implementation NSObject (Runtime)
@end
