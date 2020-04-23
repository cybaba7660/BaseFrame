//
//  NSDate+Helper.h
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, CustomDateType) {
    CustomDateTypeNone,
    CustomDateTypeEarliest,
    CustomDateTypeLatest
};
@interface NSDate (Helper)
//+ (NSDate *)currentDate;
+ (NSTimeInterval)currentTimestamp;

/** 转化时间戳为时间字符串 */
+ (NSString *)dateStringWithTimestamp:(NSString *)timeStamp;

/** 转化时间戳为时间字符串 */
+ (NSString *)dateStringWithTimestamp:(NSString *)timeStamp format:(NSString *)format;

/** 当前时间 */
+ (NSString *)crrentDateStringWithFormat:(NSString *)format;

+ (NSDate *)customDateType:(CustomDateType)type date:(NSDate *)date;
+ (NSDate *)customDateType:(CustomDateType)type date:(NSDate *)date intervalDays:(NSInteger)intervalDays;
/** 根据格式转换为时间字符串*/
- (NSString *)format:(NSString *)format;
@end
