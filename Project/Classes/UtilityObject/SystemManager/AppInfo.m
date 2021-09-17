
//
//  AppInfo.m
//  Project
//
//  Created by Chenyi on 2019/11/17.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo
- (BOOL)haveNewVersion {
//    float appVersion = [CLIENT_VERSION doubleValue];
//    float serviceVersion = [self.version.name integerValue];
//    return appVersion < serviceVersion;
    NSString *appVersion = CLIENT_VERSION;
    NSString *serviceVersion = self.version;
    return ![appVersion isEqualToString:serviceVersion];
}
+ (void)requestVersion {
    [self requestVersionWithCompleted:nil];
}
+ (void)requestVersionWithCompleted:(void(^)(NSString *error, BOOL newVersion))completed {
    [[NetworkManager shareManager] requestAPPUpdateInfoSuccess:^(Result *rs) {
        if (rs.code == 0) {
            AppInfo *info = [AppInfo modelWithDictionary:rs.dict];
            if (!info) {
                completed ? completed(@"未查询到版本信息", nil) : nil;
                return;
            }
            [self dealInfo:info];
            completed ? completed(nil, info.haveNewVersion) : nil;
        }
    } failure:^(Result *rs) {
         completed ? completed(rs.msg, nil) : nil;
    }];
}

+ (void)dealInfo:(AppInfo *)info {
    [info saveToSandbox];
}
+ (void)checkVersion {
    AppInfo *info = AppInfo.info;
    if (info.haveNewVersion) {
        BOOL mandatory = [info.is_force isEqualToString:@"Y"];
        NSString *confirmTitle = @"去更新";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:info.content preferredStyle:UIAlertControllerStyleAlert];
        
        if (!mandatory) {
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancleAction];
        }
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:info.download_url];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }];
        [alert addAction:confirmAction];
        [SystemManager.currentVC presentViewController:alert animated:YES completion:nil];
    }
}
+ (instancetype)info {
    return [AppInfo objectFromSandbox];
}
@end
