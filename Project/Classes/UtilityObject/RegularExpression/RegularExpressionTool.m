//
//  RegularExpressionTool.m
//  Project
//
//  Created by Chenyi on 2019/9/6.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "RegularExpressionTool.h"

@implementation RegularExpressionTool
+ (BOOL)judgeAccountLegal:(NSString *)string {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [pred evaluateWithObject:string];
    return result;
}
+ (BOOL)judgePasswordLegal:(NSString *)string {
    NSString *regex = @"^(?![\\d]+$)(?![\\D]+$).{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [pred evaluateWithObject:string];
    return result;
}
+ (BOOL)judgeChineseLegal:(NSString *)string {
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [pred evaluateWithObject:string];
    return result;
}
+ (BOOL)judgeNumberLegal:(NSString *)string {
    NSString *regex = @"^[\\d]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [pred evaluateWithObject:string];
    return result;
}
+ (BOOL )judgeMobileNumberLegal:(NSString *)string {
    NSString *regex = @"^1[3-9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [pred evaluateWithObject:string];
    return result;
}

+ (BOOL)judgeEmailLegal:(NSString *)string {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

//根据正则，过滤特殊字符
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
@end
