//
//  UserInfoModel.m
//  PKYL
//
//  Created by huxingqin on 2017/7/2.
//  Copyright © 2017年 Chenyi. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "UserInfoModel.h"
#import "LoginVC.h"

// 当前用户
static UserInfoModel *currentUser = nil;

// UserDefaults的键值key
static NSString * const UserName = @"UserName"; /**< 用户名   */
static NSString * const UserPSW  = @"UserPSW";  /**< 用户密码 */
static NSString * const REMEMBER_PSW = @"rememberPsw"; /**< 是否记住密码 */

#define FILE_NAME  @"user.plist"

@implementation UserInfoModel

+ (instancetype)currentUser {
    if (!currentUser) {
        NSString *plistPath = [self userinfoPath];
        if ([FileManager fileExistsAtPath:plistPath]) {
            NSDictionary *dict  = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            if (dict) {
                currentUser  = [self modelWithDictionary:dict];
            }
        }
    }
    return currentUser;
}

+ (void)removeCurrentUser {
    currentUser = nil;
    NSError *err;
    [FileManager removeItemAtPath:[self userinfoPath] error:&err];
    NSLog(@"%@", err ? @"移除失败" : @"移除成功");
//    [UserDefaults removeObjectForKey:UserName];
//    [UserDefaults removeObjectForKey:UserPSW];
    [UserDefaults removeObjectForKey:REMEMBER_PSW];
    if (!err) {
        [[SystemManager currentNav] popToRootViewControllerAnimated:NO];
        [self presentLoginVC];
    }
    [NotificationCenter postNotificationName:kUserLogoutNotification object:nil];
//    [KeychainData clearGesturePsw];
    
}

+ (NSString *)userinfoPath {
    NSString *rootPath      = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath     = [rootPath stringByAppendingPathComponent:FILE_NAME];
    return plistPath;
}
- (void)saveUserInfo {
    [self saveUserInfoWithUserName:nil psw:nil];
}
- (void)saveUserInfoWithUserName:(NSString *)userName psw:(NSString *)psw {
    currentUser = self;
    BOOL rs = [[self mj_keyValues] writeToFile:[UserInfoModel userinfoPath] atomically:YES];
    if (rs) {
        NSLog(@"保存用户信息成功");
    }else {
        NSLog(@"保存用户信息失败");
    }
    
    if (userName && psw) {
        [UserInfoModel saveUserName:userName password:psw];
    }
}
+ (BOOL)loginStatus {
    return [self checkingLoginStatusAndGoingIfNeeded:NO];
}
+ (BOOL)checkingLoginStatusAndGoingIfNeeded:(BOOL)going {
    BOOL isLogin = [FileManager fileExistsAtPath:[self userinfoPath]];
    if (!isLogin && going) {
        [self presentLoginVC];
    }
    
    return isLogin;
}
+ (BOOL)checkingLoginStatusAndShowTipsIfNeeded:(BOOL)show {
    BOOL isLogin = [FileManager fileExistsAtPath:[self userinfoPath]];
    if (!isLogin && show) {

    }
    return isLogin;
}
+ (void)presentLoginVC {
    if ([[SystemManager currentVC] isKindOfClass:[LoginVC class]]) {
        return;
    }
    LoginVC *vc = [[LoginVC alloc] initWithHidesBottomBar:YES];
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[SystemManager currentNav] pushViewController:vc animated:YES];
}
+ (void)presentRegisterVC {
    /*
    LoginVC *vc = [[LoginVC alloc] initWithHidesBottomBar:YES];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    RegisterVC *registerVC = [[RegisterVC alloc] initWithHidesBottomBar:YES];
    [nav pushViewController:registerVC animated:NO];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[SystemManager currentVC] presentViewController:nav animated:YES completion:nil];
     */
    RegisterVC *registerVC = [[RegisterVC alloc] initWithHidesBottomBar:YES];
    [[SystemManager currentNav] pushViewController:registerVC animated:YES];
}
+ (NSString *)userName {
    return [UserDefaults objectForKey:UserName];
}

+ (NSString *)password {
    return [UserDefaults objectForKey:UserPSW];
}

+ (void)saveUserName:(NSString *)username password:(NSString *)password {
    [UserDefaults setObject:username forKey:UserName];
    [UserDefaults setObject:password forKey:UserPSW];
    [UserDefaults synchronize];
}

+ (void)setRememberPswStatus:(BOOL)remember {
    [UserDefaults setBool:remember forKey:REMEMBER_PSW];
    [UserDefaults synchronize];
}

+ (BOOL)passwordRemembered {
    return [UserDefaults boolForKey:REMEMBER_PSW];
}
@end
