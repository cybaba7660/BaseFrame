//
//  Encryption.h
//  MRYVideo
//
//  Created by Chenyi on 2019/8/13.
//  Copyright © 2019 HN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Encryption : NSObject
/** 32位小写 */
+(NSString *)MD5ForLower32Bate:(NSString *)str;
/** 32位大写 */
+(NSString *)MD5ForUpper32Bate:(NSString *)str;
/** 16位大写 */
+(NSString *)MD5ForUpper16Bate:(NSString *)str;
/** 16位小写 */
+(NSString *)MD5ForLower16Bate:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
