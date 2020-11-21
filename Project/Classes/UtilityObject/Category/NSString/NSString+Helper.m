//
//  NSString+Helper.m
//  Project
//
//  Created by Chenyi on 2019/10/11.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)
- (CGFloat)calculateHeightWithFont:(UIFont *)font limitWidth:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

- (CGFloat)calculateWidthWithFont:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}
@end

@implementation NSString (RegEx)
- (NSString *)justChinese {
    return [RegularExpressionTool filterCharactor:self withRegex:@"[^\u4e00-\u9fa5]"];
}
- (NSString *)justNumber {
    return [RegularExpressionTool filterCharactor:self withRegex:@"[^\\d]"];
}
- (NSString *)justDecimal {
    return [RegularExpressionTool filterCharactor:self withRegex:@"[^\\d.]"];
}
- (NSString *)justLetterOrNumber {
    return [RegularExpressionTool filterCharactor:self withRegex:@"[^a-zA-Z0-9]"];
}
- (NSString *)justNotSymbol {
    return [RegularExpressionTool filterCharactor:self withRegex:@"[\u4e00-\u9fa5_a-zA-Z0-9]"];
}
@end
@implementation NSAttributedString (Category)
- (CGFloat)calculateHeightWithLimitWidth:(CGFloat)width {
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

- (CGFloat)calculateWidth {
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
}
@end
