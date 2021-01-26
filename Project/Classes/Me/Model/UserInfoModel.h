//
//  UserInfoModel.h
//  PKYL
//
//  Created by huxingqin on 2017/7/2.
//  Copyright © 2017年 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *token;
/**
 * @discussion  获取当前用户模型
 * @return      当前用户
 */
+ (instancetype)currentUser;
/**
 * @description 移除当前用户模型
 */
+ (void)removeCurrentUser;
/**
 * @description 保存用户信息到本地
 */
- (void)saveUserInfo;
- (void)saveUserInfoWithUserName:(NSString *)userName psw:(NSString *)psw;
/**
 * @discussion  获取用户名
 * @return      用户名
 */
+ (NSString *)userName;
/**
 * @discussion  获取用户密码
 * @return      密码
 */
+ (NSString *)password;
/**
 * @description 保存用户名和密码
 * @param       username  用户名
 * @param       password  密码
 */
//+ (void)saveUserName:(NSString *)username password:(NSString *)password;
/**
 * @description 设置密码记住状态
 * @param       remember  密码记住状态(YES: 记住;  NO: 不记住)
 */
+ (void)setRememberPswStatus:(BOOL)remember;
/**
 * @discussion  密码记住状态
 * @return      YES: 记住;  NO: 不记住
 */
+ (BOOL)passwordRemembered;

+ (BOOL)loginStatus;
/**
 检查登录状态
 @param going 如果未登录，是否跳转登录页面
 */
+ (BOOL)checkingLoginStatusAndGoingIfNeeded:(BOOL)going;
/**
 检查登录状态
 @param show 如果未登录，是否弹出提示框
 */
+ (BOOL)checkingLoginStatusAndShowTipsIfNeeded:(BOOL)show;

/** 跳转登录界面*/
+ (void)presentLoginVC;

/** 跳转注册界面*/
+ (void)presentRegisterVC;
@end
