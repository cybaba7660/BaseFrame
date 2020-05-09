//
//  RegularExpressionTool.h
//  Project
//
//  Created by Chenyi on 2019/9/6.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegularExpressionTool : NSObject
/** 判断是否6-16位字母或数字组成，至少包含字母数字各一个，不能包含非法字符*/
+ (BOOL)judgeAccountLegal:(NSString *)string;
/** 判断是否6~16位任意字符！不能全是数字*/
+ (BOOL)judgePasswordLegal:(NSString *)string;
/** 判断是否纯中文*/
+ (BOOL)judgeChineseLegal:(NSString *)string;
/** 判断是否是纯数字*/
+ (BOOL)judgeNumberLegal:(NSString *)string;
/** 判断是否是手机号码*/
+ (BOOL )judgeMobileNumberLegal:(NSString *)string;
/** 判断是否是有效的邮箱 */
+ (BOOL)judgeEmailLegal:(NSString *)string;
/** 根据正则，过滤特殊字符*/ 
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;
@end

NS_ASSUME_NONNULL_END
