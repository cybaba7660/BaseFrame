//
//  NetworkManager.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NetworkReachabilityManager.h"
#import "NetworkManager.h"
#import "Encryption.h"
#define TOKEN_EXPIRED   2
static NetworkManager *networkInstance;

@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (strong, nonatomic) AFHTTPSessionManager *manager2;

@end

@implementation NetworkManager

+ (instancetype)shareManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t networkToken;
    dispatch_once(&networkToken, ^{
        networkInstance = [super allocWithZone:zone];
        if (isProduction) {
            networkInstance.domain = BASE_URL;
        }else {
            networkInstance.domain = BASE_URL_TEST;
        }
    });
    return networkInstance;
}

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest  = 10;
        _manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    if ([UserInfoModel currentUser].token.length) {
        [_manager.requestSerializer setValue:[UserInfoModel currentUser].token forHTTPHeaderField:@"token"];
    }
    return _manager;
}

- (AFHTTPSessionManager *)manager2 {
    if (_manager2 == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest  = 10;
        _manager2 = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
        _manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager2;
}
- (void)GET:(NSString *)url parameters:(id _Nullable)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self GET:url parameters:parameters progress:nil success:success failure:failure];
}
- (void)GET:(NSString *)url parameters:(id _Nullable)parameters progress:(void (^ _Nullable)(NSProgress *))downloadProgress success:(SuccessBlock)success failure:(FailureBlock)failure {
    if (![url hasPrefix:@"http"]) {
        url = [self.domain stringByAppendingString:url];
    }
    [self.manager GET:url parameters:parameters progress:downloadProgress
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *rs = [Result dealWithData:responseObject];
        if (rs.code == 1) {
            success ? success(rs) : nil;
        }else if (rs.code == TOKEN_EXPIRED) {
            failure ? failure(rs) : nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UserInfoModel removeCurrentUser];
            });
        }else {
            failure ? failure(rs) : nil;
        }
        [self printLogSuccess:YES task:task parameters:parameters response:rs.responseData error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Result *rs = [Result dealWithTask:task error:error];
        failure ? failure(rs) : nil;
        [self printLogSuccess:NO task:task parameters:parameters response:nil error:error];
    }];
}
- (void)POST:(NSString *)url parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self POST:url parameters:parameters progress:nil success:success failure:failure];
}
- (void)POST:(NSString *)url parameters:(id _Nullable)parameters progress:(void (^ _Nullable)(NSProgress *))downloadProgress success:(SuccessBlock)success failure:(FailureBlock)failure {
    if (![url hasPrefix:@"http"]) {
        url = [self.domain stringByAppendingString:url];
    }
    [self.manager POST:url parameters:parameters progress:downloadProgress
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *rs = [Result dealWithData:responseObject];
        if (rs.code == 1) {
            success ? success(rs) : nil;
        }else if (rs.code == TOKEN_EXPIRED) {
            failure ? failure(rs) : nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UserInfoModel removeCurrentUser];
            });
        }else {
            failure ? failure(rs) : nil;
        }
        [self printLogSuccess:YES task:task parameters:parameters response:rs.responseData error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Result *rs = [Result dealWithTask:task error:error];
        failure ? failure(rs) : nil;
        [self printLogSuccess:NO task:task parameters:parameters response:nil error:error];
    }];
}
- (void)naturalGET:(NSString *)url parameters:(id)parameters success:(void(^)(id response))success failure:(void(^)(NSString *error))failure {
    [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success ? success(responseData) : nil;
        [self printLogSuccess:YES task:task parameters:parameters response:responseData error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorText = error.userInfo[@"NSLocalizedDescription"];
        failure ? failure(errorText) : nil;
        [self printLogSuccess:NO task:task parameters:parameters response:nil error:error];
    }];
}
- (void)printLogSuccess:(BOOL)success task:(NSURLSessionDataTask *)task parameters:(NSDictionary *)parameters response:(id)response error:(NSError *)error {
    if (success) {
        NSLog(@"%@", [NSString stringWithFormat:@"\n-----------------------------------\n🤮API：%@\n🤮RESULT：✅✅✅✅✅✅✅✅✅✅✅✅✅✅\n🤮METHOD：%@\n🤮PARAMS：%@\n🤮DATA：%@\n\n-----------------------------------\n", task.currentRequest.URL, task.currentRequest.HTTPMethod, parameters, response]);
    }else {
        NSString *errorText = error.userInfo[@"NSLocalizedDescription"];
        NSLog(@"%@", [NSString stringWithFormat:@"\n-----------------------------------\n🤮API：%@\n🤮RESULT：❌❌❌❌❌❌❌❌❌❌❌❌❌❌\n🤮METHOD：%@\n🤮PARAMS：%@\n🤮ERROR：%@\n\n-----------------------------------\n", task.currentRequest.URL, task.currentRequest.HTTPMethod, parameters, errorText]);
    }
}
- (void)requestAPPUpdateInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSDictionary *params = @{
        @"type" : @"1"
    };
    [self POST:APP_UPDATE parameters:params success:success failure:failure];
}
- (void)updateUserToken:(NSString *)token {
    [self.manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
}
+ (void)testingDomainsWithCompleted:(void(^)(BOOL validity))completed {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *domains = isProduction ? STATIC_DOMAINS_PRODUCTION : STATIC_DOMAINS_DEVELOPMENT;
            __block NSString *enableDomain = nil;
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            for (NSString *domain in domains) {
                __block BOOL validity = NO;
                [NetworkReachabilityManager testingDomain:domain completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    validity = !error;
                    if (error) {
                        NSLog(@"无效地址：%@，error：%@", domain, error.userInfo[@"NSLocalizedDescription"]);
                    }
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                if (validity) {
                    enableDomain = domain;
                    break;
                }
            }
            if (enableDomain) {
                NSLog(@"检测完成，已使用有效地址: %@", enableDomain);
                [NetworkManager shareManager].domain = enableDomain;
                dispatch_async(dispatch_get_main_queue(), ^{
                    completed ? completed(YES) : nil;
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completed ? completed(NO) : nil;
                });
            }
        });
    });
}
@end

