
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
    float appVersion = [CLIENT_VERSION doubleValue];
    float serviceVersion = [self.version integerValue];
    return appVersion < serviceVersion;
}
+ (void)checkVersion {
    [self checkVersionWithCompleted:nil];
}
+ (void)checkVersionWithCompleted:(void(^)(NSString *error, BOOL newVersion))completed {
    [[NetworkManager shareManager] requestAPPUpdateInfoSuccess:^(Result *rs) {
        if (rs.code) {
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
    if (info.haveNewVersion) {
        BOOL mandatory = [info.is_force isEqualToString:@"Y"];
        NSString *confirmTitle = @"去更新";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发现新版本" preferredStyle:UIAlertControllerStyleAlert];
        if (!mandatory) {
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancleAction];
        }
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:info.download_url];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alert addAction:confirmAction];
        [SystemManager.currentVC presentViewController:alert animated:YES completion:nil];
    }
}
@end
