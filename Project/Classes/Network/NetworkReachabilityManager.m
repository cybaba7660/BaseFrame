//
//  NetworkReachabilityManager.m
//  Project
//
//  Created by CC on 2020/8/2.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "NetworkReachabilityManager.h"
#import "NENPingManager.h"
@interface NetworkReachabilityManager ()

@end
#define TIME_OUT_INTERVAL 8
@implementation NetworkReachabilityManager
+ (void)testingDomain:(NSString *)domain completionHandler:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    NSURL *url = [NSURL URLWithString:domain];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIME_OUT_INTERVAL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler ? completionHandler(data, response, error) : nil;
    }];
    [task resume];
}
+ (void)testingFatestAddress:(NSArray *)addressList completionHandler:(void(^)(NSString *hostName, NSArray *sortedAddress))completionHandler {
    NENPingManager *manager = [[NENPingManager alloc] init];
    NSMutableArray *arrm = [NSMutableArray array];
    NSArray *removeStrs = @[@"http://", @"https://"];
    for (NSString *domain in addressList) {
        NSString *tempDomain = domain;
        for (NSString *str in removeStrs) {
            if ([domain containsString:str]) {
                tempDomain = [domain substringFromIndex:str.length];
                break;
            }
        }
        NSArray *urls = [tempDomain componentsSeparatedByString:@":"];
        [arrm addObject:urls.firstObject];
    }
    [manager getFatestAddress:arrm completionHandler:^(NSString *hostName, NSArray *sortedAddress) {
        completionHandler ? completionHandler(hostName, sortedAddress) : nil;
    }];
}
@end
