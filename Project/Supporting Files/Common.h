//
//  Common.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#ifndef Common_h
#define Common_h

typedef void(^CallBackBlock)(id obj);

#import "BaseTextField.h"
#import "BaseNavigationController.h"
#import "SystemManager.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "AppInfo.h"
#import "RegularExpressionTool.h"
#import "WebVC.h"
#import "ShadeView.h"

//网络
#import "NetworkManager.h"
#import "NetworkManager+Home.h"
#import "NetworkManager+User.h"

//第三方
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import <SAMKeychain.h>
#import <YYKit.h>

//自定义UI

//类别
#import "NSString+Category.h"
#import "UIButton+Category.h"
#import "UIButton+Helper.h"
#import "UIView+Frame.h"
#import "UIView+Helper.h"
#import "UIImage+Category.h"
#import "UIImage+Helper.h"
#import "MBProgressHUD+Extension.h"
#import "CALayer+Helper.h"
#import "UITextField+Helper.h"
#import "UIImageView+Helper.h"
#import "NSString+Helper.h"
#import "UIViewController+Helper.h"
#import "NSObject+Helper.h"
#import "NSDate+Helper.h"
#import "UIScrollView+Helper.h"
#import "UIView+AbnormalView.h"
#import "UILabel+Helper.h"
#import "UITableView+Helper.h"
#import "UICollectionView+Helper.h"

// 通知名
UIKIT_EXTERN NSString * const kUserLoginNotification;       //用户登录通知
UIKIT_EXTERN NSString * const kUserLogoutNotification;      //用户注销通知
UIKIT_EXTERN NSString * const kUserRegisterNotification;    //用户注册通知
UIKIT_EXTERN NSString * const kUserModifyInfoNotification;  //用户修改资料通知

#endif /* Common_h */
