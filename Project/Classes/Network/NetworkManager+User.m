//
//  NetworkManager+User.m
//  Project
//
//  Created by Chenyi on 2020/3/9.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "NetworkManager+User.h"

@implementation NetworkManager (User)

- (void)user_registerWithMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code invitation_code:(NSString *)invitation_code success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = @{
        @"mobile" : mobile,
        @"password" : password,
        @"source" : @"app",
        @"code" : code,
        @"mobile_identifying" : [SystemManager UDID]
    }.mutableCopy;
    if (invitation_code.length) {
        param[@"invitation_code"] = invitation_code;
    }
    [self POST:URL_USER_REGISTER parameters:param success:success failure:failure];
}
- (void)user_loginWithMobile:(NSString *)mobile password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSDictionary *param = @{
        @"mobile" : mobile,
        @"password" : password
    };
    [self POST:URL_USER_LOGIN parameters:param success:success failure:failure];
}

@end
