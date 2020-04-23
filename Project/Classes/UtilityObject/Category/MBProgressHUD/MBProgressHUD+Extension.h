//
//  MBProgressHUD+Extension.h
//  Project
//
//  Created by huxingqin on 2016/12/8.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)
//+ (instancetype)hudView:(UIView *)view text:(NSString *)text;
//+ (instancetype)hudView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled;

/** 显示文本提示信息*/
+ (void)showMessage:(NSString *)message inView:(UIView *)view;
+ (void)showMessage:(NSString *)message inView:(UIView *)view afterDismiss:(NSTimeInterval)time;
/** 成功时，显示信息*/
+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg;
/** 成功时，显示信息*/
+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time;
/** 失败时，显示信息*/
+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg;
/** 失败时，显示信息*/
+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time;

+ (instancetype)showHUDToView:(UIView *)view;
+ (instancetype)showHUDToView:(UIView *)view text:(NSString *)text;
+ (instancetype)showHUDToView:(UIView *)view userInteractionEnabled:(BOOL)enabled;
+ (instancetype)showHUDToView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled;
@end
