//
//  NetworkManager.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkUrl.h"

#define APP_DOMAIN [NetworkManager shareManager].domain
#define DOMAIN_BY(URL) [[NetworkManager shareManager].domain stringByAppendingString:URL]
#define RESPONSE_CODE   @"code"
#define RESPONSE_DATA   @"data"
#define RESPONSE_MSG    @"msg"
@interface Result : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSArray *list;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSDictionary *dict;
@property (nonatomic, assign) id responseData;
+ (instancetype)dealWithData:(id)responseObj;

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSError *error;
+ (instancetype)dealWithTask:(NSURLSessionDataTask *)task error:(NSError *)error;
@end

typedef void(^SuccessBlock)(Result *rs);
typedef void(^FailureBlock)(Result *rs);

@interface NetworkManager : NSObject

@property (nonatomic, copy) NSString *domain;

+ (instancetype)shareManager;
- (void)GET:(NSString *)url parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)GET:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)POST:(NSString *)url parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)POST:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;

- (void)naturalGET:(NSString *)url parameters:(id)parameters success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;
#pragma mark - start 应用相关
/** 检测更新*/
- (void)requestAPPUpdateInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/** 检测域名*/
+ (void)testingDomainsWithCompleted:(void(^)(BOOL validity))completed;
@end
