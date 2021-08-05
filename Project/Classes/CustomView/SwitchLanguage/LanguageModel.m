//
//  LanguageModel.m
//  Project
//
//  Created by Chenyi on 2020/5/25.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "LanguageModel.h"

@implementation LanguageModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id"
    };
}
+ (void)requestLanguageWithCompleted:(void(^)(BOOL finished))completed {
    [[NetworkManager shareManager] appLanguageWithSuccess:^(Result *rs) {
//        NSMutableArray *tempArr = rs.list.mutableCopy;
//        [rs.list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSString *key = @"identy";
//            NSString *identy = obj[key];
//            if ([identy isEqualToString:@"zh"]) {
//                identy = @"zh-Hans";
//                NSMutableDictionary *tempDict = obj.mutableCopy;
//                [tempDict setObject:identy forKey:key];
//                [tempArr replaceObjectAtIndex:idx withObject:tempDict];
//                *stop = YES;
//            }
//        }];
//        rs.list = tempArr;
        BOOL result = [rs.list writeToFile:[self filePath] atomically:YES];
        if (result) {
            NSLog(@"语言列表保存成功");
        }else {
            NSLog(@"语言列表保存失败");
        }
        completed ? completed(YES) : nil;
    } failure:^(Result *rs) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestLanguageWithCompleted:completed];
        });
    }];
}
+ (NSArray<LanguageModel *> *)languageList {
    NSArray *list = [NSArray arrayWithContentsOfFile:[self filePath]];
    NSArray *languageList = [NSArray modelArrayWithClass:LanguageModel.class json:list];
    return languageList;
} 
+ (NSString *)currentLanguageID {
    __block NSString *languageID = nil;
    NSString *currentLanguage = [LanguageManager currentLanguageName];
    NSArray<LanguageModel *> *languageList = [LanguageModel languageList];
    [languageList enumerateObjectsUsingBlock:^(LanguageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentLanguage hasPrefix:obj.identy]) {
            if (!obj.usable.boolValue) {
                for (LanguageModel *model in languageList) {
                    if (model.moren.boolValue) {
                        obj = model;
                    }
                }
            }
            languageID = obj.identy;
            *stop = YES;
        }
    }];
    if (!languageID.length) {
        [[self languageList] enumerateObjectsUsingBlock:^(LanguageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.moren.boolValue) {
                languageID = obj.identy;
                *stop = YES;
            }
        }];
    }
    return languageID;
}
+ (NSString *)currentLanguageName {
    __block NSString *languageName = nil;
    if (LanguageManager.isUsedSystemLanguage) {
        languageName = NSLocalizedString(@"跟随系统", nil);
        return languageName;
    }
    NSString *currentLanguage = [LanguageManager currentLanguageName];
    NSArray<LanguageModel *> *languageList = [LanguageModel languageList];
    [languageList enumerateObjectsUsingBlock:^(LanguageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentLanguage hasPrefix:obj.identy]) {
            if (!obj.usable.boolValue) {
                for (LanguageModel *model in languageList) {
                    if (model.moren.boolValue) {
                        obj = model;
                    }
                }
            }
            languageName = obj.name;
            *stop = YES;
        }
    }];
    if (!languageName.length) {
        [[self languageList] enumerateObjectsUsingBlock:^(LanguageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.moren.boolValue) {
                languageName = obj.name;
                *stop = YES;
            }
        }];
    }
    return languageName;
}
- (NSString *)shortString {
    if (!_shortString) {
        NSString *shortString = self.identy;
        if ([shortString isEqualToString:@"zh"]) {
            shortString = @"zh-Hans";
        }
        _shortString = shortString;
    }
    return _shortString;
}
@end