@implementation Result
+ (instancetype)dealWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    Result *rs = [[self alloc] init];
    rs.task = task;
    rs.error = error;
    rs.msg = error.userInfo[@"NSLocalizedDescription"];
    return rs;
}
+ (instancetype)dealWithData:(id)responseObj {
    id responseData = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
    Result *rs = [[self alloc] init];
    [self stringValue:responseData];
    rs.responseData = responseData;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        rs.code = [responseData[@"code"] integerValue];
        rs.msg = responseData[@"msg"];
        id data = responseData[@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            rs.dict = data;
        }else if ([data isKindOfClass:[NSArray class]]) {
            rs.list = data;
        }else {
            rs.data = data;
        }
    }else if ([responseData isKindOfClass:[NSArray class]]) {
        rs.list = responseData;
    }
    return rs;
}
+ (void)stringValue:(id)value {
    if ([value isKindOfClass:[NSDictionary class]]) {
        [self stringValueWithDict:value];
    }else if ([value isKindOfClass:[NSArray class]]) {
        [self stringValueWithArray:value];
    }else if ([value isKindOfClass:[NSNull class]]) {
        value = @"";
    }else if (![value isKindOfClass:[NSString class]]) {
        value = [value stringValue];
    }
}
+ (void)stringValueWithArray:(NSMutableArray *)arrayM {
    for (int i = 0; i < arrayM.count; i ++) {
        id value = arrayM[i];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self stringValueWithDict:value];
        }else if ([value isKindOfClass:[NSArray class]]) {
            [self stringValueWithArray:value];
        }else if ([value isKindOfClass:[NSNull class]]) {
            value = @"";
//            [arrayM replaceObjectAtIndex:i withObject:value];
        }else if (![value isKindOfClass:[NSString class]]) {
            value = [value stringValue];
            [arrayM replaceObjectAtIndex:i withObject:value];
        }
    }

}
+ (void)stringValueWithDict:(NSMutableDictionary *)dicts {
    NSArray *keys = [dicts allKeys];
    for (int i = 0; i < keys.count; i ++) {
        NSString *key = keys[i];
        id value = dicts[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self stringValueWithDict:value];
        }else if ([value isKindOfClass:[NSArray class]]) {
            [self stringValueWithArray:value];
        }else if ([value isKindOfClass:[NSNull class]]) {
            value = @"";
//            [dicts setObject:value forKey:key];
        }else if (![value isKindOfClass:[NSString class]]) {
            value = [value stringValue];
            [dicts setObject:value forKey:key];
        }
    }
}
@end
