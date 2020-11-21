//
//  SystemManager.h
//  Project
//
//  Created by Chenyi on 2016/6/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYFileManager.h"
typedef NS_ENUM(NSUInteger, CoolingTimeType) {
    CoolingTimeTypeVerificationCode,
    CoolingTimeTypeOther,
};
@class UserInfoModel;
@interface SystemManager : NSObject
/** 获取缓存字符串*/
+ (NSString *)getCacheSize;

/** 清除缓存*/
+ (void)clearCacheOnCompleted:(void(^)(BOOL completed))completed;

/** 当前的控制器*/
+ (UIViewController *)currentVC;
+ (UINavigationController *)currentNav;

/** 获取当前状态栏方向*/
+ (BOOL)statusBarOrientationLandscape;

/** 自动登录*/
+ (void)autoLoginCompleted:(void(^)(bool result))completed;

/** 设备通用唯一标识符*/
+ (NSString *)UDID;

/** 标记验证码获取时间*/
+ (BOOL)verificationCodeGotTimeMarking:(CoolingTimeType)type;
/** 获取验证码冷却时间*/
+ (int)verificationCodeCoolingTime:(CoolingTimeType)type;
/** 对应类型的冷却时间（预填）*/
+ (NSInteger)coolingTimes:(CoolingTimeType)type;
@end
