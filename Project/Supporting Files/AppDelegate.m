//
//  AppDelegate.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchVC.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
static NSString *JPushAppKey = @"d26c424e6a81829f81fc6299";
static NSString *channel     = @"Publish channel";
//static NSString *UMAppKey       = @"5dd5ffe1570df379b8000389";
//static BOOL isProduction     = 1;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initWindow];
    
    //指定根视图
    LaunchVC *vc = [[LaunchVC alloc] init];
    self.window.rootViewController = vc;
    
    self.allowLandscape = NO;
    self.tabBarController = [[BaseTabBarController alloc] init];
    
    // 初始化极光推送
    [self initJPushSDKWithApplication:application options:launchOptions];
    return YES;
}
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
#pragma mark - 极光推送
- (void)initJPushSDKWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:nil apsForProduction:isProduction];
    
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSDictionary *dict = [remoteNotification valueForKey:@"aps"];
            NSString *content  = [dict valueForKey:@"alert"];
            [self goToMssageViewController:content];
        }
    }
    [application cancelAllLocalNotifications];
    [self clearBadge];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(void))completionHandler {
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
/** 注册APNs成功并上报DeviceToken*/
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

/** 实现注册APNs失败接口（可选）*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)) {
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)) {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
      NSDictionary *dict = [userInfo valueForKey:@"aps"];
      NSString *content  = [dict valueForKey:@"alert"];
      [self goToMssageViewController:content];
  }else { // 判断为本地通知
      NSLog(@"jpushNotificationCenter");
  }
  completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}
/** APP未启动时候接收到推送*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"userInfo = %@", userInfo);
    NSDictionary *dict = [userInfo valueForKey:@"aps"];
    NSString *content  = [dict valueForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"UIApplicationStateActive");
    }else {
        [self goToMssageViewController:content];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - 推送跳转界面
- (void)goToMssageViewController:(NSString *)message {
    
}
#pragma mark - 进入后台
- (void)applicationWillResignActive:(UIApplication *)application {
    [self clearBadge];
}
#pragma mark - 进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
#pragma mark - 清除角标
- (void)clearBadge
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
}
#pragma mark - 横竖屏
//在UIApplication实现该方法
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return self.allowLandscape ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}
@end
