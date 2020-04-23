//
//  NSDate+Helper.m
//  Project
//
//  Created by Chenyi on 2019/10/16.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "NSDate+Helper.h"
#define DEFAULT_FORMAT @"YYYY-MM-dd HH:mm:ss"
@implementation NSDate (Helper)
+ (NSDate *)currentDate {
    NSDate *currentDate = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    currentDate = [currentDate dateByAddingTimeInterval:interval];
    return currentDate;
}
+ (NSTimeInterval)currentTimestamp {
    return [[self currentDate] timeIntervalSince1970];
}
+ (NSString *)dateStringWithTimestamp:(NSString *)timeStamp {
    return [self dateStringWithTimestamp:timeStamp format:DEFAULT_FORMAT];
}

+ (NSString *)dateStringWithTimestamp:(NSString *)timeStamp format:(NSString *)format {
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [date format:format];
}
+ (NSString *)crrentDateStringWithFormat:(NSString *)format {
    if (!format) format = DEFAULT_FORMAT;
    NSDate *datenow = [NSDate date];
    return [datenow format:format];
}

+ (NSDate *)customDateType:(CustomDateType)type date:(NSDate *)date {
    return [self customDateType:type date:date intervalDays:0];
}
+ (NSDate *)customDateType:(CustomDateType)type date:(NSDate *)date intervalDays:(NSInteger)intervalDays {
    if (!date) {
        date = [NSDate date];
    }
    NSDate *tempDate = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    [calendar setTimeZone:zone];
    NSDateComponents *components = [calendar components:(NSUIntegerMax) fromDate:tempDate];
    if (type == CustomDateTypeEarliest) {
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
    }else {
        components.hour = 23;
        components.minute = 59;
        components.second = 59;
    }
    if (intervalDays != 0) {
        tempDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:intervalDays toDate:date options:0];
    }
    tempDate = [calendar dateFromComponents:components];
    return tempDate;
}
- (NSString *)format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}
@end
