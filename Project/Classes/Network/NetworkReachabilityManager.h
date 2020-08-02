//
//  NetworkReachabilityManager.h
//  Project
//
//  Created by CC on 2020/8/2.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkReachabilityManager : NSObject
+ (void)testingDomain:(NSString *)domain completionHandler:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
+ (void)testingFatestAddress:(NSArray *)addressList completionHandler:(void(^)(NSString *hostName, NSArray *sortedAddress))completionHandler;
@end

NS_ASSUME_NONNULL_END
