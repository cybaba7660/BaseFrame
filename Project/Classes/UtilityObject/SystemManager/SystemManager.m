//
//  SystemManager.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "SystemManager.h"
#import <SDWebImage/SDImageCache.h>

#define APP_VERSION_INFO @"APP_VERSION_INFO.plist"
@implementation SystemManager
+ (NSString *)getCacheSize
{
    NSUInteger cacheSize = [YYWebImageManager sharedManager].cache.diskCache.totalCost;
//    NSUInteger cacheSize = [[SDImageCache sharedImageCache] totalDiskSize];
    CGFloat tempSize     = cacheSize * 1.0 / 1024 / 1024;
    NSString *cacheStr   = tempSize >= 1.0 ? [NSString stringWithFormat:@"%.2f MB", tempSize] : [NSString stringWithFormat:@"%.2f KB", tempSize * 1024];
    return cacheStr;
}

+ (void)clearCacheOnCompleted:(void(^)(BOOL completed))completed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[SystemManager currentVC].view animated:YES];
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        completed ? completed(YES) : nil;
    });
    /*
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [hud hideAnimated:YES];
        completed ? completed(YES) : nil;
    }];*/
}

+ (UINavigationController *)currentNav {
    return [[self currentVC] navigationController];
}
+ (UIViewController *)currentVC {
    UIViewController *vc = KeyWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        vc = [nav visibleViewController];
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)vc;
        vc = tabbar.selectedViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        }
    }
    
//    while (vc.presentingViewController) {
//        vc = vc.presentingViewController;
//    }
    
    return vc;
}
+ (BOOL)statusBarOrientationLandscape {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = NO;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            isLandscape = NO;
            break;
        
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isLandscape = YES;
            break;
    
        default:
            break;
    }
    return isLandscape;
}
#pragma mark - 登录
+ (void)autoLoginCompleted:(void(^)(bool result))completed {
//    BOOL loginStatus = [UserInfoModel loginStatus];
//    NSString *userName = [UserInfoModel userName];
//    NSString *password = [UserInfoModel password];
//    if (loginStatus && userName && password) {  // 用户登录过
//        [[NetworkManager shareManager] userLoginWithUsername:userName password:password success:^(Result * _Nonnull rs) {
//            NSLog(@"自动登录成功");
//            NSDictionary *user = rs.dict[@"user"];
//            UserInfoModel *model = [UserInfoModel modelWithDictionary:user];
//            [model saveUserInfo];
//            [NotificationCenter postNotificationName:kUserLoginNotification object:model];
//            completed ? completed(YES) : nil;
//        } failure:^(Result *rs) {
//            [MBProgressHUD showMessage:[NSString stringWithFormat:@"自动登录失败，%@", rs.msg] inView:KeyWindow];
//            [UserInfoModel removeCurrentUser];
//            completed ? completed(NO) : nil;
//        }];
//    }else {
//        completed ? completed(NO) : nil;
//    }
}

+ (NSString *)UDID {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *key = [bundleID stringByAppendingString:@"udid"];
    NSString *service = @"udid";
    NSString *uDID = [SAMKeychain passwordForService:service account:key];
    if (uDID.length) {
        return uDID;
    }else {
        uDID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSError *error = nil;
        BOOL result = [SAMKeychain setPassword:uDID forService:service account:key error:&error];
        if (result) {
            return uDID;
        }else {
            return error.domain;
        }
    }
}

+ (BOOL)verificationCodeGotTimeMarking:(CoolingTimeType)type {
    [UserDefaults setDouble:[NSDate currentTimestamp] forKey:[self coolingTimeTypeKeys:type]];
    return [UserDefaults synchronize];
}
+ (int)verificationCodeCoolingTime:(CoolingTimeType)type {
    NSTimeInterval lastTimestamp = [UserDefaults doubleForKey:[self coolingTimeTypeKeys:type]];
    NSTimeInterval now = [NSDate currentTimestamp];
    NSTimeInterval interval = now - lastTimestamp;
    return [self coolingTimes:type] - interval;
}
+ (NSString *)coolingTimeTypeKeys:(CoolingTimeType)type {
    NSArray *keys = @[
        @"kCoolingTimeVerificationCode",
        @"kCoolingTimeOther"
    ];
    return keys[type];
}
+ (NSInteger)coolingTimes:(CoolingTimeType)type {
    NSArray *times = @[
        @60,
        @999
    ];
    return [times[type] integerValue];
}
@end
