//
//  MBProgressHUD+Extension.m
//  Project
//
//  Created by huxingqin on 2016/12/8.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)
+ (instancetype)hudView:(UIView *)view text:(NSString *)text
{
    return [self hudView:view text:text userInteractionEnabled:NO];
}

+ (instancetype)hudView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text     = text;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled    = enabled;
    return hud;
}
+ (void)showMessage:(NSString *)message inView:(UIView *)view {
    [self showMessage:message inView:view afterDismiss:2];
}
+ (void)showMessage:(NSString *)message inView:(UIView *)view afterDismiss:(NSTimeInterval)time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text     = message;
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled    = NO;
    [hud hideAnimated:YES afterDelay:time];
}
+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3];
    }
}

+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:time];
    }
}

+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failure"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3];
    }
}

+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failure"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:time];
    }
}
+ (instancetype)showHUDToView:(UIView *)view {
    return [self showHUDToView:view text:@""];
}
+ (instancetype)showHUDToView:(UIView *)view text:(NSString *)text {
    return [self showHUDToView:view text:text userInteractionEnabled:NO];
}
+ (instancetype)showHUDToView:(UIView *)view userInteractionEnabled:(BOOL)enabled {
    return [self showHUDToView:view text:@"" userInteractionEnabled:enabled];
}
+ (instancetype)showHUDToView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled {
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = enabled;
        hud.removeFromSuperViewOnHide = YES;
        
        if (text.length) {
            hud.label.text = text;
        }
        /*
        hud.mode = MBProgressHUDModeCustomView;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:20];
        for (int i = 0; i < 20; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i + 1]];
            [images addObject:image];
        }
        UIImage *image = [UIImage animatedImageWithImages:images duration:0.5];
        UIImageView *animatedView = [[UIImageView alloc] initWithImage:image];
        hud.customView = animatedView;*/
        return hud;
    }
    return nil;
}
@end
