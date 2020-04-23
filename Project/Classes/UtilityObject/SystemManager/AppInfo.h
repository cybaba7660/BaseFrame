//
//  AppInfo.h
//  Project
//
//  Created by Chenyi on 2019/11/17.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *download_url;
@property (nonatomic, copy) NSString *is_force;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL haveNewVersion;

/** 检查版本*/
+ (void)checkVersion;
+ (void)checkVersionWithCompleted:(void(^)(NSString *error, BOOL newVersion))completed;
@end
