//
//  NSString+Helper.h
//  Project
//
//  Created by Chenyi on 2019/10/11.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Helper)
/** 计算文字高度*/
- (CGFloat)calculateHeightWithFont:(UIFont *)font limitWidth:(CGFloat)width;
/** 计算文字宽度 */
- (CGFloat)calculateWidthWithFont:(UIFont *)font limitHeight:(CGFloat)height;
@end
@interface NSString (RegEx)
- (NSString *)justChinese;
- (NSString *)justNumber;
- (NSString *)justDecimal;
- (NSString *)justLetterOrNumber;
@end

@interface NSAttributedString (Category)
- (CGFloat)calculateHeightWithLimitWidth:(CGFloat)width;
- (CGFloat)calculateWidthWithLimitHeight:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
