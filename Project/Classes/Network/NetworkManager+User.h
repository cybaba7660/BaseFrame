//
//  NetworkManager+User.h
//  Project
//
//  Created by Chenyi on 2020/3/9.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "NetworkManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, VerificationCodeType) {
    VerificationCodeTypeRegister = 1,
    VerificationCodeTypeBinding,
    VerificationCodeTypeForgetPassword,
    VerificationCodeTypeModify,
};
@interface NetworkManager (User)

- (void)user_registerWithMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code invitation_code:(NSString *)invitation_code success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)user_loginWithMobile:(NSString *)mobile password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
