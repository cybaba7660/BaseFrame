//
//  LanguageModel.h
//  Project
//
//  Created by Chenyi on 2020/5/25.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//#define LANGUAGE_NAMES_SHORT    @[@"zh-Hans", @"en", @"id", @"vi", @"th"]

@interface LanguageModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identy;
@property (nonatomic, copy) NSString *moren;
@property (nonatomic, copy) NSString *usable;
@property (nonatomic, copy) NSString *shortString;

+ (void)requestLanguageWithCompleted:(void(^)(BOOL finished))completed;
+ (NSArray<LanguageModel *> *)languageList;
+ (NSString *)currentLanguageID;
+ (NSString *)currentLanguageName;
@end

NS_ASSUME_NONNULL_END
