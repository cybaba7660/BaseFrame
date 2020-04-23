//
//  PK-ios
//
//  Created by peikua on 15/9/15.
//  Copyright (c) 2015年 peikua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Category)
/**
 电话号码中间4位*显示
 */
+ (NSString *)getSecrectStringWithPhoneNumber:(NSString*)phoneNum;
/**
 银行卡号中间8位*显示
 */
+ (NSString *)getSecrectStringWithAccountNo:(NSString*)accountNo;
/**
 转为手机格式，默认为-
 */
+ (NSString *)stringMobileFormat:(NSString*)mobile;

/**
 金额数字添加单位（暂时写了万和亿，有更多的需求请参考写法来自行添加）
 */
+ (NSString *)stringChineseFormat:(double)value;
/**
 添加数字的千位符
 */
+ (NSString *)countNumAndChangeformat:(NSString *)num;

@end

